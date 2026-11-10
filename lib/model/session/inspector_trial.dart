import 'package:flutter/foundation.dart';

import '../model_json.dart';

/// A single inspection trial for a participant.
///
/// Mirrors `App\Models\InspectorTrial`. The session endpoints are not part of
/// the public contract yet, so the JSON shape follows the Laravel column names
/// and must be re-verified once the API resource exists.
@immutable
class InspectorTrial {
  const InspectorTrial({
    this.id,
    this.participantId,
    required this.trialNumber,
    this.startedAt,
    this.submittedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory InspectorTrial.fromJson(Map<String, dynamic> json) {
    return InspectorTrial(
      id: readInt(json, 'id'),
      participantId: readInt(json, 'participant_id'),
      trialNumber: requireInt(json, 'trial_number'),
      startedAt: readDateTime(json, 'started_at'),
      submittedAt: readDateTime(json, 'submitted_at'),
      createdAt: readDateTime(json, 'created_at'),
      updatedAt: readDateTime(json, 'updated_at'),
    );
  }

  /// Internal identifier. Not a public contract identifier.
  final int? id;

  /// Internal participant identifier. Not a public contract identifier.
  final int? participantId;

  /// Trial number, 1 to 3. The backend enforces the limit.
  final int trialNumber;

  final DateTime? startedAt;

  /// `null` until the trial is submitted.
  final DateTime? submittedAt;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'trial_number': trialNumber};
    putIfNotNull(json, 'id', id);
    putIfNotNull(json, 'participant_id', participantId);
    putIfNotNull(json, 'started_at', startedAt?.toIso8601String());
    putIfNotNull(json, 'submitted_at', submittedAt?.toIso8601String());
    putIfNotNull(json, 'created_at', createdAt?.toIso8601String());
    putIfNotNull(json, 'updated_at', updatedAt?.toIso8601String());
    return json;
  }
}
