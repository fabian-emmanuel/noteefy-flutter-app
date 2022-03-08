
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noteefy/services/auth/auth_exceptions.dart';
import 'package:noteefy/services/auth/auth_provider.dart';
import 'package:noteefy/services/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProvider{
  @override
  Future<AuthUser> createUser({required String email, required String password}) async {
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      return (user != null) ? user : throw UserNotLoggedInAuthException();
    } on FirebaseAuthException catch (e){
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_){
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    return (user != null) ? AuthUser.fromFireBase(user) : throw UserNotFoundAuthException();
  }

  @override
  Future<AuthUser> logIn ({required String email, required String password}) async {
     try {
       await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email, password: password);
       final user = currentUser;
       return (user != null) ? user : throw UserNotLoggedInAuthException();
     } on FirebaseAuthException catch (e) {
       if (e.code == 'user-not-found') {
         throw UserNotFoundAuthException();
       } else if (e.code == 'wrong-password') {
         throw WrongPasswordAuthException();
       } else if (e.code == 'invalid-email') {
         throw InvalidEmailAuthException();
       }else {
         throw GenericAuthException();
       }
     } catch (_) {
       throw GenericAuthException();
      }
  } 

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    return (user != null) ? await FirebaseAuth.instance.signOut() : throw UserNotFoundAuthException();
  }

  @override
  Future<void> sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    (user != null) ? await user.sendEmailVerification() : throw UserNotLoggedInAuthException();
  }

}