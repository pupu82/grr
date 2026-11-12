import 'package:flutter/foundation.dart';

import '../../constants/app_enums.dart';
import '../model_json.dart';

/// Per-participant Gauge R&R metrics.
///
/// Mirrors `App\Models\GrrEvaluation`. Laravel casts the metrics with
/// `decimal:2`; the contract says decimal metrics arrive as strings, so they
/// are parsed into [double] values. `null` means "not available".
@immutable
class GrrEvaluation {
  const GrrEvaluation({
    this.id,
    this.participantId,
    this.repeatability,
    this.effectiveness,
    this.missRate,
    this.falseAlarmRate,
    this.decisions,
    this.correctDecisions,
    this.defectDecisions,
    this.goodDecisions,
    this.missedDefects,
    this.falseAlarms,
    this.timedOutSamples,
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
      decisions: readInt(json, 'decisions'),
      correctDecisions: readInt(json, 'correct_decisions'),
      defectDecisions: readInt(json, 'defect_decisions'),
      goodDecisions: readInt(json, 'good_decisions'),
      missedDefects: readInt(json, 'missed_defects'),
      falseAlarms: readInt(json, 'false_alarms'),
      timedOutSamples: readInt(json, 'timed_out_samples'),
      judgement: Judgement.tryParse(json['judgement']),
      thresholds: asJsonMap(json['thresholds']),
      computedAt: readDateTime(json, 'computed_at'),
      createdAt: readDateTime(json, 'created_at'),
      updatedAt: readDateTime(json, 'updated_at'),
    );
  }

  final int? id;
  final int? participantId;
  final double? repeatability;
  final double? effectiveness;
  final double? missRate;
  final double? falseAlarmRate;
  final int? decisions;
  final int? correctDecisions;
  final int? defectDecisions;
  final int? goodDecisions;
  final int? missedDefects;
  final int? falseAlarms;
  final int? timedOutSamples;
  final Judgement? judgement;
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
    putIfNotNull(json, 'decisions', decisions);
    putIfNotNull(json, 'correct_decisions', correctDecisions);
    putIfNotNull(json, 'defect_decisions', defectDecisions);
    putIfNotNull(json, 'good_decisions', goodDecisions);
    putIfNotNull(json, 'missed_defects', missedDefects);
    putIfNotNull(json, 'false_alarms', falseAlarms);
    putIfNotNull(json, 'timed_out_samples', timedOutSamples);
    putIfNotNull(json, 'judgement', judgement?.apiValue);
    putIfNotNull(json, 'thresholds', thresholds);
    putIfNotNull(json, 'computed_at', computedAt?.toIso8601String());
    putIfNotNull(json, 'created_at', createdAt?.toIso8601String());
    putIfNotNull(json, 'updated_at', updatedAt?.toIso8601String());
    return json;
  }
}
