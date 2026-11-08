import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../model/auth/auth_session.dart';
import '../model/auth/login_request.dart';
import '../model/auth/register_request.dart';
import '../utils/app_exception.dart';
import '../utils/request.dart';

/// Authentication endpoints exposed by the Laravel API.
class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  /// Exchanges employee credentials for a Sanctum token.
  Future<AuthSession> login(LoginRequest request) {
    return mapRequestErrors(() async {
      final response = await _dio.post<Object?>(
        ApiEndpoints.login,
        data: request.toJson(),
      );
      return _parseLoginResponse(response.data);
    });
  }

  /// Registers a pending inspector account.
  Future<void> register(RegisterRequest request) {
    return mapRequestErrors(() async {
      await _dio.post<Object?>(ApiEndpoints.register, data: request.toJson());
    });
  }

  /// Revokes the current Sanctum token.
  Future<void> logout() {
    return mapRequestErrors(() async {
      await _dio.post<Object?>(ApiEndpoints.logout);
    });
  }

  AuthSession _parseLoginResponse(Object? data) {
    try {
      return AuthSession.fromLoginResponse(data);
    } on FormatException {
      throw const AppException(kind: AppExceptionKind.invalidResponse);
    }
  }
}
