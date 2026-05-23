import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:workmanager/workmanager.dart';

import '../../feature/auth/domain/repository/location_repository.dart';
import '../di/injectProvider.dart';

class BackgroundService {
  static const String locationTask = "locationTrackingTask";
  static const String androidChannelId = "location_tracking_channel";
  static const String androidChannelName = "Location Tracking";

  bool _isRunning = false;
  final _locationController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get locationStream => _locationController.stream;

  // Initialize background service
  Future<void> initialize() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: androidChannelId,
        initialNotificationTitle: "Location Tracking",
        initialNotificationContent: "Tracking your location",
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    // Initialize WorkManager for periodic sync
    await Workmanager().initialize(callbackDispatcher);
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    final repository = sl<LocationRepository>();

    // Start location tracking in background
    final subscription = repository.getLocationStream().listen((location) {
      // Save to local database
      repository.saveLocationToLocal(location);

      // Send to server if online
      repository.updateServerLocation(location);

      // Send to UI
      service.invoke('update', {
        'latitude': location.latitude,
        'longitude': location.longitude,
        'timestamp': location.timestamp.toIso8601String(),
      });

      // Update notification
      service.invoke('setNotification', {
        'title': 'Location Tracking',
        'content': 'Lat: ${location.latitude}, Lng: ${location.longitude}',
      });
    });

    service.on('stop').listen((event) {
      subscription.cancel();
      service.stopSelf();
    });
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    final repository = sl<LocationRepository>();
    final location = await repository.getCurrentLocation();
    await repository.saveLocationToLocal(location);

    return true;
  }

  @pragma('vm:entry-point')
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      final repository = sl<LocationRepository>();

      switch (task) {
        case locationTask:
          final location = await repository.getCurrentLocation();
          await repository.syncOfflineLocations();
          break;
      }

      return Future.value(true);
    });
  }

  // Start background tracking
  Future<void> startTracking() async {
    if (_isRunning) return;

    final service = FlutterBackgroundService();
    await service.startService();

    // Register periodic sync
    await Workmanager().registerPeriodicTask(
      locationTask,
      locationTask,
      frequency: Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );

    _isRunning = true;
  }

  // Stop background tracking
  Future<void> stopTracking() async {
    final service = FlutterBackgroundService();
    service.invoke('stop');

    await Workmanager().cancelByTag(locationTask);
    _isRunning = false;
  }

  // Check if tracking is running
  bool get isRunning => _isRunning;

  void dispose() {
    _locationController.close();
  }
}