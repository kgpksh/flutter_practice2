import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_practice2/service/auth/auth_service.dart';
import 'package:flutter_practice2/service/auth/firebase_email_login/firebase_email_login.dart';
import 'package:flutter_practice2/service/auth/oauth_login/google_login.dart';
import 'package:flutter_practice2/service/auth/oauth_login/kakao_login.dart';
import 'package:meta/meta.dart';
import 'package:flutter_practice2/service/auth/login_provider.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _firebaseLoginService = AuthService.firebaseEmail();
  final LoginProvider _firebaseEmailLogin = FirebaseEmailLogin();
  final LoginProvider _googleLogin = GoogleOAuth();
  final LoginProvider _kakaoLogin = KakaoOAuth();

  AuthBloc() : super(AuthInitial()) {
    on<AuthInitialEvent>((event, emit) async {
      await AuthService.initialize();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(AuthLoggedOut(
          exception: null,
        ));
      } else {
        emit(AuthLoggedIn(isVerified: user.emailVerified));
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
      emit(AuthLoggedOut(
        exception: null,
      ));
      try {
        final user = await _firebaseEmailLogin.logIn(
          email: event.email,
          password: event.password,
        );

        emit(AuthLoggedIn(isVerified: user.isEmailVerified));
      } on Exception catch (e) {
        emit(AuthLoggedOut(
          exception: e,
        ));
      }
    });

    on<GoogleLoginEvent>((event, emit) async {
      emit(AuthLoggedOut(
        exception: null,
      ));

      try {
        final user = await _googleLogin.logIn(email: null, password: null);
        emit(AuthLoggedIn(isVerified: user.isEmailVerified));
      } on Exception catch (e) {
        emit(AuthLoggedOut(
          exception: e,
        ));
      }
    });

    on<KakaoLoginEvent>((event, emit) async {
      emit(AuthLoggedOut(
        exception: null,
      ));

      try {
        final user = await _kakaoLogin.logIn(email: null, password: null);
        emit(AuthLoggedIn(isVerified: user.isEmailVerified));
      } on Exception catch (e) {
        emit(AuthLoggedOut(
          exception: e,
        ));
      }
    });

    on<FirebaseEmailLogoutEvent>((event, emit) async {
      try {
        await _firebaseLoginService.logOut();
        emit(AuthLoggedOut(exception: null));
      } on Exception catch (e) {
        emit(AuthLoggedOut(exception: e));
      }
    });

    on<FirebaseEmailVerifyEvent>((event, emit) async {
      final isVerified = _firebaseEmailLogin.currentUser!.isEmailVerified;
      if (!isVerified) {
        await _firebaseLoginService.sendEmailVerification();
      }
      emit(AuthLoggedIn(isVerified: isVerified));
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
