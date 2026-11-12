import 'package:flutter/foundation.dart';

import '../../api/session_api.dart';
import '../../model/report/session_evaluation_result.dart';
import '../../utils/app_exception.dart';

/// Explicit lifecycle of the evaluation screen.
enum SessionEvaluationStatus { idle, loading, success, error }

/// Loads the computed evaluation of one session.
///
/// The store only coordinates the request and exposes typed state. It never
/// calculates metrics or decides whether the caller may read them; Laravel
/// remains the authority.
class SessionEvaluationStore extends ChangeNotifier {
  SessionEvaluationStore({required this._api});

  final SessionApi _api;

  SessionEvaluationStatus _status = SessionEvaluationStatus.idle;
  SessionEvaluationResult? _result;
  AppException? _error;
  String? _sessionId;
  int _requestId = 0;

  SessionEvaluationStatus get status => _status;

  SessionEvaluationResult? get result => _result;

  AppException? get error => _error;

  /// Session currently loaded or being loaded.
  String? get sessionId => _sessionId;

  /// Fetches the evaluation for [sessionId].
  ///
  /// Repeating the call for the session that is already loading is ignored so
  /// the screen cannot send duplicate requests.
  Future<void> load(String sessionId) async {
    if (_status == SessionEvaluationStatus.loading && _sessionId == sessionId) {
      return;
    }

    final requestId = ++_requestId;
    _sessionId = sessionId;
    _status = SessionEvaluationStatus.loading;
    _result = null;
    _error = null;
    notifyListeners();

    try {
      final result = await _api.fetchEvaluation(sessionId);
      if (requestId != _requestId) {
        return;
      }
      _result = result;
      _status = SessionEvaluationStatus.success;
    } on AppException catch (error) {
      if (requestId != _requestId) {
        return;
      }
      _error = error;
      _status = SessionEvaluationStatus.error;
    } finally {
      if (requestId == _requestId) {
        notifyListeners();
      }
    }
  }

  /// Resets the store when the screen is left or the user changes.
  void clear() {
    _requestId++;
    _sessionId = null;
    _result = null;
    _error = null;
    _status = SessionEvaluationStatus.idle;
    notifyListeners();
  }
}
