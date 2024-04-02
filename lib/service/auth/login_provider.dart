import 'package:flutter_practice2/service/auth/auth_user.dart';

abstract class LoginProvider {
  AuthUser? get currentUser;
  Future<AuthUser> logIn({required String? email, required String? password});
}