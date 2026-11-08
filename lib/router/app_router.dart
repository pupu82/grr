import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../constants/app_enums.dart';
import '../constants/app_theme.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/component_demo/components_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/settings/settings_page.dart';
import '../store/auth/auth_store.dart';
import 'app_routes.dart';

/// Builds the application route table.
///
/// A single instance is created during bootstrap; pages must navigate with
/// `Navigator.pushNamed` instead of creating routers.
class AppRouter {
  const AppRouter();

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final builder = _builderFor(settings.name);
    if (builder == null) {
      return null;
    }
    return CupertinoPageRoute<void>(settings: settings, builder: builder);
  }

  Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return CupertinoPageRoute<void>(
      settings: const RouteSettings(name: AppRoutes.root),
      builder: (_) => const AuthGate(),
    );
  }

  WidgetBuilder? _builderFor(String? name) {
    return switch (name) {
      AppRoutes.root => (_) => const AuthGate(),
      AppRoutes.login => (_) => const LoginPage(),
      AppRoutes.register => (_) => const RegisterPage(),
      AppRoutes.dashboard => (_) => const DashboardPage(),
      AppRoutes.componentDemo => (_) => const ComponentsPage(),
      AppRoutes.settings => (_) => const SettingsPage(),
      _ => null,
    };
  }
}

/// Chooses the top-level screen for the current authentication state.
///
/// This is a usability redirect only. The backend still authorizes every
/// request.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthStore>().status;

    return switch (status) {
      AuthStatus.unknown => const _StartupPage(),
      AuthStatus.authenticated => const DashboardPage(),
      AuthStatus.unauthenticated => const LoginPage(),
    };
  }
}

class _StartupPage extends StatelessWidget {
  const _StartupPage();

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return CupertinoPageScaffold(
      backgroundColor: palette.surface,
      child: const Center(child: CupertinoActivityIndicator(radius: 12)),
    );
  }
}
