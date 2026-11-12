/// Named routes used by the application.
///
/// Kept separate from [AppRouter] so pages can navigate without importing the
/// router implementation, avoiding circular imports.
abstract final class AppRoutes {
  /// Entry route that decides between login and dashboard.
  static const String root = '/';

  static const String login = '/login';

  static const String register = '/register';

  static const String dashboard = '/dashboard';

  static const String componentDemo = '/component-demo';

  static const String settings = '/settings';

  static const String evaluations = '/evaluations';

  /// Reads a session evaluation UUID from a path like `/sessions/<uuid>/evaluation`.
  static String sessionEvaluation(String sessionId) =>
      '/sessions/${Uri.encodeComponent(sessionId)}/evaluation';

  /// Quick start: navigate to a new session creation flow.
  static const String quickStart = '/quick-start';
}
