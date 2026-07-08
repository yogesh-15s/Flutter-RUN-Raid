class RunPoint {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double speed;
  final double altitude;

  const RunPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.speed,
    required this.altitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'speed': speed,
      'altitude': altitude,
    };
  }

  factory RunPoint.fromMap(Map<dynamic, dynamic> map) {
    return RunPoint(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      timestamp: DateTime.parse(map['timestamp'] as String),
      speed: (map['speed'] as num).toDouble(),
      altitude: (map['altitude'] as num).toDouble(),
    );
  }
}
