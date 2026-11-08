import 'package:flutter/foundation.dart';

/// Self-registration payload.
///
/// The role is intentionally absent: the backend always creates a pending
/// inspector account and must never accept a client-selected role.
@immutable
class RegisterRequest {
  const RegisterRequest({
    required this.employeeCode,
    required this.name,
    required this.password,
    required this.passwordConfirmation,
    this.email,
  });

  final String employeeCode;
  final String name;
  final String password;
  final String passwordConfirmation;
  final String? email;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'employee_code': employeeCode,
      'name': name,
      if (email != null && email!.trim().isNotEmpty) 'email': email!.trim(),
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}
