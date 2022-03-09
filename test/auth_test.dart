import 'package:flutter_test/flutter_test.dart';
import 'package:noteefy/exceptions/auth_exceptions.dart';
import 'package:noteefy/services/auth/auth_provider.dart';
import 'package:noteefy/services/auth/auth_user.dart';

void main() {
  group('Mock Authentication', (){
    final provider = MockAuthProvider();

    test('Should not be initialized to begin with', (){
      expect(provider.isInitialized, false);
    });

    test('Cannot logout if not initialized', (){
      expect(provider.logOut(), throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User Should be null after initialization', () async {
      expect(provider.currentUser, null);
    });

    test('Should be able to initialize in less than 2 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('Create User Should delegate to login', () async {
      final wrongUserEmail = provider.createUser(email: 'foo@bar.com', password: 'password');
      expect(wrongUserEmail, throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final wrongUserPassword = provider.createUser(email: 'user@gmail.com', password: 'foobar');
      expect(wrongUserPassword, throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(email: 'foo@gmail.com', password: 'password');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });


    test('Logged in User Should be able to get verified', () async {
      provider.sendVerificationEmail();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user?.isEmailVerified, true);
    });


    test('Should be able to logout and login again', () async {
      await provider.logOut();
      await provider.logIn(email: 'user@gmail.com', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class MockAuthProvider implements AuthProvider{
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({required String email, required String password}) async {
    if(!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async{
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if(!isInitialized) throw NotInitializedException();
    if(email == 'foo@bar.com') throw UserNotFoundAuthException();
    if(password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if(!isInitialized) throw NotInitializedException();
    if(_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;

  }

  @override
  Future<void> sendVerificationEmail() async {
    if(!isInitialized) throw NotInitializedException();
    final user = _user;
    if(user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }

}