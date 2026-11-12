import 'package:flutter/foundation.dart';

import '../../constants/app_enums.dart';
import '../model_json.dart';

/// Session summary returned by `GET /api/v1/sessions`.
///
/// Mirrors the list response shape of the sessions endpoint.
/// The public identifier is the `id` (UUID); `token` is a human-readable display.
@immutable
class SessionSummary {
  const SessionSummary({
    required this.id,
    this.token,
    this.plantId,
    this.teamId,
    this.partTypeId,
    this.sessionDate,
    this.status,
    this.responseTimeLimitMs,
    this.startedAt,
    this.completedAt,
    this.samplesCount,
    this.participantsCount,
    this.createdAt,
  });

  factory SessionSummary.fromJson(Map<String, dynamic> json) {
    return SessionSummary(
      id: requireString(json, 'id'),
      token: readString(json, 'token'),
      plantId: readInt(json, 'plant_id'),
      teamId: readInt(json, 'team_id'),
      partTypeId: readInt(json, 'part_type_id'),
      sessionDate: readDateTime(json, 'session_date'),
      status: SessionStatus.tryParse(json['status']),
      responseTimeLimitMs: readInt(json, 'response_time_limit_ms'),
      startedAt: readDateTime(json, 'started_at'),
      completedAt: readDateTime(json, 'completed_at'),
      samplesCount: readInt(json, 'samples_count'),
      participantsCount: readInt(json, 'participants_count'),
      createdAt: readDateTime(json, 'created_at'),
    );
  }

  /// Public session UUID, serialized by the backend as `id`.
  final String id;

  /// Short, human-readable session token, for example `SES-2026-0001`.
  final String? token;

  final int? plantId;
  final int? teamId;
  final int? partTypeId;

  /// Date-only value, for example `2026-11-12`.
  final DateTime? sessionDate;

  /// `null` when the backend returns an unknown status value.
  final SessionStatus? status;

  final int? responseTimeLimitMs;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int? samplesCount;
  final int? participantsCount;

  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'id': id};
    putIfNotNull(json, 'token', token);
    putIfNotNull(json, 'plant_id', plantId);
    putIfNotNull(json, 'team_id', teamId);
    putIfNotNull(json, 'part_type_id', partTypeId);
    putIfNotNull(json, 'session_date', sessionDate?.toIso8601String());
    putIfNotNull(json, 'status', status?.apiValue);
    putIfNotNull(json, 'response_time_limit_ms', responseTimeLimitMs);
    putIfNotNull(json, 'started_at', startedAt?.toIso8601String());
    putIfNotNull(json, 'completed_at', completedAt?.toIso8601String());
    putIfNotNull(json, 'samples_count', samplesCount);
    putIfNotNull(json, 'participants_count', participantsCount);
    putIfNotNull(json, 'created_at', createdAt?.toIso8601String());
    return json;
  }
}
