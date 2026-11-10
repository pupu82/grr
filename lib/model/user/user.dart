import 'package:flutter/foundation.dart';

import '../../constants/app_enums.dart';
import '../model_json.dart';
import 'team_summary.dart';

/// Authenticated user returned by the backend.
///
/// Mirrors `App\Models\User` and `App\Http\Resources\UserResource`. The public
/// identifier is the UUID exposed as `id`; the internal bigint key is never
/// part of the payload.
@immutable
class User {
  const User({
    required this.uuid,
    required this.employeeCode,
    required this.name,
    this.role,
    this.status,
    this.registeredVia,
    this.mustChangePassword = false,
    this.approvedAt,
    this.team,
    this.createdAt,
  });

  /// Parses the user object of a login or `/user` response.
  ///
  /// Unknown roles, statuses and registration sources are preserved as `null`
  /// instead of being coerced, so an unexpected backend value never silently
  /// grants access.
  factory User.fromJson(Map<String, dynamic> json) {
    final uuid = readString(json, 'id') ?? readString(json, 'uuid');
    final employeeCode = readString(json, 'employee_code');

    if (uuid == null || uuid.isEmpty) {
      throw const FormatException('User payload is missing "id".');
    }
    if (employeeCode == null || employeeCode.isEmpty) {
      throw const FormatException('User payload is missing "employee_code".');
    }

    final teamJson = asJsonMap(json['team']);

    return User(
      uuid: uuid,
      employeeCode: employeeCode,
      name: readString(json, 'name') ?? employeeCode,
      role: UserRole.tryParse(json['role']),
      status: AccountStatus.tryParse(json['status']),
      registeredVia: RegistrationSource.tryParse(json['registered_via']),
      mustChangePassword: readBool(json, 'must_change_password') ?? false,
      approvedAt: readDateTime(json, 'approved_at'),
      team: teamJson == null ? null : TeamSummary.fromJson(teamJson),
      createdAt: readDateTime(json, 'created_at'),
    );
  }

  /// Public UUID. Serialized by the backend as `id`.
  final String uuid;
  final String employeeCode;
  final String name;

  /// `null` when the backend returns a role this client does not know.
  final UserRole? role;

  /// `null` when the backend returns a status this client does not know.
  final AccountStatus? status;

  /// `null` when the backend returns a value this client does not know.
  final RegistrationSource? registeredVia;

  /// True while the account still uses an admin-issued temporary password.
  final bool mustChangePassword;

  /// `null` until an administrator approves the account.
  final DateTime? approvedAt;

  /// `null` when no team is assigned.
  final TeamSummary? team;

  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': uuid,
      'employee_code': employeeCode,
      'name': name,
      'must_change_password': mustChangePassword,
    };
    putIfNotNull(json, 'role', role?.apiValue);
    putIfNotNull(json, 'status', status?.apiValue);
    putIfNotNull(json, 'registered_via', registeredVia?.apiValue);
    putIfNotNull(json, 'approved_at', approvedAt?.toIso8601String());
    putIfNotNull(json, 'team', team?.toJson());
    putIfNotNull(json, 'created_at', createdAt?.toIso8601String());
    return json;
  }

  @override
  bool operator ==(Object other) {
    return other is User &&
        other.uuid == uuid &&
        other.employeeCode == employeeCode &&
        other.name == name &&
        other.role == role &&
        other.status == status &&
        other.registeredVia == registeredVia &&
        other.mustChangePassword == mustChangePassword &&
        other.approvedAt == approvedAt &&
        other.team == team &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(
    uuid,
    employeeCode,
    name,
    role,
    status,
    registeredVia,
    mustChangePassword,
    approvedAt,
    team,
    createdAt,
  );
}
