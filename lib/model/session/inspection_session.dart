import 'package:flutter/foundation.dart';

import '../../constants/app_enums.dart';
import '../master_data/part_type.dart';
import '../master_data/plant.dart';
import '../master_data/team.dart';
import '../model_json.dart';
import '../report/session_evaluation.dart';
import '../user/user.dart';
import 'session_participant.dart';
import 'session_sample.dart';

/// An inspection session.
///
/// Mirrors `App\Models\InspectionSession`. The session endpoints are not part of
/// the public contract yet, so the JSON shape follows the Laravel column names
/// and must be re-verified once the API resource exists. The public identifier
/// is [uuid]; [id] is internal and must not be used for API references.
@immutable
class InspectionSession {
  const InspectionSession({
    this.id,
    required this.uuid,
    required this.token,
    required this.plantId,
    required this.teamId,
    required this.partTypeId,
    this.createdBy,
    required this.sessionDate,
    required this.trialCount,
    this.status,
    this.plant,
    this.team,
    this.partType,
    this.creator,
    this.sessionSamples = const <SessionSample>[],
    this.participants = const <SessionParticipant>[],
    this.evaluation,
    this.createdAt,
    this.updatedAt,
  });

  factory InspectionSession.fromJson(Map<String, dynamic> json) {
    final plantJson = asJsonMap(json['plant']);
    final teamJson = asJsonMap(json['team']);
    final partTypeJson = asJsonMap(json['part_type']);
    final creatorJson = asJsonMap(json['creator']);
    final evaluationJson = asJsonMap(json['evaluation']);

    return InspectionSession(
      id: readInt(json, 'id'),
      uuid: requireString(json, 'uuid'),
      token: requireString(json, 'token'),
      plantId: requireInt(json, 'plant_id'),
      teamId: requireInt(json, 'team_id'),
      partTypeId: requireInt(json, 'part_type_id'),
      createdBy: readInt(json, 'created_by'),
      sessionDate: requireDateTime(json, 'session_date'),
      trialCount: requireInt(json, 'trial_count'),
      status: SessionStatus.tryParse(json['status']),
      plant: plantJson == null ? null : Plant.fromJson(plantJson),
      team: teamJson == null ? null : Team.fromJson(teamJson),
      partType: partTypeJson == null ? null : PartType.fromJson(partTypeJson),
      creator: creatorJson == null ? null : User.fromJson(creatorJson),
      sessionSamples: asJsonMapList(json['session_samples'])
          .map(SessionSample.fromJson)
          .toList(growable: false),
      participants: asJsonMapList(json['participants'])
          .map(SessionParticipant.fromJson)
          .toList(growable: false),
      evaluation: evaluationJson == null
          ? null
          : SessionEvaluation.fromJson(evaluationJson),
      createdAt: readDateTime(json, 'created_at'),
      updatedAt: readDateTime(json, 'updated_at'),
    );
  }

  /// Internal identifier. Not a public contract identifier.
  final int? id;

  /// Public session identifier.
  final String uuid;

  /// Short session token used by inspectors.
  final String token;

  final int plantId;
  final int teamId;
  final int partTypeId;

  /// Internal creator identifier. Not a public contract identifier.
  final int? createdBy;

  final DateTime sessionDate;

  /// Number of trials, 1 to 3. The backend enforces the limit.
  final int trialCount;

  /// `null` when the backend returns an unknown status value.
  final SessionStatus? status;

  /// Present only when the server loaded the relation.
  final Plant? plant;

  /// Present only when the server loaded the relation.
  final Team? team;

  /// Present only when the server loaded the relation.
  final PartType? partType;

  /// Present only when the server loaded the relation.
  final User? creator;

  /// Present only when the server loaded the relation.
  final List<SessionSample> sessionSamples;

  /// Present only when the server loaded the relation.
  final List<SessionParticipant> participants;

  /// Present only when the server loaded the relation.
  final SessionEvaluation? evaluation;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'uuid': uuid,
      'token': token,
      'plant_id': plantId,
      'team_id': teamId,
      'part_type_id': partTypeId,
      'session_date': sessionDate.toIso8601String(),
      'trial_count': trialCount,
    };
    putIfNotNull(json, 'id', id);
    putIfNotNull(json, 'created_by', createdBy);
    putIfNotNull(json, 'status', status?.apiValue);
    putIfNotNull(json, 'plant', plant?.toJson());
    putIfNotNull(json, 'team', team?.toJson());
    putIfNotNull(json, 'part_type', partType?.toJson());
    putIfNotNull(json, 'creator', creator?.toJson());
    if (sessionSamples.isNotEmpty) {
      json['session_samples'] = sessionSamples
          .map((sample) => sample.toJson())
          .toList(growable: false);
    }
    if (participants.isNotEmpty) {
      json['participants'] = participants
          .map((participant) => participant.toJson())
          .toList(growable: false);
    }
    putIfNotNull(json, 'evaluation', evaluation?.toJson());
    putIfNotNull(json, 'created_at', createdAt?.toIso8601String());
    putIfNotNull(json, 'updated_at', updatedAt?.toIso8601String());
    return json;
  }
}
