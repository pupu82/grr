import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'api/auth_api.dart';
import 'constants/app_constants.dart';
import 'constants/app_theme.dart';
import 'generated/localization/app_localizations.dart';
import 'router/app_router.dart';
import 'router/app_routes.dart';
import 'store/auth/auth_store.dart';
import 'store/locale/locale_store.dart';
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

  await Future.wait<void>([authStore.restoreSession(), localeStore.restore()]);

  runApp(
    GrrApp(
      authStore: authStore,
      localeStore: localeStore,
      router: const AppRouter(),
    ),
  );
}

/// Root widget. Keeps the theme and localization wiring centralized.
class GrrApp extends StatefulWidget {
  const GrrApp({
    super.key,
    required this.authStore,
    required this.localeStore,
    required this.router,
  });

  final AuthStore authStore;
  final LocaleStore localeStore;
  final AppRouter router;

  @override
  State<GrrApp> createState() => _GrrAppState();
}

class _GrrAppState extends State<GrrApp> with WidgetsBindingObserver {
  late Brightness _brightness;

  @override
  void initState() {
    super.initState();
    _brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    final next = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (next != _brightness) {
      setState(() => _brightness = next);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthStore>.value(value: widget.authStore),
        ChangeNotifierProvider<LocaleStore>.value(value: widget.localeStore),
      ],
      child: _AppView(router: widget.router, brightness: _brightness),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView({required this.router, required this.brightness});

  final AppRouter router;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleStore>().locale;

    return CupertinoApp(
      title: AppConstants.appName,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: brightness == Brightness.dark ? AppTheme.dark() : AppTheme.light(),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: AppRoutes.root,
      onGenerateRoute: router.onGenerateRoute,
      onUnknownRoute: router.onUnknownRoute,
    );
  }
}
