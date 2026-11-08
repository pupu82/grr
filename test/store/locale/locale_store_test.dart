import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grr/store/locale/locale_store.dart';

import '../../helpers/locale_fakes.dart';

void main() {
  group('LocaleStore.restore', () {
    test('defaults to Bahasa Indonesia', () async {
      final store = LocaleStore(storage: InMemoryLocaleStorage());

      await store.restore();

      expect(store.locale, const Locale('id'));
      expect(store.isRestored, isTrue);
    });

    test('restores a saved language preference', () async {
      final storage = InMemoryLocaleStorage()..storedLanguageCode = 'ko';
      final store = LocaleStore(storage: storage);

      await store.restore();

      expect(store.locale, const Locale('ko'));
    });

    test('falls back to the default for unsupported values', () async {
      final storage = InMemoryLocaleStorage()..storedLanguageCode = 'fr';
      final store = LocaleStore(storage: storage);

      await store.restore();

      expect(store.locale, const Locale('id'));
    });

    test('falls back to the default when storage fails', () async {
      final storage = InMemoryLocaleStorage()..failOnRead = true;
      final store = LocaleStore(storage: storage);

      await store.restore();

      expect(store.locale, const Locale('id'));
    });
  });

  group('LocaleStore.setLocale', () {
    test('applies and persists a supported language', () async {
      final storage = InMemoryLocaleStorage();
      final store = LocaleStore(storage: storage);
      await store.restore();

      var notifications = 0;
      store.addListener(() => notifications++);

      await store.setLocale(const Locale('en'));

      expect(store.locale, const Locale('en'));
      expect(storage.storedLanguageCode, 'en');
      expect(notifications, 1);
    });

    test('ignores unsupported languages', () async {
      final storage = InMemoryLocaleStorage();
      final store = LocaleStore(storage: storage);
      await store.restore();

      await store.setLocale(const Locale('fr'));

      expect(store.locale, const Locale('id'));
      expect(storage.storedLanguageCode, isNull);
    });

    test('keeps the selection when persistence fails', () async {
      final storage = InMemoryLocaleStorage()..failOnWrite = true;
      final store = LocaleStore(storage: storage);
      await store.restore();

      await store.setLocale(const Locale('ko'));

      expect(store.locale, const Locale('ko'));
    });
  });
}
