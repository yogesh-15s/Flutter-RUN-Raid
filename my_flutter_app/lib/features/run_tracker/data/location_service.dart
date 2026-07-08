import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Check and request location permissions
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Expose GPS coordinates stream with drift filter
  Stream<Position> getLocationStream() {
    // Configure location settings: high accuracy and 5-meter update interval
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Triggers every 5 meters
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings)
        .where((Position position) {
      // GPS Drift Prevention: filter out updates with accuracy worse than 15 meters
      return position.accuracy <= 15.0;
    });
  }

  // Get current single position
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}
