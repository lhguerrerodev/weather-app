import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Singleton

  static LocationService? _intance;

  LocationService._();

  bool locationEabled = false;

  Position? currentPosition;

  factory LocationService() => _intance ??= LocationService._();

  Future<String> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    locationEabled = false;
    currentPosition = null;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services are disabled. Please enable the services';
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permissions are denied';
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return 'Location permissions are permanently denied, we cannot request permissions.';
    }

    locationEabled = true;

    return '';
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();
    if (hasPermission.isNotEmpty) {
      return;
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition = position;
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
