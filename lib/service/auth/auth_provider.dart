import 'package:flutter_practice2/service/auth/auth_user.dart';

abstract class AuthProvider {
  Future<AuthUser> createUser({
    required String email,
    required String? password,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();

  Future<void> sendPasswordReset({required String toEmail});
}