part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthFirebaseEmailRegister extends AuthState {}

class AuthFirebaseEmailRegistering extends AuthState {
  final Exception? exception;

  AuthFirebaseEmailRegistering({required this.exception});
}

class AuthFirebaseEmailRegistered extends AuthState {}

class AuthLoggedOut extends AuthState {
  final Exception? exception;

  AuthLoggedOut({required this.exception});
}

class AuthLoggedIn extends AuthState {
  final bool isVerified;
  final String userId;

  AuthLoggedIn({required this.isVerified, required this.userId});
}

class ResetPasswordState extends AuthState {
  final Exception? exception;
  final bool hasSent;

  ResetPasswordState({this.exception, required this.hasSent});
}