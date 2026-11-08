import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:grr/generated/localization/app_localizations.dart';
import 'package:grr/utils/app_config.dart';
import 'package:grr/utils/app_exception.dart';
import 'package:grr/utils/error_message.dart';
import 'package:grr/utils/request.dart';

import '../helpers/stub_http_adapter.dart';

const AppConfig _testConfig = AppConfig(
  apiBaseUrl: 'https://api.test/api/v1',
  enableNetworkLogs: false,
);

ApiRequestClient _client({
  required StubHttpAdapter adapter,
  String? token,
  void Function()? onUnauthorized,
}) {
  final dio = Dio()..httpClientAdapter = adapter;
  return ApiRequestClient(
    config: _testConfig,
    readAuthToken: () => token,
    onUnauthorized: onUnauthorized,
    dio: dio,
  );
}

void main() {
  group('ApiRequestClient configuration', () {
    test('applies the configured base URL and JSON headers', () async {
      late RequestOptions captured;
      final client = _client(
        adapter: StubHttpAdapter((options) async {
          captured = options;
          return jsonResponse(<String, dynamic>{'ok': true});
        }),
      );

      await client.dio.get<Object?>('/health');

      expect(captured.baseUrl, 'https://api.test/api/v1');
      expect(captured.path, '/health');
      expect(captured.headers['Accept'], 'application/json');
      expect(captured.headers['Content-Type'], 'application/json');
    });

    test('attaches the bearer token through the interceptor', () async {
      late RequestOptions captured;
      final client = _client(
        token: 'sanctum-token',
        adapter: StubHttpAdapter((options) async {
          captured = options;
          return jsonResponse(<String, dynamic>{'ok': true});
        }),
      );

      await client.dio.get<Object?>('/me');

      expect(captured.headers['Authorization'], 'Bearer sanctum-token');
    });

    test('omits the authorization header when unauthenticated', () async {
      late RequestOptions captured;
      final client = _client(
        adapter: StubHttpAdapter((options) async {
          captured = options;
          return jsonResponse(<String, dynamic>{'ok': true});
        }),
      );

      await client.dio.get<Object?>('/me');

      expect(captured.headers.containsKey('Authorization'), isFalse);
    });

    test('notifies the session owner when the token is rejected', () async {
      var unauthorizedCalls = 0;
      final client = _client(
        token: 'expired-token',
        onUnauthorized: () => unauthorizedCalls++,
        adapter: StubHttpAdapter(
          (options) async => jsonResponse(<String, dynamic>{
            'message': 'Unauthenticated.',
          }, statusCode: 401),
        ),
      );

      await expectLater(
        client.dio.get<Object?>('/me'),
        throwsA(isA<DioException>()),
      );

      expect(unauthorizedCalls, 1);
    });
  });

  group('mapRequestErrors', () {
    test('maps 422 responses to validation errors', () async {
      final client = _client(
        adapter: StubHttpAdapter(
          (options) async => jsonResponse(<String, dynamic>{
            'message': 'The given data was invalid.',
            'errors': <String, dynamic>{
              'employee_code': <String>['Kode karyawan sudah dipakai.'],
            },
          }, statusCode: 422),
        ),
      );

      await expectLater(
        mapRequestErrors(() => client.dio.post<Object?>('/auth/login')),
        throwsA(
          isA<AppException>()
              .having((e) => e.kind, 'kind', AppExceptionKind.validation)
              .having(
                (e) => e.fieldErrors['employee_code'],
                'employee_code error',
                'Kode karyawan sudah dipakai.',
              ),
        ),
      );
    });

    test('maps 401 responses to unauthorized errors', () async {
      final client = _client(
        adapter: StubHttpAdapter(
          (options) async => jsonResponse(<String, dynamic>{
            'message': 'Unauthenticated.',
          }, statusCode: 401),
        ),
      );

      await expectLater(
        mapRequestErrors(() => client.dio.get<Object?>('/me')),
        throwsA(
          isA<AppException>().having(
            (e) => e.kind,
            'kind',
            AppExceptionKind.unauthorized,
          ),
        ),
      );
    });

    test('maps 403 responses to forbidden errors', () async {
      final client = _client(
        adapter: StubHttpAdapter(
          (options) async => jsonResponse(<String, dynamic>{
            'message': 'Forbidden.',
          }, statusCode: 403),
        ),
      );

      await expectLater(
        mapRequestErrors(() => client.dio.get<Object?>('/admin')),
        throwsA(
          isA<AppException>().having(
            (e) => e.kind,
            'kind',
            AppExceptionKind.forbidden,
          ),
        ),
      );
    });

    test('hides server internals for 500 responses', () async {
      final client = _client(
        adapter: StubHttpAdapter(
          (options) async => jsonResponse(<String, dynamic>{
            'message': 'SQLSTATE[08006] connection failure at 10.0.0.4',
          }, statusCode: 500),
        ),
      );

      final l10n = lookupAppLocalizations(const Locale('id'));

      await expectLater(
        mapRequestErrors(() => client.dio.get<Object?>('/reports')),
        throwsA(
          isA<AppException>()
              .having((e) => e.kind, 'kind', AppExceptionKind.server)
              .having(
                (e) => localizeAppException(l10n, e),
                'localized message',
                isNot(contains('SQLSTATE')),
              ),
        ),
      );
    });

    test('maps connection failures to network errors', () async {
      final client = _client(
        adapter: StubHttpAdapter(
          (options) async => throw DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
          ),
        ),
      );

      await expectLater(
        mapRequestErrors(() => client.dio.get<Object?>('/health')),
        throwsA(
          isA<AppException>().having(
            (e) => e.kind,
            'kind',
            AppExceptionKind.network,
          ),
        ),
      );
    });
  });
}
