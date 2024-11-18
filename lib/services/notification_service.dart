import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    print('알림 서비스 초기화 시작');

    // Android 설정
    const androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS 설정
    final DarwinInitializationSettings iosInitialize = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    // 초기화 설정
    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iosInitialize,
    );

    // 알림 초기화
    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('알림 응답 받음: ${response.payload}');
      },
    );

    print('알림 서비스 초기화 완료');
  }

  Future<void> showTestNotification() async {
    print('테스트 알림 전송 시도');

    try {
      // iOS인 경우 권한 확인
      if (Platform.isIOS) {
        final settings = await _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        if (settings == false) {
          throw Exception('iOS 알림 권한이 거부되었습니다.');
        }
      }
      // Android인 경우 권한 확인
      else if (Platform.isAndroid) {
        if (await Permission.notification.isDenied) {
          final status = await Permission.notification.request();
          if (status.isDenied) {                    
            throw Exception('알림 권한이 필요합니다.');
          }
        }
      }

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        enableLights: true,
        color: Colors.blue,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        badgeNumber: 1,
        interruptionLevel: InterruptionLevel.active,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        0,
        'CUver 알림 테스트',
        '이것은 테스트 알림입니다!',
        platformDetails,
        payload: 'test_notification',
      );

      print('알림 전송 성공');
    } catch (e) {
      print('알림 전송 실패: $e');
      rethrow;
    }
  }
}
