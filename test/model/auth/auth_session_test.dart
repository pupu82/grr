import 'package:flutter_test/flutter_test.dart';
import 'package:grr/constants/app_enums.dart';
import 'package:grr/model/auth/auth_session.dart';

Map<String, dynamic> _userJson({String role = 'inspector'}) {
  return <String, dynamic>{
    'uuid': 'uuid-1',
    'employee_code': 'EMP-0001',
    'name': 'Rina',
    'role': role,
    'status': 'active',
  };
}

void main() {
  group('AuthSession.fromLoginResponse', () {
    test('parses a flat response body', () {
      final session = AuthSession.fromLoginResponse(<String, dynamic>{
        'token': 'plain-token',
        'user': _userJson(),
      });

      expect(session.token, 'plain-token');
      expect(session.user.role, UserRole.inspector);
    });

    test('parses a response wrapped in a data key', () {
      final session = AuthSession.fromLoginResponse(<String, dynamic>{
        'data': <String, dynamic>{
          'token': 'wrapped-token',
          'user': _userJson(role: 'manager'),
        },
      });

      expect(session.token, 'wrapped-token');
      expect(session.user.role, UserRole.manager);
    });

    test('rejects a body without a token', () {
      expect(
        () => AuthSession.fromLoginResponse(<String, dynamic>{
          'user': _userJson(),
        }),
        throwsFormatException,
      );
    });

    test('rejects a body without a user', () {
      expect(
        () => AuthSession.fromLoginResponse(<String, dynamic>{
          'token': 'plain-token',
        }),
        throwsFormatException,
      );
    });

    test('rejects a non-object body', () {
      expect(
        () => AuthSession.fromLoginResponse('unexpected'),
        throwsFormatException,
      );
    });
  });

  group('AuthSession storage serialization', () {
    test('round-trips through toJson and fromJson', () {
      final session = AuthSession.fromLoginResponse(<String, dynamic>{
        'token': 'plain-token',
        'user': _userJson(),
      });

      final restored = AuthSession.fromJson(session.toJson());

      expect(restored, session);
    });

    test('rejects an incomplete stored payload', () {
      expect(
        () => AuthSession.fromJson(<String, dynamic>{'token': 'plain-token'}),
        throwsFormatException,
      );
    });
  });
}
