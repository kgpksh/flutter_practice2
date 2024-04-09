import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_practice2/secret_keys.dart';
import 'package:flutter_practice2/service/auth/auth_exceptions.dart';
import 'package:flutter_practice2/service/auth/auth_user.dart';
import 'package:flutter_practice2/service/auth/oauth_login/oauth_provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class NaverOAuth extends SocialLoginProvider {
  StreamSubscription? _linkStream;

  @override
  Future<AuthUser> logIn({String? email, String? password}) async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        await _signWithNaver();
        UserCredential credential = await _handleDeepLink(initialLink);
        if(credential.user != null) {
          return AuthUser.fromSocialLogin(credential.user!);
        }
        throw NaverInitialException();
      } else {
        AuthUser? user;
        _linkStream = linkStream.listen((String? link) async {
          UserCredential credential = await _handleDeepLink(link!);
          if(credential.user != null) {
            user =  AuthUser.fromSocialLogin(credential.user!);
            _linkStream?.cancel();
          }
        }, onError: (err) {
          throw err;
        });

        await _signWithNaver();
        if(user != null) {
          return user!;
        }

        throw NaverDeepLinkException();
      }

    }finally {
      _linkStream?.cancel();
    }
  }

  Future<void> _signWithNaver() async {
    String clientId = SecretKeys().naverClientId;
    String redirectUri = SecretKeys().naverRedirectUrl;
    String state =
        base64Url.encode(List<int>.generate(16, (_) => Random().nextInt(255)));
    Uri url = Uri.parse(
        'https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&state=$state');

    await launchUrl(url);
  }

  Future<UserCredential> _handleDeepLink(String link) async {
    final Uri uri = Uri.parse(link);

    if(uri.authority != 'login-callback') {
      throw NaverDeepLinkException();
    }

    String? firebaseToken = uri.queryParameters['firebaseToken'];
    String? name = uri.queryParameters['name'];
    String? profileImage=  uri.queryParameters['profileImage'];

    return await FirebaseAuth.instance.signInWithCustomToken(firebaseToken!);
  }
}
