import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_practice2/service/auth/auth_user.dart';
import 'package:flutter_practice2/service/auth/login_provider.dart';

abstract class FirebaseEmailProvider extends LoginProvider {
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return AuthUser.fromFirebaseEmail(user);
    } else {
      return null;
    }
  }

  Future<AuthUser> logIn({
    String? email,
    String? password,
  });
}