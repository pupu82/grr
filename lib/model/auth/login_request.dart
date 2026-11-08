import 'package:flutter/foundation.dart';

/// Credentials submitted to the Laravel login endpoint.
@immutable
class LoginRequest {
  const LoginRequest({required this.employeeCode, required this.password});

  final String employeeCode;
  final String password;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'employee_code': employeeCode,
      'password': password,
    };
  }
}
