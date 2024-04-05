import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_practice2/secret_keys.dart';
import 'package:flutter_practice2/service/auth/auth_exceptions.dart';
import 'package:flutter_practice2/service/auth/auth_user.dart';
import 'package:flutter_practice2/service/auth/oauth_login/oauth_provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleOAuth extends SocialLoginProvider {
  @override
  Future<AuthUser> logIn({String? email, String? password}) async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
          clientId: SecretKeys().appleClientId,
          redirectUri: Uri.parse(
            SecretKeys().firebaseAppleRedirectUrl,
          )),
    );

    if (appleCredential == null) {
      throw AppleLoginFailed();
    }

    final OAuthCredential credential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    UserCredential firebaseCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (firebaseCredential.user != null) {
      return AuthUser.fromSocialLogin(firebaseCredential.user!);
    }
    throw AppleFinalCredentialException();
  }
}
