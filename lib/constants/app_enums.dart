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

/// Attribute inspection verdicts.
///
/// The contract defines the values as lowercase `good` and `defect`. They must
/// never be translated or replaced in API communication.
enum Verdict {
  good('good'),
  defect('defect');

  const Verdict(this.apiValue);

  /// Exact value sent to and received from the backend.
  final String apiValue;

  /// Parses a backend verdict value, returning `null` for unknown values.
  static Verdict? tryParse(Object? value) {
    if (value is! String) {
      return null;
    }
    final normalized = value.trim().toLowerCase();
    for (final verdict in Verdict.values) {
      if (verdict.apiValue == normalized) {
        return verdict;
      }
    }
    return null;
  }
}

/// Stable, machine-readable error codes from the API contract.
///
/// Clients branch on these codes, never on the human-readable `message`.
enum ErrorCode {
  unauthenticated('unauthenticated'),
  invalidCredentials('invalid_credentials'),
  accountPending('account_pending'),
  accountInactive('account_inactive'),
  passwordChangeRequired('password_change_required'),
  forbidden('forbidden'),
  notFound('not_found'),
  methodNotAllowed('method_not_allowed'),
  validationFailed('validation_failed'),
  tooManyRequests('too_many_requests'),
  httpError('http_error');

  const ErrorCode(this.apiValue);

  /// Value expected by the backend contract.
  final String apiValue;

  /// Parses a backend error code, returning `null` for unknown values.
  static ErrorCode? tryParse(Object? value) {
    if (value is! String) {
      return null;
    }
    final normalized = value.trim().toLowerCase();
    for (final code in ErrorCode.values) {
      if (code.apiValue == normalized) {
        return code;
      }
    }
    return null;
  }
}

/// Client-side authentication lifecycle.
enum AuthStatus {
  /// The persisted session has not been read yet.
  unknown,
  authenticated,
  unauthenticated,
}
