import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_practice2/service/auth/auth_exceptions.dart';
import 'package:flutter_practice2/service/auth/auth_user.dart';
import 'package:flutter_practice2/service/auth/oauth_login/oauth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleOAuth extends SocialLoginProvider {
  @override
  Future<AuthUser> logIn({
    String? email,
    String? password,
  }) async {
    if(currentUser != null) {
      return currentUser!;
    }

    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _account = await _googleSignIn.signIn();
    if(_account == null) {
      throw GoogleAuthException();
    }

    GoogleSignInAuthentication _authentication =
    await _account.authentication;
    OAuthCredential _googleCredential = GoogleAuthProvider.credential(
      idToken: _authentication.idToken,
      accessToken: _authentication.accessToken,
    );

    UserCredential _credential =
    await FirebaseAuth.instance.signInWithCredential(_googleCredential);
    if (_credential.user != null) {
      return AuthUser.fromSocialLogin(_credential.user!);
    }

    throw GoogleFinalCredentialException();
  }
}
