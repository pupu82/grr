import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';
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

  /// Invoked when the backend rejects the current token with HTTP 401.
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
          if (error.response?.statusCode == 401) {
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
/// Only the exception category is exposed to the UI; backend messages are kept
/// in [AppException.detail] for diagnostics and never rendered directly.
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

  return switch (statusCode) {
    401 => AppException(
      kind: AppExceptionKind.unauthorized,
      statusCode: statusCode,
      detail: detail,
    ),
    403 => AppException(
      kind: AppExceptionKind.forbidden,
      statusCode: statusCode,
      detail: detail,
    ),
    404 => AppException(
      kind: AppExceptionKind.notFound,
      statusCode: statusCode,
      detail: detail,
    ),
    409 => AppException(
      kind: AppExceptionKind.conflict,
      statusCode: statusCode,
      detail: detail,
    ),
    422 => AppException(
      kind: AppExceptionKind.validation,
      statusCode: statusCode,
      fieldErrors: _readFieldErrors(data),
      detail: detail,
    ),
    0 => const AppException(kind: AppExceptionKind.invalidResponse),
    >= 500 => AppException(
      kind: AppExceptionKind.server,
      statusCode: statusCode,
      detail: detail,
    ),
    _ => AppException(
      kind: AppExceptionKind.unknown,
      statusCode: statusCode,
      detail: detail,
    ),
  };
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
