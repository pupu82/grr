import 'package:flutter/foundation.dart';

import '../constants/app_enums.dart';

/// Stable, project-level error categories exposed to the UI layer.
///
/// Third-party exception types (for example `DioException`) are translated into
/// [AppException] inside `lib/utils/request.dart` so pages never depend on the
/// HTTP client implementation.
enum AppExceptionKind {
  network,
  timeout,
  unauthorized,
  forbidden,
  validation,
  notFound,
  conflict,
  methodNotAllowed,
  tooManyRequests,
  server,
  invalidResponse,
  cancelled,
  sessionRestoreFailed,
  sessionStorageFailed,
  sessionClearFailed,
  unknown,
}

/// Application error carrying a translatable category instead of user-facing
/// text.
///
/// The UI resolves [code] first and falls back to [kind]. [detail] keeps
/// backend or platform context for diagnostics and must never be rendered
/// directly.
@immutable
class AppException implements Exception {
  const AppException({
    required this.kind,
    this.code,
    this.statusCode,
    this.fieldErrors = const <String, String>{},
    this.detail,
  });

  final AppExceptionKind kind;

  /// Machine-readable backend error code, when the response provides one.
  final ErrorCode? code;

  final int? statusCode;

  /// Backend validation errors keyed by request field name.
  final Map<String, String> fieldErrors;

  /// Diagnostic context. Never rendered in the UI.
  final String? detail;

  bool get isUnauthorized => kind == AppExceptionKind.unauthorized;

  bool get isForbidden => kind == AppExceptionKind.forbidden;

  /// True when the backend rejected a missing, invalid or revoked token.
  bool get isUnauthenticated => code == ErrorCode.unauthenticated;

  /// True when the account must change its password before normal use.
  bool get isPasswordChangeRequired => code == ErrorCode.passwordChangeRequired;

  @override
  String toString() =>
      'AppException(kind: $kind, code: ${code?.apiValue}, '
      'statusCode: $statusCode, detail: $detail)';
}
