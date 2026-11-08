import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';
import '../model/auth/auth_session.dart';

/// Persistence boundary for the authenticated session.
///
/// Keeping this abstract makes [AuthStore] testable without touching platform
/// channels.
abstract interface class SessionStorage {
  Future<AuthSession?> read();

  Future<void> write(AuthSession session);

  Future<void> clear();
}

/// Stores the Sanctum token in the platform secure storage.
///
/// Android uses the Keystore, iOS/macOS the Keychain, Windows DPAPI-backed
/// storage, and Web a WebCrypto-protected store (which requires a secure
/// context).
class SecureSessionStorage implements SessionStorage {
  SecureSessionStorage({this._storage = const FlutterSecureStorage()});

  final FlutterSecureStorage _storage;

  @override
  Future<AuthSession?> read() async {
    final raw = await _storage.read(key: AppConstants.sessionStorageKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        await clear();
        return null;
      }
      return AuthSession.fromJson(
        decoded.map((key, value) => MapEntry('$key', value)),
      );
    } on FormatException {
      // Corrupt or outdated payloads are discarded instead of blocking login.
      await clear();
      return null;
    }
  }

  @override
  Future<void> write(AuthSession session) {
    return _storage.write(
      key: AppConstants.sessionStorageKey,
      value: jsonEncode(session.toJson()),
    );
  }

  @override
  Future<void> clear() {
    return _storage.delete(key: AppConstants.sessionStorageKey);
  }
}

/// Persistence boundary for the user's language preference.
abstract interface class LocaleStorage {
  /// Returns the stored language code, or `null` when nothing is stored.
  Future<String?> readLanguageCode();

  Future<void> writeLanguageCode(String languageCode);
}

/// Stores the language preference in the platform secure storage.
///
/// The preference is not sensitive, but reusing the existing secure storage
/// keeps persistence behind a single dependency on every platform.
class SecureLocaleStorage implements LocaleStorage {
  SecureLocaleStorage({this._storage = const FlutterSecureStorage()});

  final FlutterSecureStorage _storage;

  @override
  Future<String?> readLanguageCode() {
    return _storage.read(key: AppConstants.localeStorageKey);
  }

  @override
  Future<void> writeLanguageCode(String languageCode) {
    return _storage.write(
      key: AppConstants.localeStorageKey,
      value: languageCode,
    );
  }
}
