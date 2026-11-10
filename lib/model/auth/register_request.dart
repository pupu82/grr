import 'package:flutter/foundation.dart';

/// Self-registration payload.
///
/// Matches the `POST /register` body in the API contract. The role is
/// intentionally absent: the backend always creates a pending inspector
/// account and must never accept a client-selected role. The Laravel `User`
/// model has no email column, so no email is sent.
@immutable
class RegisterRequest {
  const RegisterRequest({
    required this.employeeCode,
    required this.name,
    required this.password,
    required this.passwordConfirmation,
  });

  final String employeeCode;
  final String name;
  final String password;
  final String passwordConfirmation;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'employee_code': employeeCode,
      'name': name,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}
