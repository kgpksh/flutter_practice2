import 'package:bloc/bloc.dart';
import 'package:flutter_practice2/service/auth/firebase_email_provider.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseEmailProvider _firebaseEmail;

  AuthBloc(this._firebaseEmail) : super(AuthInitial()) {
    on<AuthInitialEvent>((event, emit) async {
      await _firebaseEmail.initialize();
      final user = _firebaseEmail.currentUser;

      if (user == null) {
        emit(AuthLoggedOut(
          exception: null,
        ));
      } else {
        emit(AuthLoggedIn(isVerified: user.isEmailVerified));
      }
    });

    on<FirebaseEmailRegisterEvent>((event, emit) async {
      try {
        await _firebaseEmail.createUser(
            email: event.email, password: event.password);
        await _firebaseEmail.sendEmailVerification();
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
        final user = await _firebaseEmail.logIn(
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

    on<FirebaseEmailLogoutEvent>((event, emit) async {
      try {
        await _firebaseEmail.logOut();
        emit(AuthLoggedOut(exception: null));
      } on Exception catch (e) {
        emit(AuthLoggedOut(exception: e));
      }
    });

    on<FirebaseEmailVerifyEvent>((event, emit) async {
      final isVerified = _firebaseEmail.currentUser!.isEmailVerified;
      if (!isVerified) {
        await _firebaseEmail.sendEmailVerification();
      }
      emit(AuthLoggedIn(isVerified: isVerified));
    });

    on<FirebaseForgotPasswordEvent>((event, emit) async {
      try {
        await _firebaseEmail.sendPasswordReset(toEmail: event.email);
        emit(ResetPasswordState(hasSent: true));
      } on Exception catch (e) {
        emit(ResetPasswordState(exception: e, hasSent: false));
      }
    });
  }
}
