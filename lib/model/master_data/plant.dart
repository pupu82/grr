import 'package:flutter/foundation.dart';

import '../model_json.dart';

/// Plant master data.
///
/// Mirrors `App\Models\Plant` and `App\Http\Resources\PlantResource`.
@immutable
class Plant {
  const Plant({
    required this.id,
    required this.code,
    required this.name,
    this.isActive = true,
    this.createdAt,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: requireInt(json, 'id'),
      code: requireString(json, 'code'),
      name: requireString(json, 'name'),
      isActive: readBool(json, 'is_active') ?? true,
      createdAt: readDateTime(json, 'created_at'),
    );
  }

  /// Integer identifier used by the master-data endpoints.
  final int id;
  final String code;
  final String name;
  final bool isActive;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
      'is_active': isActive,
    };
    putIfNotNull(json, 'created_at', createdAt?.toIso8601String());
    return json;
  }
}
