import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_practice2/service/auth/auth_exceptions.dart';
import 'package:flutter_practice2/service/auth/auth_user.dart';
import 'package:flutter_practice2/service/auth/firebase_email_login/firebase_email_provider.dart';

class FirebaseEmailLogin extends FirebaseEmailProvider {
  @override
  Future<AuthUser> logIn({
    String? email,
    String? password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'invalid-password':
          throw InvalidPasswordAuthException();
        case 'invalid-credential':
          throw InvalidEmailAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
