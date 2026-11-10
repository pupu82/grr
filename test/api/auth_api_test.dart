import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grr/api/auth_api.dart';
import 'package:grr/constants/app_enums.dart';
import 'package:grr/model/auth/login_request.dart';
import 'package:grr/model/auth/register_request.dart';
import 'package:grr/utils/app_exception.dart';

import '../helpers/stub_http_adapter.dart';

AuthApi _api(StubHttpAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test/api/v1'))
    ..httpClientAdapter = adapter;
  return AuthApi(dio);
}

Map<String, dynamic> _userJson() {
  return <String, dynamic>{
    'id': 'uuid-1',
    'employee_code': 'EMP-0001',
    'name': 'Rina',
    'role': 'inspector',
    'status': 'active',
  };
}

void main() {
  group('AuthApi.login', () {
    test('posts employee credentials and parses the session', () async {
      late RequestOptions captured;
      final api = _api(
        StubHttpAdapter((options) async {
          captured = options;
          return jsonResponse(<String, dynamic>{
            'token': 'plain-token',
            'user': _userJson(),
          });
        }),
      );

      final session = await api.login(
        const LoginRequest(employeeCode: 'EMP-0001', password: 'secret'),
      );

      expect(captured.method, 'POST');
      expect(captured.path, '/login');
      expect(captured.data, <String, dynamic>{
        'employee_code': 'EMP-0001',
        'password': 'secret',
      });
      expect(session.token, 'plain-token');
      expect(session.user.role, UserRole.inspector);
    });

    test('maps validation failures to field errors', () async {
      final api = _api(
        StubHttpAdapter(
          (options) async => jsonResponse(<String, dynamic>{
            'message': 'The given data was invalid.',
            'errors': <String, dynamic>{
              'password': <String>['Kata sandi salah.'],
            },
          }, statusCode: 422),
        ),
      );

      await expectLater(
        api.login(
          const LoginRequest(employeeCode: 'EMP-0001', password: 'wrong'),
        ),
        throwsA(
          isA<AppException>()
              .having((e) => e.kind, 'kind', AppExceptionKind.validation)
              .having(
                (e) => e.fieldErrors['password'],
                'password error',
                'Kata sandi salah.',
              ),
        ),
      );
    });

    test('rejects a success response with an unexpected shape', () async {
      final api = _api(
        StubHttpAdapter(
          (options) async => jsonResponse(<String, dynamic>{'status': 'ok'}),
        ),
      );

      await expectLater(
        api.login(
          const LoginRequest(employeeCode: 'EMP-0001', password: 'secret'),
        ),
        throwsA(
          isA<AppException>().having(
            (e) => e.kind,
            'kind',
            AppExceptionKind.invalidResponse,
          ),
        ),
      );
    });
  });

  group('AuthApi.register', () {
    test('sends the registration payload without a role', () async {
      late RequestOptions captured;
      final api = _api(
        StubHttpAdapter((options) async {
          captured = options;
          return jsonResponse(<String, dynamic>{'message': 'created'});
        }),
      );

      await api.register(
        const RegisterRequest(
          employeeCode: 'EMP-0002',
          name: 'Baru',
          password: 'secret',
          passwordConfirmation: 'secret',
        ),
      );

      expect(captured.path, '/register');
      final body = captured.data! as Map<String, dynamic>;
      expect(body['employee_code'], 'EMP-0002');
      expect(body['name'], 'Baru');
      expect(body.containsKey('email'), isFalse);
      expect(body['password'], 'secret');
      expect(body['password_confirmation'], 'secret');
      expect(body.containsKey('role'), isFalse);
    });
  });

  group('AuthApi.logout', () {
    test('posts to the logout endpoint', () async {
      late RequestOptions captured;
      final api = _api(
        StubHttpAdapter((options) async {
          captured = options;
          return jsonResponse(<String, dynamic>{'message': 'logged out'});
        }),
      );

      await api.logout();

      expect(captured.method, 'POST');
      expect(captured.path, '/logout');
    });
  });
}
