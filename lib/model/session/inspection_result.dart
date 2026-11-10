import 'package:flutter/foundation.dart';

import '../../constants/app_enums.dart';
import '../model_json.dart';

/// One verdict recorded by an inspector for a session sample.
///
/// Mirrors `App\Models\InspectionResult`. The session endpoints are not part of
/// the public contract yet, so the JSON shape follows the Laravel column names
/// and must be re-verified once the API resource exists.
@immutable
class InspectionResult {
  const InspectionResult({
    this.id,
    this.participantId,
    this.sessionSampleId,
    required this.trialNumber,
    this.verdict,
    this.createdAt,
    this.updatedAt,
  });

  factory InspectionResult.fromJson(Map<String, dynamic> json) {
    return InspectionResult(
      id: readInt(json, 'id'),
      participantId: readInt(json, 'participant_id'),
      sessionSampleId: readInt(json, 'session_sample_id'),
      trialNumber: requireInt(json, 'trial_number'),
      verdict: Verdict.tryParse(json['verdict']),
      createdAt: readDateTime(json, 'created_at'),
      updatedAt: readDateTime(json, 'updated_at'),
    );
  }

  /// Internal identifier. Not a public contract identifier.
  final int? id;

  /// Internal participant identifier. Not a public contract identifier.
  final int? participantId;

  /// Internal session-sample identifier. Not a public contract identifier.
  final int? sessionSampleId;

  /// Trial number, 1 to 3. The backend enforces the limit.
  final int trialNumber;

  /// `null` when the backend returns an unknown verdict value.
  final Verdict? verdict;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'trial_number': trialNumber};
    putIfNotNull(json, 'id', id);
    putIfNotNull(json, 'participant_id', participantId);
    putIfNotNull(json, 'session_sample_id', sessionSampleId);
    putIfNotNull(json, 'verdict', verdict?.apiValue);
    putIfNotNull(json, 'created_at', createdAt?.toIso8601String());
    putIfNotNull(json, 'updated_at', updatedAt?.toIso8601String());
    return json;
  }
}
