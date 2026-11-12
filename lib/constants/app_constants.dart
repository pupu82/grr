/// Application-wide constant values that are shared across features.
abstract final class AppConstants {
  /// Human readable application name.
  static const String appName = 'Gauge R&R';

  /// `--dart-define` key used to override the API base URL per environment.
  static const String apiBaseUrlDefine = 'API_BASE_URL';

  /// `--dart-define` key used to force network logging on or off.
  static const String networkLogsDefine = 'ENABLE_NETWORK_LOGS';

  /// Default base URL. `10.0.2.2` is the Android emulator loopback to the host
  /// machine, where the Laravel development server usually runs.
  static const String defaultApiBaseUrl = 'http://10.0.2.2:8000/api/v1';

  /// Key used to persist the authenticated session in secure storage.
  static const String sessionStorageKey = 'grr.auth.session';

  /// Key used to persist the user's language preference in secure storage.
  static const String localeStorageKey = 'grr.app.locale';

  /// Language code used when the user has not chosen a language yet.
  static const String defaultLanguageCode = 'id';

  /// Language codes supported by the application.
  static const List<String> supportedLanguageCodes = <String>['id', 'en', 'ko'];

  /// Connection timeout for outgoing requests.
  static const Duration connectTimeout = Duration(seconds: 15);

  /// Receive timeout for outgoing requests.
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// Send timeout for outgoing requests.
  static const Duration sendTimeout = Duration(seconds: 20);

  /// Backend-enforced maximum number of trials per sample.
  ///
  /// Flutter only mirrors this value for UI hints; Laravel remains the
  /// authority that enforces the limit.
  static const int maxInspectionTrials = 3;
}

/// Backend endpoint paths, relative to the configured API base URL.
///
/// The paths match `docs/api-contract.md`. Keep every path here so a contract
/// change only requires a single edit.
abstract final class ApiEndpoints {
  /// Exchanges employee credentials for a Sanctum token.
  static const String login = '/login';

  /// Self-registration. Always creates a pending inspector account.
  static const String register = '/register';

  /// Returns the authenticated user. Allowed during a required password change.
  static const String currentUser = '/user';

  /// Revokes the current Sanctum token. Allowed during a required password
  /// change.
  static const String logout = '/logout';

  /// Changes the password and clears the mandatory change.
  static const String changePassword = '/password';

  /// Computes the attribute agreement metrics of a completed session.
  ///
  /// Admin and Manager only. The session parameter is the public UUID.
  static String sessionEvaluation(String sessionId) =>
      '/sessions/${Uri.encodeComponent(sessionId)}/evaluation';

  /// Lists all sessions for Admin/Manager, or the current user's sessions for Inspector.
  ///
  /// Supports optional filters: `status`, `team_id`, `part_type_id`.
  static String sessions() => '/sessions';

  /// Force-closes an in-progress session. Admin only.
  static String sessionClose(String sessionId) =>
      '/sessions/${Uri.encodeComponent(sessionId)}/close';
}
