import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:flutter_practice2/service/auth/auth_exceptions.dart';
import 'package:flutter_practice2/service/auth/auth_provider.dart';
import 'package:flutter_practice2/service/auth/auth_user.dart';
import 'package:flutter_practice2/service/auth/firebase_email_login/firebase_email_login.dart';
import 'package:flutter_practice2/service/auth/login_provider.dart';
import 'package:flutter_practice2/service/auth/oauth_login/google_login.dart';

class FirebaseLoginProvider implements AuthProvider {
  final LoginProvider loginProvider;

  FirebaseLoginProvider({required this.loginProvider});

  factory FirebaseLoginProvider.firebaseEmail() => FirebaseLoginProvider(loginProvider: FirebaseEmailLogin());
  factory FirebaseLoginProvider.googleLogin() => FirebaseLoginProvider(loginProvider: GoogleOAuth());

  @override
  AuthUser? get currentUser => loginProvider.currentUser;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String? password,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password!);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw WeakPasswordAuthException();
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'email-already-exists':
          throw EmailAlreadyExistsAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<AuthUser> logIn({required String? email, required String? password}) {
    return loginProvider.logIn(email: email, password: password);
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'user-not-found':
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
