import 'package:flutter/foundation.dart';

import '../model_json.dart';
import '../report/grr_evaluation.dart';
import '../user/user.dart';
import 'inspection_result.dart';
import 'inspector_trial.dart';

/// An inspector assigned to an inspection session.
///
/// Mirrors `App\Models\SessionParticipant`. The session endpoints are not part
/// of the public contract yet, so the JSON shape follows the Laravel column
/// names and must be re-verified once the API resource exists.
@immutable
class SessionParticipant {
  const SessionParticipant({
    this.id,
    this.sessionId,
    this.userId,
    this.user,
    this.trials = const <InspectorTrial>[],
    this.results = const <InspectionResult>[],
    this.evaluation,
    this.createdAt,
    this.updatedAt,
  });

  factory SessionParticipant.fromJson(Map<String, dynamic> json) {
    final userJson = asJsonMap(json['user']);
    final evaluationJson = asJsonMap(json['evaluation']);

    return SessionParticipant(
      id: readInt(json, 'id'),
      sessionId: readInt(json, 'session_id'),
      userId: readInt(json, 'user_id'),
      user: userJson == null ? null : User.fromJson(userJson),
      trials: asJsonMapList(json['trials'])
          .map(InspectorTrial.fromJson)
          .toList(growable: false),
      results: asJsonMapList(json['results'])
          .map(InspectionResult.fromJson)
          .toList(growable: false),
      evaluation: evaluationJson == null
          ? null
          : GrrEvaluation.fromJson(evaluationJson),
      createdAt: readDateTime(json, 'created_at'),
      updatedAt: readDateTime(json, 'updated_at'),
    );
  }

  /// Internal identifier. Not a public contract identifier.
  final int? id;

  /// Internal session identifier. Not a public contract identifier.
  final int? sessionId;

  /// Internal user identifier. Not a public contract identifier.
  final int? userId;

  /// Present only when the server loaded the user relation.
  final User? user;

  /// Present only when the server loaded the trials relation.
  final List<InspectorTrial> trials;

  /// Present only when the server loaded the results relation.
  final List<InspectionResult> results;

  /// Present only when the server loaded the evaluation relation.
  final GrrEvaluation? evaluation;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    putIfNotNull(json, 'id', id);
    putIfNotNull(json, 'session_id', sessionId);
    putIfNotNull(json, 'user_id', userId);
    putIfNotNull(json, 'user', user?.toJson());
    if (trials.isNotEmpty) {
      json['trials'] = trials
          .map((trial) => trial.toJson())
          .toList(growable: false);
    }
    if (results.isNotEmpty) {
      json['results'] = results
          .map((result) => result.toJson())
          .toList(growable: false);
    }
    putIfNotNull(json, 'evaluation', evaluation?.toJson());
    putIfNotNull(json, 'created_at', createdAt?.toIso8601String());
    putIfNotNull(json, 'updated_at', updatedAt?.toIso8601String());
    return json;
  }
}
