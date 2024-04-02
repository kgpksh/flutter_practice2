import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

@immutable
class AuthUser {
  final String? id;
  final String? email;
  final bool isEmailVerified;

  AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });
  
  factory AuthUser.fromFirebaseEmail(User user) =>
      AuthUser(id: user.uid, email: user.email ?? '', isEmailVerified: user.emailVerified);

  factory AuthUser.fromSocialLogin(User user) => AuthUser(id: user.uid, email: user.email ?? '', isEmailVerified: user.emailVerified);
}
