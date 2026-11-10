import 'package:flutter/foundation.dart';

import '../model_json.dart';

/// Session-level agreement metrics.
///
/// Mirrors `App\Models\SessionEvaluation`. Laravel casts both metrics with
/// `decimal:2`; they are parsed into [double] values and `null` means "not
/// available".
@immutable
class SessionEvaluation {
  const SessionEvaluation({
    this.id,
    this.sessionId,
    this.betweenAgreement,
    this.allVsStandard,
    this.computedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory SessionEvaluation.fromJson(Map<String, dynamic> json) {
    return SessionEvaluation(
      id: readInt(json, 'id'),
      sessionId: readInt(json, 'session_id'),
      betweenAgreement: readDecimal(json, 'between_agreement'),
      allVsStandard: readDecimal(json, 'all_vs_standard'),
      computedAt: readDateTime(json, 'computed_at'),
      createdAt: readDateTime(json, 'created_at'),
      updatedAt: readDateTime(json, 'updated_at'),
    );
  }

  /// Internal identifier. Not a public contract identifier.
  final int? id;

  /// Internal session identifier. Not a public contract identifier.
  final int? sessionId;

  final double? betweenAgreement;
  final double? allVsStandard;
  final DateTime? computedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    putIfNotNull(json, 'id', id);
    putIfNotNull(json, 'session_id', sessionId);
    putIfNotNull(json, 'between_agreement', betweenAgreement);
    putIfNotNull(json, 'all_vs_standard', allVsStandard);
    putIfNotNull(json, 'computed_at', computedAt?.toIso8601String());
    putIfNotNull(json, 'created_at', createdAt?.toIso8601String());
    putIfNotNull(json, 'updated_at', updatedAt?.toIso8601String());
    return json;
  }
}
