import 'package:flutter/foundation.dart';

import '../../constants/app_enums.dart';

/// Authenticated user returned by the backend.
///
/// Public identifiers are UUIDs. Internal database identifiers are never
/// accepted as the primary identifier.
@immutable
class AuthUser {
  const AuthUser({
    required this.uuid,
    required this.employeeCode,
    required this.name,
    this.email,
    this.role,
    this.status,
  });

  /// Parses the user object of a login response.
  ///
  /// Unknown roles and statuses are preserved as `null` instead of being
  /// coerced, so an unexpected backend value never silently grants access.
  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final uuid = _readString(json, const ['uuid']);
    final employeeCode = _readString(json, const [
      'employee_code',
      'employeeCode',
    ]);

    if (uuid == null || uuid.isEmpty) {
      throw const FormatException('Auth user payload is missing "uuid".');
    }
    if (employeeCode == null || employeeCode.isEmpty) {
      throw const FormatException(
        'Auth user payload is missing "employee_code".',
      );
    }

    return AuthUser(
      uuid: uuid,
      employeeCode: employeeCode,
      name:
          _readString(json, const ['name', 'full_name', 'fullName']) ??
          employeeCode,
      email: _readString(json, const ['email']),
      role: UserRole.tryParse(json['role']),
      status: AccountStatus.tryParse(json['status']),
    );
  }

  final String uuid;
  final String employeeCode;
  final String name;
  final String? email;

  /// `null` when the backend returns a role this client does not know.
  final UserRole? role;

  /// `null` when the backend returns a status this client does not know.
  final AccountStatus? status;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'employee_code': employeeCode,
      'name': name,
      if (email != null) 'email': email,
      if (role != null) 'role': role!.apiValue,
      if (status != null) 'status': status!.apiValue,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is AuthUser &&
        other.uuid == uuid &&
        other.employeeCode == employeeCode &&
        other.name == name &&
        other.email == email &&
        other.role == role &&
        other.status == status;
  }

  @override
  int get hashCode =>
      Object.hash(uuid, employeeCode, name, email, role, status);
}

String? _readString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
  }
  return null;
}
