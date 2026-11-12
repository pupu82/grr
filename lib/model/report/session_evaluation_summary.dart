import 'package:flutter/foundation.dart';

import '../../constants/app_enums.dart';
import '../model_json.dart';

/// Session header returned by the evaluation endpoint.
///
/// Mirrors the `session` object of
/// `GET /api/v1/sessions/{session}/evaluation`. It is a read-only summary, not
/// a full [InspectionSession].
@immutable
class SessionEvaluationSummary {
  const SessionEvaluationSummary({
    this.id,
    this.token,
    this.status,
    this.sessionDate,
    this.responseTimeLimitMs,
    this.startedAt,
    this.completedAt,
    this.samplesCount,
    this.participantsCount,
  });

  factory SessionEvaluationSummary.fromJson(Map<String, dynamic> json) {
    return SessionEvaluationSummary(
      id: readString(json, 'id'),
      token: readString(json, 'token'),
      status: SessionStatus.tryParse(json['status']),
      sessionDate: readDateTime(json, 'session_date'),
      responseTimeLimitMs: readInt(json, 'response_time_limit_ms'),
      startedAt: readDateTime(json, 'started_at'),
      completedAt: readDateTime(json, 'completed_at'),
      samplesCount: readInt(json, 'samples_count'),
      participantsCount: readInt(json, 'participants_count'),
    );
  }

  /// Public session UUID, serialized by the backend as `id`.
  final String? id;

  /// Short, human-readable session token, for example `SES-2026-0001`.
  final String? token;

  /// `null` when the backend returns an unknown status value.
  final SessionStatus? status;

  /// Date-only value, for example `2026-11-12`.
  final DateTime? sessionDate;

  final int? responseTimeLimitMs;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int? samplesCount;
  final int? participantsCount;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    putIfNotNull(json, 'id', id);
    putIfNotNull(json, 'token', token);
    putIfNotNull(json, 'status', status?.apiValue);
    putIfNotNull(json, 'session_date', sessionDate?.toIso8601String());
    putIfNotNull(json, 'response_time_limit_ms', responseTimeLimitMs);
    putIfNotNull(json, 'started_at', startedAt?.toIso8601String());
    putIfNotNull(json, 'completed_at', completedAt?.toIso8601String());
    putIfNotNull(json, 'samples_count', samplesCount);
    putIfNotNull(json, 'participants_count', participantsCount);
    return json;
  }
}
