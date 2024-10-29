import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class KakaoOAuthService {
  static const String authorizationEndpoint = 'https://kauth.kakao.com/oauth/authorize';
  static const String tokenEndpoint = 'https://kauth.kakao.com/oauth/token';
  static const String clientId = '5e02af0aab7c259abc19a427f4f2bc9d';
  static const String redirectUri = 'kakao5e02af0aab7c259abc19a427f4f2bc9d://oauth';

  Future<void> login(BuildContext context) async {
    try {
      print('========== 카카오 로그인 시작');
      final authCode = await _getAuthorizationCode();
      if (authCode != null) {
        print('========== 인증 코드 획득: $authCode');
        await _requestToken(authCode, context);
      } else {
        throw '========== 인증 코드가 없습니다';
      }
    } catch (e) {
      print('========== 로그인 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인에 실패했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _getAuthorizationCode() async {
    final authorizationUrl = Uri.parse(
        '$authorizationEndpoint?'
            'client_id=$clientId&'
            'redirect_uri=$redirectUri&'
            'response_type=code&'
            'scope=profile_nickname,profile_image'
    );

    try {
      final result = await FlutterWebAuth.authenticate(
        url: authorizationUrl.toString(),
        callbackUrlScheme: "kakao5e02af0aab7c259abc19a427f4f2bc9d",
      );

      final uri = Uri.parse(result);
      return uri.queryParameters['code'];
    } catch (e) {
      print('========== 인증 실패: $e');
      return null;
    }
  }

  Future<void> _requestToken(String authCode, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(tokenEndpoint),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
        },
        body: {
          'grant_type': 'authorization_code',
          'client_id': clientId,
          'redirect_uri': redirectUri,
          'code': authCode,
        },
      );

      print('Token request status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['access_token'];
        print('========== 액세스 토큰: $accessToken');
        _onLoginSuccess(context, accessToken);
      } else {
        throw '토큰 요청 실패: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      print('========== 토큰 요청 중 오류: $e');
      rethrow;
    }
  }

  void _onLoginSuccess(BuildContext context, String accessToken) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('로그인에 성공했습니다'),
        backgroundColor: Colors.green,
      ),
    );

    print('========== 로그인 성공! 액세스 토큰: $accessToken');

    // 메인 화면으로 이동
    Navigator.of(context).pushReplacementNamed('/main');
  }
}