import 'package:flutter_practice2/service/auth/auth_provider.dart';
import 'package:flutter_practice2/service/auth/auth_user.dart';
import 'package:flutter_practice2/service/auth/firebase_email_provider.dart';

class AuthService implements AuthProvider {
  @override
  Future<void> initialize() => provider.initialize();
  final AuthProvider provider;

  const AuthService(this.provider);

  factory AuthService.firebaseEmail() => AuthService(FirebaseEmailProvider());

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> createUser({
    required String email,
    String? password,
  }) {
    return provider.createUser(email: email, password: password);
  }

  @override
  Future<AuthUser> logIn({required String email, required String? password}) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      provider.sendPasswordReset(toEmail: toEmail);

}
