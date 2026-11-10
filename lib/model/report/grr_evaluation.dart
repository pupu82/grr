import 'package:flutter/foundation.dart';

import '../../constants/app_enums.dart';
import '../model_json.dart';

/// Per-participant Gauge R&R metrics.
///
/// Mirrors `App\Models\GrrEvaluation`. Laravel casts the metrics with
/// `decimal:2`; the contract says decimal metrics arrive as strings, so they
/// are parsed into [double] values. `null` means "not available".
///
/// The judgement thresholds and values are provisional in the contract. The
/// client must not derive or display a judgement on its own.
@immutable
class GrrEvaluation {
  const GrrEvaluation({
    this.id,
    this.participantId,
    this.repeatability,
    this.effectiveness,
    this.missRate,
    this.falseAlarmRate,
    this.judgement,
    this.thresholds,
    this.computedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory GrrEvaluation.fromJson(Map<String, dynamic> json) {
    return GrrEvaluation(
      id: readInt(json, 'id'),
      participantId: readInt(json, 'participant_id'),
      repeatability: readDecimal(json, 'repeatability'),
      effectiveness: readDecimal(json, 'effectiveness'),
      missRate: readDecimal(json, 'miss_rate'),
      falseAlarmRate: readDecimal(json, 'false_alarm_rate'),
      judgement: Judgement.tryParse(json['judgement']),
      thresholds: asJsonMap(json['thresholds']),
      computedAt: readDateTime(json, 'computed_at'),
      createdAt: readDateTime(json, 'created_at'),
      updatedAt: readDateTime(json, 'updated_at'),
    );
  }

  /// Internal identifier. Not a public contract identifier.
  final int? id;

  /// Internal participant identifier. Not a public contract identifier.
  final int? participantId;

  final double? repeatability;
  final double? effectiveness;

  /// Thesis display label: "P false". Never sent back to the backend.
  final double? missRate;

  /// Thesis display label: "P mis". Never sent back to the backend.
  final double? falseAlarmRate;

  /// `null` when the backend returns an unknown judgement value.
  final Judgement? judgement;

  /// Raw threshold payload. The keys are not part of the contract yet.
  final Map<String, dynamic>? thresholds;

  final DateTime? computedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    putIfNotNull(json, 'id', id);
    putIfNotNull(json, 'participant_id', participantId);
    putIfNotNull(json, 'repeatability', repeatability);
    putIfNotNull(json, 'effectiveness', effectiveness);
    putIfNotNull(json, 'miss_rate', missRate);
    putIfNotNull(json, 'false_alarm_rate', falseAlarmRate);
    putIfNotNull(json, 'judgement', judgement?.apiValue);
    putIfNotNull(json, 'thresholds', thresholds);
    putIfNotNull(json, 'computed_at', computedAt?.toIso8601String());
    putIfNotNull(json, 'created_at', createdAt?.toIso8601String());
    putIfNotNull(json, 'updated_at', updatedAt?.toIso8601String());
    return json;
  }
}
