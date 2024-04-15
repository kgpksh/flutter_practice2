part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthInitialEvent extends AuthEvent {}

class AuthChangedEvent extends AuthEvent {
  User? user;
  AuthChangedEvent({required this.user});
}

class FirebaseEmailRegisterEvent extends AuthEvent {
  final String email;
  final String password;

  FirebaseEmailRegisterEvent({required this.email, required this.password});
}

class FirebaseEmailLoginEvent extends AuthEvent {
  final String email;
  final String password;

  FirebaseEmailLoginEvent({required this.email, required this.password});
}

class GoogleLoginEvent extends AuthEvent {}

class KakaoLoginEvent extends AuthEvent {}

class AppleLoginEvent extends AuthEvent {}

class NaverLoginEvent extends AuthEvent {}

class FirebaseEmailLogoutEvent extends AuthEvent {}

class FirebaseEmailVerifyEvent extends AuthEvent {}

class FirebaseForgotPasswordEvent extends AuthEvent {
  final String email;

  FirebaseForgotPasswordEvent({required this.email});
}
