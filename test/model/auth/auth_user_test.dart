import 'package:flutter_test/flutter_test.dart';
import 'package:grr/constants/app_enums.dart';
import 'package:grr/model/auth/auth_user.dart';

void main() {
  group('AuthUser.fromJson', () {
    test('parses a complete payload', () {
      final user = AuthUser.fromJson(<String, dynamic>{
        'uuid': '6f1c9f0e-1111-4222-8333-444455556666',
        'employee_code': 'EMP-0001',
        'name': 'Rina',
        'email': 'rina@example.test',
        'role': 'admin',
        'status': 'active',
      });

      expect(user.uuid, '6f1c9f0e-1111-4222-8333-444455556666');
      expect(user.employeeCode, 'EMP-0001');
      expect(user.name, 'Rina');
      expect(user.email, 'rina@example.test');
      expect(user.role, UserRole.admin);
      expect(user.status, AccountStatus.active);
    });

    test('falls back to the employee code when name is missing', () {
      final user = AuthUser.fromJson(<String, dynamic>{
        'uuid': 'uuid-1',
        'employee_code': 'EMP-0002',
      });

      expect(user.name, 'EMP-0002');
      expect(user.email, isNull);
    });

    test('keeps unknown roles and statuses null', () {
      final user = AuthUser.fromJson(<String, dynamic>{
        'uuid': 'uuid-1',
        'employee_code': 'EMP-0002',
        'role': 'superuser',
        'status': 'archived',
      });

      expect(user.role, isNull);
      expect(user.status, isNull);
    });

    test('rejects a payload without a public uuid', () {
      expect(
        () => AuthUser.fromJson(<String, dynamic>{
          'employee_code': 'EMP-0001',
          'id': 12,
        }),
        throwsFormatException,
      );
    });

    test('rejects a payload without an employee code', () {
      expect(
        () => AuthUser.fromJson(<String, dynamic>{'uuid': 'uuid-1'}),
        throwsFormatException,
      );
    });

    test('serializes back to backend field names', () {
      final user = AuthUser.fromJson(<String, dynamic>{
        'uuid': 'uuid-1',
        'employee_code': 'EMP-0001',
        'role': 'manager',
        'status': 'pending',
      });

      expect(user.toJson(), <String, dynamic>{
        'uuid': 'uuid-1',
        'employee_code': 'EMP-0001',
        'name': 'EMP-0001',
        'role': 'manager',
        'status': 'pending',
      });
    });
  });
}
