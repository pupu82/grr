import 'package:flutter/foundation.dart';

import '../model_json.dart';
import '../user/user.dart';
import 'grr_evaluation.dart';
import 'session_agreement.dart';
import 'session_evaluation_summary.dart';

/// Parsed evaluation response of a completed session.
///
/// Mirrors `GET /api/v1/sessions/{session}/evaluation`. The endpoint is Admin
/// and Manager only.
@immutable
class SessionEvaluationResult {
  const SessionEvaluationResult({
    this.session,
    this.participants = const <EvaluationParticipant>[],
    this.agreement,
  });

  factory SessionEvaluationResult.fromResponse(Object? body) {
    final root = asJsonMap(body);
    if (root == null) {
      throw const FormatException('Evaluation response is not a JSON object.');
    }

    final payload = asJsonMap(root['data']) ?? root;
    return SessionEvaluationResult.fromJson(payload);
  }

  factory SessionEvaluationResult.fromJson(Map<String, dynamic> json) {
    final sessionJson = asJsonMap(json['session']);
    final agreementJson = asJsonMap(json['agreement']);
    final participants = asJsonMapList(json['participants'])
        .map(EvaluationParticipant.fromJson)
        .toList(growable: false);

    return SessionEvaluationResult(
      session: sessionJson == null
          ? null
          : SessionEvaluationSummary.fromJson(sessionJson),
      participants: participants,
      agreement: agreementJson == null
          ? null
          : SessionAgreement.fromJson(agreementJson),
    );
  }

  final SessionEvaluationSummary? session;

  final List<EvaluationParticipant> participants;

  /// `null` when the backend omits the additive `agreement` object.
  final SessionAgreement? agreement;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    putIfNotNull(json, 'session', session?.toJson());
    if (participants.isNotEmpty) {
      json['participants'] = participants
          .map((participant) => participant.toJson())
          .toList(growable: false);
    }
    putIfNotNull(json, 'agreement', agreement?.toJson());
    return json;
  }
}

/// A single participant row in the evaluation response.
@immutable
class EvaluationParticipant {
  const EvaluationParticipant({
    this.participantId,
    this.user,
    this.startedAt,
    this.completedAt,
    this.isComplete,
    this.metrics,
  });

  factory EvaluationParticipant.fromJson(Map<String, dynamic> json) {
    final userJson = asJsonMap(json['user']);
    final metricsJson = asJsonMap(json['metrics']);

    return EvaluationParticipant(
      participantId: readInt(json, 'participant_id'),
      user: userJson == null ? null : User.fromJson(userJson),
      startedAt: readDateTime(json, 'started_at'),
      completedAt: readDateTime(json, 'completed_at'),
      isComplete: readBool(json, 'is_complete'),
      metrics: metricsJson == null ? null : GrrEvaluation.fromJson(metricsJson),
    );
  }

  final int? participantId;
  final User? user;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final bool? isComplete;
  final GrrEvaluation? metrics;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    putIfNotNull(json, 'participant_id', participantId);
    putIfNotNull(json, 'user', user?.toJson());
    putIfNotNull(json, 'started_at', startedAt?.toIso8601String());
    putIfNotNull(json, 'completed_at', completedAt?.toIso8601String());
    putIfNotNull(json, 'is_complete', isComplete);
    putIfNotNull(json, 'metrics', metrics?.toJson());
    return json;
  }
}
