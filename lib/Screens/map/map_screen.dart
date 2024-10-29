// lib/screens/map/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'component/search_bar.dart';
import 'component/filter_button.dart';
import 'component/location_list_sheet.dart';
import '../../provider/map/location_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late NaverMapController _mapController;

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);

    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(
                  locationState.currentLocation.latitude,
                  locationState.currentLocation.longitude,
                ),
                zoom: 15,
              ),
            ),
            onMapReady: (NaverMapController controller) {
              _mapController = controller;
            },
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
              ],
            ),
          ),
          LocationListSheet(),
        ],
      ),
    );
  }
}