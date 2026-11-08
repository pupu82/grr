import 'package:flutter/foundation.dart';

import '../../api/auth_api.dart';
import '../../constants/app_enums.dart';
import '../../model/auth/auth_session.dart';
import '../../model/auth/auth_user.dart';
import '../../model/auth/login_request.dart';
import '../../model/auth/register_request.dart';
import '../../utils/app_exception.dart';
import '../../utils/storage.dart';

/// Owns the client-side authentication state.
///
/// The store coordinates API calls and persistence. It never decides
/// authorization; Laravel remains the authority.
class AuthStore extends ChangeNotifier {
  AuthStore({required this._api, required this._storage});

  final AuthApi _api;
  final SessionStorage _storage;

  AuthStatus _status = AuthStatus.unknown;
  AuthSession? _session;
  bool _isSubmitting = false;
  AppException? _error;

  AuthStatus get status => _status;

  AuthUser? get user => _session?.user;

  /// Current Sanctum token. Used only by the shared request interceptor.
  String? get token => _session?.token;

  bool get isSubmitting => _isSubmitting;

  AppException? get error => _error;

  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// Restores a previously persisted session during application startup.
  Future<void> restoreSession() async {
    try {
      _session = await _storage.read();
    } on Exception catch (error) {
      debugPrint('[auth] Failed to read persisted session: $error');
      _session = null;
      _error = const AppException(kind: AppExceptionKind.sessionRestoreFailed);
    }

    _status = _session == null
        ? AuthStatus.unauthenticated
        : AuthStatus.authenticated;
    notifyListeners();
  }

  /// Attempts to authenticate. Returns `true` when the session is established.
  Future<bool> login({
    required String employeeCode,
    required String password,
  }) async {
    if (_isSubmitting) {
      return false;
    }

    _setSubmitting(true);
    try {
      final session = await _api.login(
        LoginRequest(employeeCode: employeeCode.trim(), password: password),
      );
      await _storage.write(session);

      _session = session;
      _status = AuthStatus.authenticated;
      _error = null;
      return true;
    } on AppException catch (error) {
      _error = error;
      return false;
    } on Exception catch (error) {
      debugPrint('[auth] Login failed unexpectedly: $error');
      _error = const AppException(kind: AppExceptionKind.sessionStorageFailed);
      return false;
    } finally {
      _setSubmitting(false);
    }
  }

  /// Registers a pending inspector account.
  ///
  /// A successful registration does not authenticate the user: the backend
  /// still has to approve the account.
  Future<bool> register({
    required String employeeCode,
    required String name,
    required String password,
    required String passwordConfirmation,
    String? email,
  }) async {
    if (_isSubmitting) {
      return false;
    }

    _setSubmitting(true);
    try {
      await _api.register(
        RegisterRequest(
          employeeCode: employeeCode.trim(),
          name: name.trim(),
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ),
      );
      _error = null;
      return true;
    } on AppException catch (error) {
      _error = error;
      return false;
    } finally {
      _setSubmitting(false);
    }
  }

  /// Revokes the token on the server and always clears local state.
  Future<void> logout() async {
    if (_isSubmitting) {
      return;
    }

    _setSubmitting(true);
    try {
      await _api.logout();
    } on AppException catch (error) {
      // Local logout must still succeed when the token is already invalid.
      debugPrint('[auth] Logout request failed: ${error.kind.name}');
    }

    await _clearLocalSession();
    _setSubmitting(false);
  }

  /// Clears the session after the backend rejects the current token.
  Future<void> handleUnauthorized() async {
    if (_status == AuthStatus.unauthenticated && _session == null) {
      return;
    }
    await _clearLocalSession();
    notifyListeners();
  }

  /// Clears the last error so the UI can dismiss its banner.
  void clearError() {
    if (_error == null) {
      return;
    }
    _error = null;
    notifyListeners();
  }

  Future<void> _clearLocalSession() async {
    _session = null;
    _status = AuthStatus.unauthenticated;

    try {
      await _storage.clear();
    } on Exception catch (error) {
      debugPrint('[auth] Failed to clear persisted session: $error');
      _error = const AppException(kind: AppExceptionKind.sessionClearFailed);
    }
  }

  void _setSubmitting(bool value) {
    if (_isSubmitting == value) {
      return;
    }
    _isSubmitting = value;
    notifyListeners();
  }
}
