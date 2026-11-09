import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';
import '../constants/app_enums.dart';
import 'app_config.dart';
import 'app_exception.dart';

/// Supplies the current Sanctum token, or `null` when unauthenticated.
typedef AuthTokenReader = String? Function();

/// Centralized HTTP infrastructure for every API class.
///
/// API classes must reuse [dio] instead of creating their own client, and pages
/// must never touch this class directly.
class ApiRequestClient {
  ApiRequestClient({
    required AppConfig config,
    required this.readAuthToken,
    this.onUnauthorized,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _configure(config);
  }

  final Dio _dio;

  /// Reads the current Sanctum token for the authorization interceptor.
  final AuthTokenReader readAuthToken;

  /// Invoked when the backend rejects the current token with the
  /// `unauthenticated` error code.
  final VoidCallback? onUnauthorized;

  /// Shared Dio instance used by API classes.
  Dio get dio => _dio;

  void _configure(AppConfig config) {
    _dio.options = BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      sendTimeout: AppConstants.sendTimeout,
      responseType: ResponseType.json,
      headers: const <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = readAuthToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // Only `unauthenticated` means the stored token is no longer valid.
          // `invalid_credentials` is a login failure and must not clear a
          // session.
          if (error.response?.statusCode == 401 &&
              _readErrorCode(error.response?.data) !=
                  ErrorCode.invalidCredentials) {
            onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );

    if (config.enableNetworkLogs) {
      _dio.interceptors.add(const _SafeLogInterceptor());
    }
  }
}

/// Runs [request] and translates Dio failures into [AppException].
Future<T> mapRequestErrors<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on DioException catch (error, stackTrace) {
    Error.throwWithStackTrace(toAppException(error), stackTrace);
  }
}

/// Maps a [DioException] into a stable [AppException].
///
/// The backend `code` is preserved so the UI can branch on it. Only the
/// category is exposed; backend messages are kept in [AppException.detail] for
/// diagnostics and never rendered directly.
AppException toAppException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const AppException(kind: AppExceptionKind.timeout);
    case DioExceptionType.connectionError:
      return const AppException(kind: AppExceptionKind.network);
    case DioExceptionType.badCertificate:
      return AppException(
        kind: AppExceptionKind.network,
        detail: error.message,
      );
    case DioExceptionType.cancel:
      return const AppException(kind: AppExceptionKind.cancelled);
    case DioExceptionType.badResponse:
      return _fromResponse(error.response);
    case DioExceptionType.unknown:
      return AppException(
        kind: AppExceptionKind.unknown,
        detail: error.message,
      );
  }
}

AppException _fromResponse(Response<dynamic>? response) {
  final statusCode = response?.statusCode ?? 0;
  final data = response?.data;
  final detail = _readMessage(data);
  final code = _readErrorCode(data);

  return AppException(
    kind: _kindFor(statusCode, code),
    code: code,
    statusCode: statusCode,
    fieldErrors: _readFieldErrors(data),
    detail: detail,
  );
}

AppExceptionKind _kindFor(int statusCode, ErrorCode? code) {
  // The contract's `code` is authoritative; the status is only a fallback.
  switch (code) {
    case ErrorCode.unauthenticated:
    case ErrorCode.invalidCredentials:
      return AppExceptionKind.unauthorized;
    case ErrorCode.accountPending:
    case ErrorCode.accountInactive:
    case ErrorCode.passwordChangeRequired:
    case ErrorCode.forbidden:
      return AppExceptionKind.forbidden;
    case ErrorCode.notFound:
      return AppExceptionKind.notFound;
    case ErrorCode.methodNotAllowed:
      return AppExceptionKind.methodNotAllowed;
    case ErrorCode.validationFailed:
      return AppExceptionKind.validation;
    case ErrorCode.tooManyRequests:
      return AppExceptionKind.tooManyRequests;
    case ErrorCode.httpError:
      return AppExceptionKind.unknown;
    case null:
      break;
  }

  return switch (statusCode) {
    401 => AppExceptionKind.unauthorized,
    403 => AppExceptionKind.forbidden,
    404 => AppExceptionKind.notFound,
    405 => AppExceptionKind.methodNotAllowed,
    409 => AppExceptionKind.conflict,
    422 => AppExceptionKind.validation,
    429 => AppExceptionKind.tooManyRequests,
    0 => AppExceptionKind.invalidResponse,
    >= 500 => AppExceptionKind.server,
    _ => AppExceptionKind.unknown,
  };
}

ErrorCode? _readErrorCode(Object? data) {
  if (data is Map) {
    return ErrorCode.tryParse(data['code']);
  }
  return null;
}

String? _readMessage(Object? data) {
  if (data is Map) {
    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }
  }
  return null;
}

Map<String, String> _readFieldErrors(Object? data) {
  if (data is! Map) {
    return const <String, String>{};
  }
  final errors = data['errors'];
  if (errors is! Map) {
    return const <String, String>{};
  }

  final fieldErrors = <String, String>{};
  for (final entry in errors.entries) {
    final value = entry.value;
    if (value is List && value.isNotEmpty) {
      fieldErrors['${entry.key}'] = '${value.first}';
    } else if (value is String && value.trim().isNotEmpty) {
      fieldErrors['${entry.key}'] = value.trim();
    }
  }
  return fieldErrors;
}

/// Logs request metadata only: method, path, status, and error type.
///
/// Bodies, headers, tokens, and credentials are intentionally excluded.
class _SafeLogInterceptor extends Interceptor {
  const _SafeLogInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('[api] -> ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    debugPrint(
      '[api] <- ${response.statusCode} ${response.requestOptions.path}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode ?? err.type.name;
    debugPrint('[api] !! $status ${err.requestOptions.path}');
    handler.next(err);
  }
}
