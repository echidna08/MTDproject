// lib/providers/map/geofence_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final geofenceProvider = StateNotifierProvider<GeofenceNotifier, Set<String>>((ref) {
  return GeofenceNotifier();
});

class GeofenceNotifier extends StateNotifier<Set<String>> {
  GeofenceNotifier() : super({});

  void addGeofence(String facilityId) {
    state = {...state, facilityId};
  }

  void removeGeofence(String facilityId) {
    state = state.where((id) => id != facilityId).toSet();
  }
}