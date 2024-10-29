// lib/providers/map/location_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class LocationState {
  final NLatLng currentLocation;
  final List<NLatLng> nearbyFacilities;
  final double searchRadius;

  LocationState({
    required this.currentLocation,
    this.nearbyFacilities = const [],
    this.searchRadius = 30.0,
  });
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier()
      : super(LocationState(
    currentLocation: NLatLng(37.5666102, 126.9783881),
  ));

  void updateLocation(NLatLng newLocation) {
    state = LocationState(
      currentLocation: newLocation,
      nearbyFacilities: state.nearbyFacilities,
      searchRadius: state.searchRadius,
    );
  }

  void updateNearbyFacilities(List<NLatLng> facilities) {
    state = LocationState(
      currentLocation: state.currentLocation,
      nearbyFacilities: facilities,
      searchRadius: state.searchRadius,
    );
  }
}