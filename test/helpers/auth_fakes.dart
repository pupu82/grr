import 'package:dio/dio.dart';
import 'package:grr/api/auth_api.dart';
import 'package:grr/model/auth/auth_session.dart';
import 'package:grr/model/auth/login_request.dart';
import 'package:grr/model/auth/register_request.dart';
import 'package:grr/utils/app_exception.dart';
import 'package:grr/utils/storage.dart';

/// In-memory [SessionStorage] used by unit tests.
class InMemorySessionStorage implements SessionStorage {
  AuthSession? storedSession;
  int clearCalls = 0;
  bool failOnWrite = false;

  @override
  Future<AuthSession?> read() async => storedSession;

  @override
  Future<void> write(AuthSession session) async {
    if (failOnWrite) {
      throw Exception('storage unavailable');
    }
    storedSession = session;
  }

  @override
  Future<void> clear() async {
    clearCalls++;
    storedSession = null;
  }
}

/// [AuthApi] substitute that records calls and returns canned results.
class FakeAuthApi extends AuthApi {
  FakeAuthApi() : super(Dio());

  final List<LoginRequest> loginCalls = <LoginRequest>[];
  final List<RegisterRequest> registerCalls = <RegisterRequest>[];
  int logoutCalls = 0;

  AuthSession? loginResult;
  AppException? loginError;
  AppException? registerError;
  AppException? logoutError;

  @override
  Future<AuthSession> login(LoginRequest request) async {
    loginCalls.add(request);
    final error = loginError;
    if (error != null) {
      throw error;
    }
    final result = loginResult;
    if (result == null) {
      throw StateError('FakeAuthApi.loginResult was not configured');
    }
    return result;
  }

  @override
  Future<void> register(RegisterRequest request) async {
    registerCalls.add(request);
    final error = registerError;
    if (error != null) {
      throw error;
    }
  }

  @override
  Future<void> logout() async {
    logoutCalls++;
    final error = logoutError;
    if (error != null) {
      throw error;
    }
  }
}
