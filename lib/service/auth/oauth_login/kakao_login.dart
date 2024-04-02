import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_practice2/service/auth/auth_exceptions.dart';
import 'package:flutter_practice2/service/auth/auth_user.dart';
import 'package:flutter_practice2/service/auth/oauth_login/oauth_provider.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoOAuth extends SocialLoginProvider {
  @override
  Future<AuthUser> logIn({String? email, String? password}) async {
    OAuthToken kakaoToken;
    if (await isKakaoTalkInstalled()) {
      kakaoToken = await _kakaoTalkLogin();
    } else {
      kakaoToken = await _kakaoAccountLogin();
    }

    var provider = OAuthProvider('oidc.flutter_practice2');
    var credential = provider.credential(
      idToken: kakaoToken.idToken,
      accessToken: kakaoToken.accessToken,
    );
    UserCredential firebaseCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (firebaseCredential.user != null) {
      return AuthUser.fromSocialLogin(firebaseCredential.user!);
    }
    throw KakaoFinalCredentialException();
  }

  Future<OAuthToken> _kakaoTalkLogin() async {
    try {
      return await UserApi.instance.loginWithKakaoTalk();
    } catch (error) {
      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (error is PlatformException && error.code == 'CANCELED') {
        throw KakaoLoginCanceledException();
      }
      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
      return await _kakaoAccountLogin();
    }
  }

  Future<OAuthToken> _kakaoAccountLogin() async {
    try {
      return await UserApi.instance.loginWithKakaoAccount();
    } catch (error) {
      throw KakaoLoginFailedException();
    }
  }
}
