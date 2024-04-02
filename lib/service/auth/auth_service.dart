import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_practice2/firebase_options.dart';
import 'package:flutter_practice2/service/auth/auth_provider.dart';
import 'package:flutter_practice2/service/auth/auth_user.dart';
import 'package:flutter_practice2/service/auth/firebase_login.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService({required this.provider});

  factory AuthService.firebaseEmail() => AuthService(provider : FirebaseLoginProvider.firebaseEmail());
  factory AuthService.googleLogin() => AuthService(provider: FirebaseLoginProvider.googleLogin());

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    String? password,
  }) {
    return provider.createUser(email: email, password: password);
  }

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      provider.sendPasswordReset(toEmail: toEmail);

}
