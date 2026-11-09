import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grr/components/buttons/app_button.dart';
import 'package:grr/constants/app_enums.dart';
import 'package:grr/generated/localization/app_localizations.dart';
import 'package:grr/model/auth/auth_session.dart';
import 'package:grr/model/auth/auth_user.dart';
import 'package:grr/pages/auth/login_page.dart';
import 'package:grr/store/auth/auth_store.dart';
import 'package:grr/theme/app_theme.dart';
import 'package:grr/utils/app_exception.dart';
import 'package:provider/provider.dart';

import '../../helpers/auth_fakes.dart';

Widget _app(AuthStore store) {
  return ChangeNotifierProvider<AuthStore>.value(
    value: store,
    child: MaterialApp(
      theme: AppTheme.light(),
      locale: const Locale('id'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LoginPage(),
    ),
  );
}

void _useLargeSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 2200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

AuthSession _session() {
  return const AuthSession(
    token: 'token-1',
    user: AuthUser(
      uuid: 'uuid-1',
      employeeCode: 'EMP-0001',
      name: 'Rina',
      role: UserRole.inspector,
      status: AccountStatus.active,
    ),
  );
}

void main() {
  testWidgets('validates empty credentials before calling the API', (
    tester,
  ) async {
    _useLargeSurface(tester);
    final api = FakeAuthApi();
    final store = AuthStore(api: api, storage: InMemorySessionStorage());
    await store.restoreSession();

    await tester.pumpWidget(_app(store));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(find.text('Kode karyawan wajib diisi.'), findsOneWidget);
    expect(find.text('Kata sandi wajib diisi.'), findsOneWidget);
    expect(api.loginCalls, isEmpty);
  });

  testWidgets('submits trimmed credentials and authenticates', (tester) async {
    _useLargeSurface(tester);
    final api = FakeAuthApi()..loginResult = _session();
    final store = AuthStore(api: api, storage: InMemorySessionStorage());
    await store.restoreSession();

    await tester.pumpWidget(_app(store));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '  EMP-0001  ');
    await tester.enterText(find.byType(TextField).at(1), 'secret');
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();

    expect(api.loginCalls.single.employeeCode, 'EMP-0001');
    expect(store.status, AuthStatus.authenticated);
  });

  testWidgets('shows the backend error message', (tester) async {
    _useLargeSurface(tester);
    final api = FakeAuthApi()
      ..loginError = const AppException(kind: AppExceptionKind.unauthorized);
    final store = AuthStore(api: api, storage: InMemorySessionStorage());
    await store.restoreSession();

    await tester.pumpWidget(_app(store));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'EMP-0001');
    await tester.enterText(find.byType(TextField).at(1), 'wrong');
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();

    expect(
      find.text('Sesi Anda telah berakhir. Silakan masuk kembali.'),
      findsOneWidget,
    );
    expect(store.status, isNot(AuthStatus.authenticated));
  });
}
