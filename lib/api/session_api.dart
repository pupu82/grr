import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../model/report/session_evaluation_result.dart';
import '../model/report/session_summary.dart';
import '../utils/app_exception.dart';
import '../utils/request.dart';

/// Inspection session endpoints exposed by the Laravel API.
///
/// Only the read-only evaluation endpoint is implemented for now. Session
/// creation and the inspector run flow will be added with their screens.
class SessionApi {
  SessionApi(this._dio);

  final Dio _dio;

  /// Fetches the computed evaluation of a completed session.
  ///
  /// Admin and Manager only. The backend returns `403 forbidden` for an
  /// inspector, so callers must not request it for that role.
  Future<SessionEvaluationResult> fetchEvaluation(String sessionId) {
    return mapRequestErrors(() async {
      final response = await _dio.get<Object?>(
        ApiEndpoints.sessionEvaluation(sessionId),
      );
      return _parseEvaluation(response.data);
    });
  }

  /// Lists all sessions for Admin/Manager, or the current user's sessions for Inspector.
  ///
  /// Supports optional filters: `status`, `team_id`, `part_type_id`.
  Future<List<SessionSummary>> listSessions({String? status}) {
    return mapRequestErrors(() async {
      final query = <String, dynamic>{};
      if (status != null && status.isNotEmpty) {
        query['status'] = status;
      }
      final response = await _dio.get<Object?>(
        ApiEndpoints.sessions(),
        queryParameters: query,
      );
      return _parseSessionList(response.data);
    });
  }

  /// Force-closes an in-progress session. Admin only.
  Future<void> closeSession(String sessionId) {
    return mapRequestErrors(() async {
      await _dio.post<Object?>(ApiEndpoints.sessionClose(sessionId));
    });
  }

  SessionEvaluationResult _parseEvaluation(Object? body) {
    try {
      return SessionEvaluationResult.fromResponse(body);
    } on FormatException {
      throw const AppException(kind: AppExceptionKind.invalidResponse);
    }
  }

  List<SessionSummary> _parseSessionList(Object? body) {
    try {
      final root = body is Map ? body : <String, dynamic>{};
      final data = root['data'];
      final list = data is List ? data : <Object>[];
      return list
          .whereType<Map<String, dynamic>>()
          .map(SessionSummary.fromJson)
          .toList(growable: false);
    } on FormatException {
      throw const AppException(kind: AppExceptionKind.invalidResponse);
    }
  }
}
