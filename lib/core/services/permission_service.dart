import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Check if location permission is granted
  Future<bool> hasLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  // Request location permission
  Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();

    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return true;
      case LocationPermission.denied:
        return false;
      case LocationPermission.deniedForever:
        return false;
      case LocationPermission.unableToDetermine:
        return false;
    }
  }

  // Check background permission (Android)
  Future<bool> hasBackgroundPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.locationAlways.status;
      return status.isGranted;
    }
    return true; // iOS handled separately
  }

  // Request background permission
  Future<bool> requestBackgroundPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.locationAlways.request();
      return status.isGranted;
    }
    return true;
  }

  // Open app settings
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  // Get permission status stream
  Stream<LocationPermission> get permissionStream {
    return Geolocator.getServiceStatusStream().asyncMap((_) async {
      return await Geolocator.checkPermission();
    });
  }
}