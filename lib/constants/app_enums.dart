/// Roles supported by the Gauge R&R backend.
///
/// Flutter only uses these values for presentation. Laravel remains the
/// authorization authority. Localized labels live in
/// `lib/utils/localized_labels.dart` so enums stay free of UI text.
enum UserRole {
  admin('admin'),
  manager('manager'),
  inspector('inspector');

  const UserRole(this.apiValue);

  /// Value expected by the backend contract.
  final String apiValue;

  /// Parses a backend role value, returning `null` for unknown values so an
  /// unexpected role never silently becomes a privileged one.
  static UserRole? tryParse(Object? value) {
    if (value is! String) {
      return null;
    }
    final normalized = value.trim().toLowerCase();
    for (final role in UserRole.values) {
      if (role.apiValue == normalized) {
        return role;
      }
    }
    return null;
  }
}

/// Account lifecycle status returned by the backend.
enum AccountStatus {
  pending('pending'),
  active('active'),
  inactive('inactive');

  const AccountStatus(this.apiValue);

  /// Value expected by the backend contract.
  final String apiValue;

  /// Parses a backend status value, returning `null` for unknown values.
  static AccountStatus? tryParse(Object? value) {
    if (value is! String) {
      return null;
    }
    final normalized = value.trim().toLowerCase();
    for (final status in AccountStatus.values) {
      if (status.apiValue == normalized) {
        return status;
      }
    }
    return null;
  }
}

/// Attribute inspection verdicts. The API values must never be translated.
enum Verdict {
  good('Good'),
  defect('Defect');

  const Verdict(this.apiValue);

  /// Exact value sent to and received from the backend.
  final String apiValue;
}

/// Client-side authentication lifecycle.
enum AuthStatus {
  /// The persisted session has not been read yet.
  unknown,
  authenticated,
  unauthenticated,
}
