// lib/screens/map/map_screen.dart
import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import 'component/search_bar.dart';
import 'component/filter_button.dart';
import 'component/location_list_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late NaverMapController _mapController;
  NMarker? _locationMarker;
  StreamSubscription<Position>? _positionStreamSubscription;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInGeofence = false;

  // 금정구청 위치
  final targetLocation = {
    'latitude': 35.2429,
    'longitude': 129.0895,
    'radius': 100.0 // 반경 100미터
  };

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _requestLocationPermission();
  }

  Future<void> _initializeNotifications() async {
    // Android 설정 추가
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 설정
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        // 알림 탭 핸들링
      },
    );

    // 알림 권한 요청
    await _requestNotificationPermissions();
  }

  Future<void> _requestNotificationPermissions() async {
    // iOS 권한
    if (io.Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    // Android 권한
    if (io.Platform.isAndroid) {
      await Permission.notification.request();
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _startLocationTracking();
    }
  }

  void _startLocationTracking() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      _updateLocationOnMap(position);
      _checkGeofence(position);
    });
  }

  void _checkGeofence(Position position) {
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      targetLocation['latitude']!,
      targetLocation['longitude']!,
    );

    print('현재 위치: ${position.latitude}, ${position.longitude}');
    print(
        '목표 위치: ${targetLocation['latitude']}, ${targetLocation['longitude']}');
    print('현재 거리: ${distance}m');
    print('현재 지오펜스 상태: $_isInGeofence');

    bool isNowInGeofence = distance <= targetLocation['radius']!;

    // 영역 진입 시
    if (isNowInGeofence && !_isInGeofence) {
      print('지오펜스 영역 진입');
      _showNotification("금정구청 근처입니다", "현재 금정구청 반경 100m 이내에 있습니다.");
      _isInGeofence = true;
    }
    // 영역 이탈 시
    else if (!isNowInGeofence && _isInGeofence) {
      print('지오펜스 영역 이탈');
      _showNotification("금정구청을 벗어났습니다", "금정구청 반경을 벗어났습니다.");
      _isInGeofence = false;
    }
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'geofence_channel',
      '위치 알림',
      channelDescription: '위치 기반 알림을 위한 채널',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        details,
      );
      print('알림 전송 성공');
    } catch (e) {
      print('알림 전송 실패: $e');
    }
  }

  void _updateLocationOnMap(Position position) async {
    if (!mounted) return;

    try {
      final latLng = NLatLng(position.latitude, position.longitude);

      if (_locationMarker != null) {
        await _mapController.deleteOverlay(_locationMarker!.info);
      }

      _locationMarker = NMarker(
        id: 'current_location',
        position: latLng,
      );

      if (_mapController != null) {
        await _mapController.addOverlay(_locationMarker!);

        // 카메라 이동
        await _mapController.updateCamera(
          NCameraUpdate.withParams(
            target: latLng,
            zoom: 15,
          ),
        );
      }

      print('마커 업데이트 완료: ${position.latitude}, ${position.longitude}'); // 디버그용
    } catch (e) {
      print('마커 업데이트 실패: $e'); // 에러 출력
    }
  }

  void _onMapReady(NaverMapController controller) {
    setState(() {
      _mapController = controller;
      print('지도 컨트롤러 초기화 완료'); // 디버그용
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(35.2429, 129.0895),
                zoom: 15,
              ),
              contentPadding: EdgeInsets.only(bottom: 24, right: 24),
            ),
            onMapReady: _onMapReady,
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: const CustomSearchBar(),
                      ),
                      SizedBox(width: 8),
                      FilterButton(),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    print('알림 테스트 버튼 클');
                    await _showNotification(
                        "테스트 알림 ${DateTime.now()}", "이것은 테스트 알림입니다.");
                  },
                  child: Text("알림 테스트"),
                ),
              ],
            ),
          ),
          LocationListSheet(),
        ],
      ),
    );
  }
}
