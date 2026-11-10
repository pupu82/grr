import 'package:flutter/foundation.dart';

import '../user/user.dart';

/// Sanctum token plus the user it belongs to.
///
/// The token is only persisted through the secure storage implementation in
/// `lib/utils/storage.dart` and is never logged or rendered.
@immutable
class AuthSession {
  const AuthSession({required this.token, required this.user});

  /// Parses a login response body.
  ///
  /// Accepts both `{ "token": ..., "user": {...} }` and the Laravel resource
  /// wrapper `{ "data": { "token": ..., "user": {...} } }`.
  factory AuthSession.fromLoginResponse(Object? body) {
    final root = _asJsonMap(body);
    if (root == null) {
      throw const FormatException('Login response is not a JSON object.');
    }

    final payload = _asJsonMap(root['data']) ?? root;
    final token = payload['token'];

    if (token is! String || token.trim().isEmpty) {
      throw const FormatException('Login response is missing "token".');
    }

    final user = _asJsonMap(payload['user']);
    if (user == null) {
      throw const FormatException('Login response is missing "user".');
    }

    return AuthSession(token: token.trim(), user: User.fromJson(user));
  }

  /// Parses a previously persisted session.
  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final token = json['token'];
    final user = _asJsonMap(json['user']);

    if (token is! String || token.trim().isEmpty || user == null) {
      throw const FormatException('Stored session is incomplete.');
    }

    return AuthSession(token: token.trim(), user: User.fromJson(user));
  }

  final String token;
  final User user;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'token': token, 'user': user.toJson()};
  }

  @override
  bool operator ==(Object other) {
    return other is AuthSession && other.token == token && other.user == user;
  }

  @override
  int get hashCode => Object.hash(token, user);
}

Map<String, dynamic>? _asJsonMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, entry) => MapEntry('$key', entry));
  }
  return null;
}
