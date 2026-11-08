import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';

/// Runtime application configuration resolved from `--dart-define` values.
@immutable
class AppConfig {
  const AppConfig({required this.apiBaseUrl, required this.enableNetworkLogs});

  /// Resolves configuration from the compile-time environment.
  ///
  /// Override the API URL with:
  /// `flutter run --dart-define=API_BASE_URL=https://api.example.com/api/v1`
  factory AppConfig.fromEnvironment() {
    const baseUrlOverride = String.fromEnvironment(
      AppConstants.apiBaseUrlDefine,
    );
    const logsOverride = bool.fromEnvironment(AppConstants.networkLogsDefine);

    return AppConfig(
      apiBaseUrl: baseUrlOverride.trim().isEmpty
          ? AppConstants.defaultApiBaseUrl
          : baseUrlOverride.trim(),
      enableNetworkLogs: logsOverride || kDebugMode,
    );
  }

  /// Base URL of the Laravel API, including the version prefix.
  final String apiBaseUrl;

  /// Whether request metadata should be logged.
  ///
  /// Only method, path, status code, and duration are logged. Headers, bodies,
  /// tokens, and credentials are never logged.
  final bool enableNetworkLogs;
}
