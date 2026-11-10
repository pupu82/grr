import 'package:flutter_test/flutter_test.dart';
import 'package:grr/constants/app_enums.dart';
import 'package:grr/model/user/user.dart';

void main() {
  group('User.fromJson', () {
    test('parses a complete payload', () {
      final user = User.fromJson(<String, dynamic>{
        'id': '6f1c9f0e-1111-4222-8333-444455556666',
        'employee_code': 'EMP-0001',
        'name': 'Rina',
        'role': 'admin',
        'status': 'active',
        'registered_via': 'admin',
        'must_change_password': true,
        'approved_at': '2026-11-08T07:30:00+00:00',
        'team': <String, dynamic>{'id': 3, 'name': 'Line 1'},
        'created_at': '2026-11-08T07:30:00+00:00',
      });

      expect(user.uuid, '6f1c9f0e-1111-4222-8333-444455556666');
      expect(user.employeeCode, 'EMP-0001');
      expect(user.name, 'Rina');
      expect(user.role, UserRole.admin);
      expect(user.status, AccountStatus.active);
      expect(user.registeredVia, RegistrationSource.admin);
      expect(user.mustChangePassword, isTrue);
      expect(user.approvedAt, DateTime.parse('2026-11-08T07:30:00+00:00'));
      expect(user.team?.id, 3);
      expect(user.team?.name, 'Line 1');
      expect(user.createdAt, DateTime.parse('2026-11-08T07:30:00+00:00'));
    });

    test('accepts the legacy uuid field', () {
      final user = User.fromJson(<String, dynamic>{
        'uuid': 'uuid-1',
        'employee_code': 'EMP-0001',
      });

      expect(user.uuid, 'uuid-1');
    });

    test('falls back to the employee code when name is missing', () {
      final user = User.fromJson(<String, dynamic>{
        'id': 'uuid-1',
        'employee_code': 'EMP-0002',
      });

      expect(user.name, 'EMP-0002');
      expect(user.team, isNull);
      expect(user.mustChangePassword, isFalse);
    });

    test('keeps unknown enum values null', () {
      final user = User.fromJson(<String, dynamic>{
        'id': 'uuid-1',
        'employee_code': 'EMP-0002',
        'role': 'superuser',
        'status': 'archived',
        'registered_via': 'import',
      });

      expect(user.role, isNull);
      expect(user.status, isNull);
      expect(user.registeredVia, isNull);
    });

    test('rejects a payload without a public id', () {
      expect(
        () => User.fromJson(<String, dynamic>{
          'employee_code': 'EMP-0001',
          'id': 12,
        }),
        throwsFormatException,
      );
    });

    test('rejects a payload without an employee code', () {
      expect(
        () => User.fromJson(<String, dynamic>{'id': 'uuid-1'}),
        throwsFormatException,
      );
    });

    test('serializes back to backend field names', () {
      final user = User.fromJson(<String, dynamic>{
        'id': 'uuid-1',
        'employee_code': 'EMP-0001',
        'role': 'manager',
        'status': 'pending',
        'registered_via': 'self',
      });

      expect(user.toJson(), <String, dynamic>{
        'id': 'uuid-1',
        'employee_code': 'EMP-0001',
        'name': 'EMP-0001',
        'must_change_password': false,
        'role': 'manager',
        'status': 'pending',
        'registered_via': 'self',
      });
    });
  });
}
