import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grr/generated/localization/app_localizations.dart';
import 'package:grr/pages/settings/settings_page.dart';
import 'package:grr/store/locale/locale_store.dart';
import 'package:provider/provider.dart';

import '../../helpers/locale_fakes.dart';

Widget _app(LocaleStore store) {
  return ChangeNotifierProvider<LocaleStore>.value(
    value: store,
    child: const _LocalizedApp(),
  );
}

class _LocalizedApp extends StatelessWidget {
  const _LocalizedApp();

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleStore>().locale;

    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SettingsPage(),
    );
  }
}

void main() {
  testWidgets('marks the active language and lists every option', (
    tester,
  ) async {
    final store = LocaleStore(storage: InMemoryLocaleStorage());
    await store.restore();

    await tester.pumpWidget(_app(store));
    await tester.pumpAndSettle();

    expect(find.text('Pengaturan'), findsOneWidget);
    expect(find.text('Bahasa Indonesia'), findsOneWidget);
    expect(find.text('English (US)'), findsOneWidget);
    expect(find.text('한국어'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('switches language and persists the selection', (tester) async {
    final storage = InMemoryLocaleStorage();
    final store = LocaleStore(storage: storage);
    await store.restore();

    await tester.pumpWidget(_app(store));
    await tester.pumpAndSettle();

    await tester.tap(find.text('English (US)'));
    await tester.pumpAndSettle();

    expect(store.locale, const Locale('en'));
    expect(storage.storedLanguageCode, 'en');
    expect(find.text('Settings'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}
