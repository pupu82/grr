import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'api/auth_api.dart';
import 'api/session_api.dart';
import 'constants/app_constants.dart';
import 'generated/localization/app_localizations.dart';
import 'router/app_router.dart';
import 'router/app_routes.dart';
import 'store/auth/auth_store.dart';
import 'store/locale/locale_store.dart';
import 'store/sessions/dashboard_sessions_store.dart';
import 'store/sessions/session_evaluation_store.dart';
import 'theme/app_theme.dart';
import 'utils/app_config.dart';
import 'utils/request.dart';
import 'utils/storage.dart';

/// Creates application-wide infrastructure and starts the UI.
///
/// All singletons (Dio client, storage, stores, router) are created here so
/// pages never build their own dependencies.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();
  final sessionStorage = SecureSessionStorage();
  final localeStorage = SecureLocaleStorage();

  late final AuthStore authStore;
  final requestClient = ApiRequestClient(
    config: config,
    readAuthToken: () => authStore.token,
    onUnauthorized: () => unawaited(authStore.handleUnauthorized()),
  );
  authStore = AuthStore(
    api: AuthApi(requestClient.dio),
    storage: sessionStorage,
  );
  final localeStore = LocaleStore(storage: localeStorage);
  final sessionApi = SessionApi(requestClient.dio);
  final sessionEvaluationStore = SessionEvaluationStore(api: sessionApi);
  final dashboardSessionsStore = DashboardSessionsStore(api: sessionApi);

  await Future.wait<void>([authStore.restoreSession(), localeStore.restore()]);

  runApp(
    GrrApp(
      authStore: authStore,
      localeStore: localeStore,
      sessionEvaluationStore: sessionEvaluationStore,
      dashboardSessionsStore: dashboardSessionsStore,
      router: const AppRouter(),
    ),
  );
}

/// Root widget. Keeps the theme and localization wiring centralized.
class GrrApp extends StatelessWidget {
  const GrrApp({
    super.key,
    required this.authStore,
    required this.localeStore,
    required this.sessionEvaluationStore,
    required this.dashboardSessionsStore,
    required this.router,
  });

  final AuthStore authStore;
  final LocaleStore localeStore;
  final SessionEvaluationStore sessionEvaluationStore;
  final DashboardSessionsStore dashboardSessionsStore;
  final AppRouter router;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthStore>.value(value: authStore),
        ChangeNotifierProvider<LocaleStore>.value(value: localeStore),
        ChangeNotifierProvider<SessionEvaluationStore>.value(
          value: sessionEvaluationStore,
        ),
        ChangeNotifierProvider<DashboardSessionsStore>.value(
          value: dashboardSessionsStore,
        ),
      ],
      child: _AppView(router: router),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView({required this.router});

  final AppRouter router;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleStore>().locale;

    return MaterialApp(
      title: AppConstants.appName,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: AppRoutes.root,
      onGenerateRoute: router.onGenerateRoute,
      onUnknownRoute: router.onUnknownRoute,
    );
  }
}
