import 'package:flutter/material.dart';
import 'kakao_oauth_service.dart';

class LoginPage extends StatelessWidget {
  final KakaoOAuthService _kakaoService = KakaoOAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              // 로고 영역
              Center(
                child: Column(
                  children: [
                    const Text(
                      'CUver',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0BC473),
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '편하게 찾는 정보',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              // 로그인 버튼
              GestureDetector(
                onTap: () async {
                  try {
                    await _kakaoService.login(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('로그인 실패: $e')),
                    );
                  }
                },
                child: Image.asset(
                  'assets/image/kakao_login.png',
                  height: 48,
                ),
              ),
              const SizedBox(height: 16),
              // 이용약관
              const Center(
                child: Text(
                  '로그인은 이용약관 및 개인정보 처리방침에 동의하는 것을 의미합니다',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'Pretendard',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
