import 'package:bike/services/auth/auth_exceptions.dart';
import 'package:bike/services/auth/auth_provider.dart';
import 'package:bike/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot logout if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(isA<NotInitializedException>()), // Use isA instead of TypeMatcher
      );
    });

    test('Should be able to initialize', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () async {
      await provider.initialize();
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create user should delegate to login function', () async {
      // Test bad email
      expect(
        provider.createUser(email: 'foo@bar.com', password: 'anypassword'),
        throwsA(isA<UserNotFoundAuthException>()),
      );

      // Test bad password
      expect(
        provider.createUser(email: 'someone@bar.com', password: 'foobar'),
        throwsA(isA<WrongPasswordAuthException>()),
      );

      // Test successful creation
      final user = await provider.createUser(email: 'foo', password: 'bar');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () async {
      await provider.initialize();
      await provider.createUser(email: 'foo', password: 'bar');
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log in and out again', () async {
      await provider.initialize();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
      await provider.logOut();
      expect(provider.currentUser, null);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  bool _isInitialized = false; // Non-final to allow changes
  bool get isInitialized => _isInitialized;

  AuthUser? _user; // Declare _user field

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true; // Update initialization state
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    _user = const AuthUser(isEmailVerified: true); // Update _user instead of newUser
  }
}