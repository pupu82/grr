import 'package:flutter/foundation.dart';

import '../model_json.dart';

/// Team reference embedded in a user payload.
///
/// `UserResource` only exposes the team `id` and `name`, not the full team
/// object, so this is intentionally smaller than `Team`.
@immutable
class TeamSummary {
  const TeamSummary({required this.id, required this.name});

  factory TeamSummary.fromJson(Map<String, dynamic> json) {
    return TeamSummary(
      id: requireInt(json, 'id'),
      name: requireString(json, 'name'),
    );
  }

  final int id;
  final String name;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  @override
  bool operator ==(Object other) {
    return other is TeamSummary && other.id == id && other.name == name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}
