import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_practice2/service/auth/auth_service.dart';
import 'package:flutter_practice2/service/auth/firebase_email_login/firebase_email_login.dart';
import 'package:flutter_practice2/service/auth/oauth_login/apple_login.dart';
import 'package:flutter_practice2/service/auth/oauth_login/google_login.dart';
import 'package:flutter_practice2/service/auth/oauth_login/kakao_login.dart';
import 'package:flutter_practice2/service/auth/oauth_login/naver_login.dart';
import 'package:meta/meta.dart';
import 'package:flutter_practice2/service/auth/login_provider.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  StreamSubscription<User?>? authListener;
  final AuthService _firebaseLoginService = AuthService.firebaseEmail();
  final LoginProvider _firebaseEmailLogin = FirebaseEmailLogin();
  final LoginProvider _googleLogin = GoogleOAuth();
  final LoginProvider _kakaoLogin = KakaoOAuth();
  final LoginProvider _appleLogin = AppleOAuth();
  final LoginProvider _naverLogin = NaverOAuth();


  @override
  Future<void> close() {
    authListener?.cancel();
    return super.close();
  }

  AuthBloc() : super(AuthInitial()) {
    on<AuthInitialEvent>((event, emit) async {
      await AuthService.initialize();
      authListener = FirebaseAuth.instance.authStateChanges().listen((User? user) {
        add(AuthChangedEvent(user: user));
      });
    });

    on<AuthChangedEvent>((event, emit) {
      try{
        if (event.user == null) {
          emit(AuthLoggedOut(exception: null));
        } else {
          final bool isEmailLogin = event.user!.providerData.first.providerId == 'password';
          final bool isVerified = event.user!.emailVerified;
          emit(AuthLoggedIn(isVerified: !isEmailLogin || isVerified, userId: event.user!.uid));
        }
      } on Exception catch (e) {
        emit(AuthLoggedOut(exception: e));
      }

    });

    on<FirebaseEmailRegisterEvent>((event, emit) async {
      try {
        await _firebaseLoginService.createUser(
            email: event.email, password: event.password);
        await _firebaseLoginService.sendEmailVerification();
        emit(AuthFirebaseEmailRegistered());
      } on Exception catch (e) {
        emit(AuthFirebaseEmailRegistering(exception: e));
      }
    });

    on<FirebaseEmailLoginEvent>((event, emit) async {
      await _firebaseEmailLogin.logIn(
        email: event.email,
        password: event.password,
      );
    });

    on<GoogleLoginEvent>((event, emit) async {
      await _googleLogin.logIn(email: null, password: null);
    });

    on<AppleLoginEvent>((event, emit) async {
      await _appleLogin.logIn(email: null, password: null);
    });

    on<KakaoLoginEvent>((event, emit) async {
      await _kakaoLogin.logIn(email: null, password: null);
    });

    on<NaverLoginEvent>((event, emit) async {
      await _naverLogin.logIn(email: null, password: null);
    });

    on<FirebaseEmailLogoutEvent>((event, emit) async {
      await _firebaseLoginService.logOut();
    });

    on<FirebaseEmailVerifyEvent>((event, emit) async {
      final user = _firebaseEmailLogin.currentUser;
      final isVerified = user!.isEmailVerified;
      if (!isVerified) {
        await _firebaseLoginService.sendEmailVerification();
      }
      emit(AuthLoggedIn(isVerified: isVerified, userId: user.id!));
    });

    on<FirebaseForgotPasswordEvent>((event, emit) async {
      try {
        await _firebaseLoginService.sendPasswordReset(toEmail: event.email);
        emit(ResetPasswordState(hasSent: true));
      } on Exception catch (e) {
        emit(ResetPasswordState(exception: e, hasSent: false));
      }
    });
  }
}
