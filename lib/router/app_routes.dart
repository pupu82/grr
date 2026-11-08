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
}
