import 'package:flutter/foundation.dart';

import '../model_json.dart';

/// Part type master data.
///
/// Mirrors `App\Models\PartType` and `App\Http\Resources\PartTypeResource`.
@immutable
class PartType {
  const PartType({
    required this.id,
    required this.name,
    this.samplesCount,
    this.createdAt,
  });

  factory PartType.fromJson(Map<String, dynamic> json) {
    return PartType(
      id: requireInt(json, 'id'),
      name: requireString(json, 'name'),
      samplesCount: readInt(json, 'samples_count'),
      createdAt: readDateTime(json, 'created_at'),
    );
  }

  final int id;
  final String name;

  /// Present only when the server counted the related samples.
  final int? samplesCount;

  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'id': id, 'name': name};
    putIfNotNull(json, 'samples_count', samplesCount);
    putIfNotNull(json, 'created_at', createdAt?.toIso8601String());
    return json;
  }
}
