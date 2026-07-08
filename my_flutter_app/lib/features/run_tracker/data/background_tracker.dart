import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import '../domain/run_point.dart';
import 'run_repository.dart';
import 'location_service.dart';

class BackgroundTracker {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    // Create the Notification Channel for Android
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false, // Start on-demand when a workout starts
        isForegroundMode: true,
        notificationChannelId: 'fitness_tracker_channel',
        initialNotificationTitle: 'Fitness Tracker',
        initialNotificationContent: 'GPS tracking is active in the background',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    // Listen to stop background service completely
    service.on('stopService').listen((event) async {
      await service.stopSelf();
    });

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    final locationService = LocationService();
    final runRepository = RunRepository();
    await runRepository.init();

    StreamSubscription<Position>? positionSubscription;

    // Listen for start tracking trigger
    service.on('startTracking').listen((event) async {
      final mode = event?['mode'] ?? 'NORMAL';

      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: mode == 'RAID' ? "⚔️ Territory Raid Active" : "🏃 Normal Run Active",
          content: "Tracking your running path in real-time...",
        );
      }

      // Clear previous cached points
      await runRepository.clearActiveRun();

      positionSubscription?.cancel();
      positionSubscription = locationService.getLocationStream().listen((position) async {
        final point = RunPoint(
          latitude: position.latitude,
          longitude: position.longitude,
          timestamp: position.timestamp,
          speed: position.speed,
          altitude: position.altitude,
        );

        // Store live coordinate locally in Hive box instantly (prevents loss)
        await runRepository.appendActiveRunPoint(point);

        // Share the update with the UI isolate in real-time
        service.invoke('onLocationUpdate', {
          'latitude': point.latitude,
          'longitude': point.longitude,
          'timestamp': point.timestamp.toIso8601String(),
          'speed': point.speed,
          'altitude': point.altitude,
        });
      });
    });

    // Listen for stop tracking trigger (pause/complete)
    service.on('stopTracking').listen((event) async {
      positionSubscription?.cancel();
      positionSubscription = null;
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "Tracking Paused",
          content: "Your run progress is saved locally.",
        );
      }
    });
  }
}
