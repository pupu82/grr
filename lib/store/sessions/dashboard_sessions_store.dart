import 'package:flutter/foundation.dart';

import '../../api/session_api.dart';
import '../../model/report/session_summary.dart';
import '../../utils/app_exception.dart';

/// Explicit lifecycle for the dashboard sessions list.
enum DashboardSessionsStatus { idle, loading, success, error }

/// Loads the session list for the dashboard.
///
/// The store coordinates the request and exposes typed state. It never
/// calculates metrics or decides access; Laravel remains the authority.
class DashboardSessionsStore extends ChangeNotifier {
  DashboardSessionsStore({required this._api});

  final SessionApi _api;

  DashboardSessionsStatus _status = DashboardSessionsStatus.idle;
  List<SessionSummary> _sessions = const <SessionSummary>[];
  AppException? _error;
  String? _statusFilter;
  int _requestId = 0;

  DashboardSessionsStatus get status => _status;

  List<SessionSummary> get sessions => _sessions;

  AppException? get error => _error;

  /// The status filter currently applied, or `null` for all sessions.
  String? get statusFilter => _statusFilter;

  /// Loads sessions, optionally filtered by [status].
  Future<void> load({String? status}) async {
    if (_status == DashboardSessionsStatus.loading && _statusFilter == status) {
      return;
    }

    final requestId = ++_requestId;
    _statusFilter = status;
    _status = DashboardSessionsStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final sessions = await _api.listSessions(status: status);
      if (requestId != _requestId) {
        return;
      }
      _sessions = sessions;
      _status = DashboardSessionsStatus.success;
    } on AppException catch (error) {
      if (requestId != _requestId) {
        return;
      }
      _error = error;
      _status = DashboardSessionsStatus.error;
    } finally {
      if (requestId == _requestId) {
        notifyListeners();
      }
    }
  }

  /// Refreshes the current list with the same filter.
  Future<void> refresh() => load(status: _statusFilter);

  /// Resets the store when the screen is left or the user changes.
  void clear() {
    _requestId++;
    _statusFilter = null;
    _sessions = const <SessionSummary>[];
    _error = null;
    _status = DashboardSessionsStatus.idle;
    notifyListeners();
  }
}
