import 'package:flutter/foundation.dart';

import '../../constants/app_enums.dart';
import '../master_data/sample.dart';
import '../model_json.dart';
import 'inspection_result.dart';

/// A sample included in an inspection session.
///
/// Mirrors `App\Models\SessionSample`. The session endpoints are not part of the
/// public contract yet, and the contract still lists the public session-sample
/// identifier as an open item. [id] is the internal key and must not be used as
/// a public identifier.
@immutable
class SessionSample {
  const SessionSample({
    this.id,
    this.sessionId,
    this.sampleId,
    this.answerKey,
    required this.position,
    this.sample,
    this.results = const <InspectionResult>[],
    this.createdAt,
    this.updatedAt,
  });

  factory SessionSample.fromJson(Map<String, dynamic> json) {
    final sampleJson = asJsonMap(json['sample']);

    return SessionSample(
      id: readInt(json, 'id'),
      sessionId: readInt(json, 'session_id'),
      sampleId: readInt(json, 'sample_id'),
      answerKey: Verdict.tryParse(json['answer_key']),
      position: requireInt(json, 'position'),
      sample: sampleJson == null ? null : Sample.fromJson(sampleJson),
      results: asJsonMapList(json['results'])
          .map(InspectionResult.fromJson)
          .toList(growable: false),
      createdAt: readDateTime(json, 'created_at'),
      updatedAt: readDateTime(json, 'updated_at'),
    );
  }

  /// Internal identifier. Not a public contract identifier.
  final int? id;

  /// Internal session identifier. Not a public contract identifier.
  final int? sessionId;

  /// Master-data sample identifier.
  final int? sampleId;

  /// Frozen answer key for this session. Omitted for inspectors when the
  /// backend decides not to expose it.
  final Verdict? answerKey;

  /// Display position inside the session.
  final int position;

  /// Present only when the server loaded the sample relation.
  final Sample? sample;

  /// Present only when the server loaded the results relation.
  final List<InspectionResult> results;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'position': position};
    putIfNotNull(json, 'id', id);
    putIfNotNull(json, 'session_id', sessionId);
    putIfNotNull(json, 'sample_id', sampleId);
    putIfNotNull(json, 'answer_key', answerKey?.apiValue);
    putIfNotNull(json, 'sample', sample?.toJson());
    if (results.isNotEmpty) {
      json['results'] = results
          .map((result) => result.toJson())
          .toList(growable: false);
    }
    putIfNotNull(json, 'created_at', createdAt?.toIso8601String());
    putIfNotNull(json, 'updated_at', updatedAt?.toIso8601String());
    return json;
  }
}
