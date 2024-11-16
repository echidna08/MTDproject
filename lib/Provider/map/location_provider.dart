// lib/providers/map/location_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

// 위치 정보를 담는 클래스
class LocationState {
  final NLatLng? currentLocation;

  LocationState({this.currentLocation});

  LocationState copyWith({NLatLng? currentLocation}) {
    return LocationState(
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState());

  void updateLocation(NLatLng location) {
    if (mounted) {
      state = state.copyWith(currentLocation: location);
    }
  }
}
