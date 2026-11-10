/// Shared, tolerant JSON readers used by the model layer.
///
/// The backend contract requires clients to tolerate unknown fields and unknown
/// enum values. These helpers keep that behavior consistent and avoid leaking
/// `dynamic` values into business code.
library;

/// Converts a JSON object of any map type into a `Map<String, dynamic>`.
Map<String, dynamic>? asJsonMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, entry) => MapEntry('$key', entry));
  }
  return null;
}

/// Converts a JSON array into a list of JSON objects, skipping non-objects.
List<Map<String, dynamic>> asJsonMapList(Object? value) {
  if (value is! List) {
    return const <Map<String, dynamic>>[];
  }
  return value
      .map(asJsonMap)
      .whereType<Map<String, dynamic>>()
      .toList(growable: false);
}

/// Reads a non-empty string, or `null` when the field is missing or blank.
String? readString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  return null;
}

/// Reads an integer, accepting numeric strings for tolerance.
int? readInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value.trim());
  }
  return null;
}

/// Reads a decimal metric.
///
/// Laravel serializes `decimal:2` casts as strings; this accepts both strings
/// and numbers and keeps `null` as "not available".
double? readDecimal(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is double) {
    return value;
  }
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value.trim());
  }
  return null;
}

/// Reads a boolean, accepting `0`/`1` and `"true"`/`"false"`.
bool? readBool(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'true' || normalized == '1') {
      return true;
    }
    if (normalized == 'false' || normalized == '0') {
      return false;
    }
  }
  return null;
}

/// Reads an ISO 8601 timestamp.
DateTime? readDateTime(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String && value.trim().isNotEmpty) {
    return DateTime.tryParse(value.trim());
  }
  return null;
}

/// Reads a required integer, throwing [FormatException] when it is missing.
int requireInt(Map<String, dynamic> json, String key) {
  final value = readInt(json, key);
  if (value == null) {
    throw FormatException('Payload is missing "$key".');
  }
  return value;
}

/// Reads a required non-empty string, throwing [FormatException] when missing.
String requireString(Map<String, dynamic> json, String key) {
  final value = readString(json, key);
  if (value == null) {
    throw FormatException('Payload is missing "$key".');
  }
  return value;
}

/// Reads a required ISO 8601 timestamp, throwing [FormatException] when
/// missing or unparseable.
DateTime requireDateTime(Map<String, dynamic> json, String key) {
  final value = readDateTime(json, key);
  if (value == null) {
    throw FormatException('Payload is missing "$key".');
  }
  return value;
}

/// Adds [value] to [json] only when it is not `null`.
void putIfNotNull(Map<String, dynamic> json, String key, Object? value) {
  if (value != null) {
    json[key] = value;
  }
}
