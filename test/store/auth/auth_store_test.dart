import 'package:flutter_test/flutter_test.dart';
import 'package:grr/constants/app_enums.dart';
import 'package:grr/model/auth/auth_session.dart';
import 'package:grr/model/auth/auth_user.dart';
import 'package:grr/store/auth/auth_store.dart';
import 'package:grr/utils/app_exception.dart';

import '../../helpers/auth_fakes.dart';

AuthUser _user() {
  return const AuthUser(
    uuid: 'uuid-1',
    employeeCode: 'EMP-0001',
    name: 'Rina',
    role: UserRole.inspector,
    status: AccountStatus.active,
  );
}

AuthSession _session({String token = 'token-1'}) {
  return AuthSession(token: token, user: _user());
}

void main() {
  group('AuthStore.restoreSession', () {
    test('starts in the unknown state', () {
      final store = AuthStore(
        api: FakeAuthApi(),
        storage: InMemorySessionStorage(),
      );

      expect(store.status, AuthStatus.unknown);
      expect(store.user, isNull);
    });

    test('restores a persisted session', () async {
      final storage = InMemorySessionStorage()..storedSession = _session();
      final store = AuthStore(api: FakeAuthApi(), storage: storage);

      await store.restoreSession();

      expect(store.status, AuthStatus.authenticated);
      expect(store.token, 'token-1');
      expect(store.user?.employeeCode, 'EMP-0001');
    });

    test('becomes unauthenticated when nothing is stored', () async {
      final store = AuthStore(
        api: FakeAuthApi(),
        storage: InMemorySessionStorage(),
      );

      await store.restoreSession();

      expect(store.status, AuthStatus.unauthenticated);
      expect(store.error, isNull);
    });
  });

  group('AuthStore.login', () {
    test('persists the session and exposes the token', () async {
      final api = FakeAuthApi()..loginResult = _session();
      final storage = InMemorySessionStorage();
      final store = AuthStore(api: api, storage: storage);

      final success = await store.login(
        employeeCode: '  EMP-0001  ',
        password: 'secret',
      );

      expect(success, isTrue);
      expect(store.status, AuthStatus.authenticated);
      expect(store.token, 'token-1');
      expect(storage.storedSession, _session());
      expect(api.loginCalls.single.employeeCode, 'EMP-0001');
    });

    test('exposes backend errors without authenticating', () async {
      const error = AppException(
        kind: AppExceptionKind.validation,
        fieldErrors: <String, String>{'employee_code': 'Wajib diisi.'},
      );
      final api = FakeAuthApi()..loginError = error;
      final store = AuthStore(api: api, storage: InMemorySessionStorage());

      final success = await store.login(
        employeeCode: 'EMP-0001',
        password: 'secret',
      );

      expect(success, isFalse);
      expect(store.status, AuthStatus.unknown);
      expect(store.error, same(error));
    });

    test('reports a storage failure instead of authenticating', () async {
      final api = FakeAuthApi()..loginResult = _session();
      final storage = InMemorySessionStorage()..failOnWrite = true;
      final store = AuthStore(api: api, storage: storage);

      final success = await store.login(
        employeeCode: 'EMP-0001',
        password: 'secret',
      );

      expect(success, isFalse);
      expect(store.status, AuthStatus.unknown);
      expect(store.error?.kind, AppExceptionKind.sessionStorageFailed);
    });
  });

  group('AuthStore.logout', () {
    test('clears local state and storage', () async {
      final api = FakeAuthApi()..loginResult = _session();
      final storage = InMemorySessionStorage();
      final store = AuthStore(api: api, storage: storage);
      await store.login(employeeCode: 'EMP-0001', password: 'secret');

      await store.logout();

      expect(api.logoutCalls, 1);
      expect(store.status, AuthStatus.unauthenticated);
      expect(store.token, isNull);
      expect(storage.storedSession, isNull);
    });

    test('still clears local state when the API call fails', () async {
      final api = FakeAuthApi()
        ..loginResult = _session()
        ..logoutError = const AppException(kind: AppExceptionKind.unauthorized);
      final storage = InMemorySessionStorage();
      final store = AuthStore(api: api, storage: storage);
      await store.login(employeeCode: 'EMP-0001', password: 'secret');

      await store.logout();

      expect(store.status, AuthStatus.unauthenticated);
      expect(storage.storedSession, isNull);
    });
  });

  group('AuthStore.register', () {
    test('never sends a role and does not authenticate', () async {
      final api = FakeAuthApi();
      final store = AuthStore(api: api, storage: InMemorySessionStorage());

      final success = await store.register(
        employeeCode: 'EMP-0009',
        name: 'Baru',
        email: 'baru@example.test',
        password: 'secret',
        passwordConfirmation: 'secret',
      );

      expect(success, isTrue);
      expect(api.registerCalls.single.toJson().containsKey('role'), isFalse);
      expect(store.status, AuthStatus.unknown);
    });

    test('exposes validation errors', () async {
      final api = FakeAuthApi()
        ..registerError = const AppException(kind: AppExceptionKind.validation);
      final store = AuthStore(api: api, storage: InMemorySessionStorage());

      final success = await store.register(
        employeeCode: 'EMP-0009',
        name: 'Baru',
        password: 'secret',
        passwordConfirmation: 'secret',
      );

      expect(success, isFalse);
      expect(store.error?.kind, AppExceptionKind.validation);
    });
  });

  group('AuthStore.handleUnauthorized', () {
    test('clears the expired session', () async {
      final api = FakeAuthApi()..loginResult = _session();
      final storage = InMemorySessionStorage();
      final store = AuthStore(api: api, storage: storage);
      await store.login(employeeCode: 'EMP-0001', password: 'secret');

      await store.handleUnauthorized();

      expect(store.status, AuthStatus.unauthenticated);
      expect(store.token, isNull);
      expect(storage.storedSession, isNull);
    });
  });
}
