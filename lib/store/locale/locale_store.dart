import 'package:flutter/widgets.dart';

import '../../constants/app_constants.dart';
import '../../utils/storage.dart';

/// Owns the application language preference.
///
/// Bahasa Indonesia is the default. An explicit user choice is persisted and
/// restored at startup; the device locale never overrides it.
class LocaleStore extends ChangeNotifier {
  LocaleStore({required this._storage});

  final LocaleStorage _storage;

  static const Locale defaultLocale = Locale(AppConstants.defaultLanguageCode);

  Locale _locale = defaultLocale;
  bool _isRestored = false;

  /// Active application locale.
  Locale get locale => _locale;

  /// Whether the persisted preference has been read.
  bool get isRestored => _isRestored;

  /// Reads the saved preference, falling back to Bahasa Indonesia.
  Future<void> restore() async {
    String? storedCode;
    try {
      storedCode = await _storage.readLanguageCode();
    } on Exception catch (error) {
      // A broken preference must never block startup; fall back to default.
      debugPrint('[locale] Failed to read saved locale: $error');
    }

    _locale = _resolveLocale(storedCode) ?? defaultLocale;
    _isRestored = true;
    notifyListeners();
  }

  /// Applies [locale] and persists it.
  ///
  /// Unsupported locales are ignored so the UI never falls back to an
  /// unexpected language.
  Future<void> setLocale(Locale locale) async {
    final resolved = _resolveLocale(locale.languageCode);
    if (resolved == null || resolved == _locale) {
      return;
    }

    _locale = resolved;
    notifyListeners();

    try {
      await _storage.writeLanguageCode(resolved.languageCode);
    } on Exception catch (error) {
      debugPrint('[locale] Failed to persist locale: $error');
    }
  }

  static Locale? _resolveLocale(String? languageCode) {
    if (languageCode == null) {
      return null;
    }
    final normalized = languageCode.trim().toLowerCase();
    if (!AppConstants.supportedLanguageCodes.contains(normalized)) {
      return null;
    }
    return Locale(normalized);
  }
}
