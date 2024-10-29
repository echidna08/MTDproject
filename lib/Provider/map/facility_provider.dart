import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/map/facility.dart';




final facilityProvider = StateNotifierProvider<FacilityNotifier, List<Facility>>((ref) {
  return FacilityNotifier();
});

class FacilityNotifier extends StateNotifier<List<Facility>> {
  FacilityNotifier() : super([]);

  void setFacilities(List<Facility> facilities) {
    state = facilities;
  }

  void addFacility(Facility facility) {
    state = [...state, facility];
  }

  void removeFacility(String id) {
    state = state.where((facility) => facility.id != id).toList();
  }
}