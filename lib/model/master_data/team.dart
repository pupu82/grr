import 'package:flutter/foundation.dart';

import '../model_json.dart';
import 'plant.dart';

/// Team master data.
///
/// Mirrors `App\Models\Team` and `App\Http\Resources\TeamResource`.
@immutable
class Team {
  const Team({
    required this.id,
    required this.name,
    required this.plantId,
    this.plant,
    this.createdAt,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    final plantJson = asJsonMap(json['plant']);

    return Team(
      id: requireInt(json, 'id'),
      name: requireString(json, 'name'),
      plantId: requireInt(json, 'plant_id'),
      plant: plantJson == null ? null : Plant.fromJson(plantJson),
      createdAt: readDateTime(json, 'created_at'),
    );
  }

  final int id;
  final String name;
  final int plantId;

  /// Present only when the server loaded the plant relation.
  final Plant? plant;

  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'id': id, 'name': name, 'plant_id': plantId};
    putIfNotNull(json, 'plant', plant?.toJson());
    putIfNotNull(json, 'created_at', createdAt?.toIso8601String());
    return json;
  }
}
