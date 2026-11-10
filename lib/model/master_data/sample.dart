import 'package:flutter/foundation.dart';

import '../../constants/app_enums.dart';
import '../model_json.dart';
import 'part_type.dart';

/// Sample master data.
///
/// Mirrors `App\Models\Sample` and `App\Http\Resources\SampleResource`.
/// `answer_key` is omitted for inspectors, so [answerKey] is `null` in that
/// case and also when the backend returns an unknown verdict value.
@immutable
class Sample {
  const Sample({
    required this.id,
    required this.code,
    required this.partTypeId,
    this.partType,
    this.answerKey,
    this.createdAt,
  });

  factory Sample.fromJson(Map<String, dynamic> json) {
    final partTypeJson = asJsonMap(json['part_type']);

    return Sample(
      id: requireInt(json, 'id'),
      code: requireString(json, 'code'),
      partTypeId: requireInt(json, 'part_type_id'),
      partType: partTypeJson == null ? null : PartType.fromJson(partTypeJson),
      answerKey: Verdict.tryParse(json['answer_key']),
      createdAt: readDateTime(json, 'created_at'),
    );
  }

  final int id;
  final String code;
  final int partTypeId;

  /// Present only when the server loaded the part type relation.
  final PartType? partType;

  /// Omitted for inspectors; `null` when unavailable or unknown.
  final Verdict? answerKey;

  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'code': code,
      'part_type_id': partTypeId,
    };
    putIfNotNull(json, 'part_type', partType?.toJson());
    putIfNotNull(json, 'answer_key', answerKey?.apiValue);
    putIfNotNull(json, 'created_at', createdAt?.toIso8601String());
    return json;
  }
}
