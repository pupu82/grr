import 'package:flutter/foundation.dart';

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
/// The UI resolves [kind] into a localized message. [detail] keeps backend or
/// platform context for diagnostics and must never be rendered directly.
@immutable
class AppException implements Exception {
  const AppException({
    required this.kind,
    this.statusCode,
    this.fieldErrors = const <String, String>{},
    this.detail,
  });

  final AppExceptionKind kind;
  final int? statusCode;

  /// Backend validation errors keyed by request field name.
  final Map<String, String> fieldErrors;

  /// Diagnostic context. Never rendered in the UI.
  final String? detail;

  bool get isUnauthorized => kind == AppExceptionKind.unauthorized;

  bool get isForbidden => kind == AppExceptionKind.forbidden;

  @override
  String toString() =>
      'AppException(kind: $kind, statusCode: $statusCode, detail: $detail)';
}
