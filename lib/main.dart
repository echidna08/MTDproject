import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'main_screen.dart';
import 'oauth/login_page.dart';

void main() {
  // Future<void>로 감싸서 비동기 처리
  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 카카오 SDK 초기화
    KakaoSdk.init(nativeAppKey: '{5e02af0aab7c259abc19a427f4f2bc9}');

    // 네이버 지도 SDK 초기화
    await NaverMapSdk.instance.initialize(
      clientId: '32w5an7m3b',
      onAuthFailed: (error) {
        print("네이버 지도 인증 실패: $error");
      },
    );
  }

  // 초기화 후 앱 실행
  initialize().then((_) {
    runApp(
      ProviderScope(
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CUver',
      theme: ThemeData(
        primaryColor: Color(0xFF0BC473),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/main': (context) => MainScreen(),
      },
    );
  }
}