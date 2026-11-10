import 'package:flutter/foundation.dart';

import '../../constants/app_enums.dart';
import '../model_json.dart';

/// One answer-key change for a sample.
///
/// Mirrors `App\Models\SampleKeyHistory` and
/// `App\Http\Resources\SampleKeyHistoryResource`. Unknown verdict values are
/// kept as `null` instead of crashing the client.
@immutable
class SampleKeyHistory {
  const SampleKeyHistory({
    required this.id,
    required this.sampleId,
    this.oldKey,
    this.newKey,
    this.changedBy,
    this.changedByName,
    this.changedAt,
  });

  factory SampleKeyHistory.fromJson(Map<String, dynamic> json) {
    return SampleKeyHistory(
      id: requireInt(json, 'id'),
      sampleId: requireInt(json, 'sample_id'),
      oldKey: Verdict.tryParse(json['old_key']),
      newKey: Verdict.tryParse(json['new_key']),
      changedBy: readString(json, 'changed_by'),
      changedByName: readString(json, 'changed_by_name'),
      changedAt: readDateTime(json, 'changed_at'),
    );
  }

  final int id;
  final int sampleId;

  /// Previous answer key. `null` when the backend returns an unknown value.
  final Verdict? oldKey;

  /// New answer key. `null` when the backend returns an unknown value.
  final Verdict? newKey;

  /// Public UUID of the user who changed the key.
  final String? changedBy;

  final String? changedByName;
  final DateTime? changedAt;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'id': id, 'sample_id': sampleId};
    putIfNotNull(json, 'old_key', oldKey?.apiValue);
    putIfNotNull(json, 'new_key', newKey?.apiValue);
    putIfNotNull(json, 'changed_by', changedBy);
    putIfNotNull(json, 'changed_by_name', changedByName);
    putIfNotNull(json, 'changed_at', changedAt?.toIso8601String());
    return json;
  }
}
