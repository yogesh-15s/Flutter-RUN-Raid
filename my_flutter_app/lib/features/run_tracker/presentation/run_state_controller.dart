import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import '../domain/run_point.dart';
import '../data/run_repository.dart';
import '../data/location_service.dart';

class RunStateController extends ChangeNotifier {
  final RunRepository _runRepository = RunRepository();
  final LocationService _locationService = LocationService();
  
  bool _isTracking = false;
  String _activeMode = 'NORMAL'; // 'NORMAL' or 'RAID'
  String _selectedCategory = 'Run'; // 'Run', 'Cycle', 'Walk', 'More'
  List<RunPoint> _runPoints = [];
  double _totalDistanceMeters = 0.0;
  int _durationSeconds = 0;
  double _currentSpeed = 0.0;
  Timer? _runTimer;
  int _recenterTrigger = 0;
  String _mapStyle = 'STREETS'; // 'STREETS', 'SATELLITE', 'DARK'

  // Getters
  String get mapStyle => _mapStyle;
  int get recenterTrigger => _recenterTrigger;
  bool get isTracking => _isTracking;
  String get activeMode => _activeMode;
  String get selectedCategory => _selectedCategory;
  List<RunPoint> get runPoints => _runPoints;
  double get totalDistanceMeters => _totalDistanceMeters;
  int get durationSeconds => _durationSeconds;
  double get currentSpeed => _currentSpeed;

  RunStateController() {
    _init();
  }

  Future<void> _init() async {
    await _runRepository.init();
    // Recover previous active run if exists
    _runPoints = _runRepository.getActiveRunPoints();
    _recalculateDistance();
    
    // Listen for real-time location updates from the background service
    FlutterBackgroundService().on('onLocationUpdate').listen((event) {
      if (event != null && _isTracking) {
        final point = RunPoint.fromMap(event);
        _addPoint(point);
      }
    });
  }

  // Trigger map recentering
  void triggerRecenter() {
    _recenterTrigger++;
    notifyListeners();
  }

  // Set active sport category
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Toggle Mode (NORMAL <-> RAID)
  void toggleMode() {
    if (_isTracking) return; // Prevent switching mid-run
    _activeMode = _activeMode == 'NORMAL' ? 'RAID' : 'NORMAL';
    _mapStyle = _activeMode == 'RAID' ? 'DARK' : 'STREETS';
    notifyListeners();
  }

  // Toggle Map style (STREETS -> SATELLITE -> DARK)
  void toggleMapStyle() {
    if (_mapStyle == 'STREETS') {
      _mapStyle = 'SATELLITE';
    } else if (_mapStyle == 'SATELLITE') {
      _mapStyle = 'DARK';
    } else {
      _mapStyle = 'STREETS';
    }
    notifyListeners();
  }

  // Recalculate total distance based on current points
  void _recalculateDistance() {
    _totalDistanceMeters = 0.0;
    for (int i = 0; i < _runPoints.length - 1; i++) {
      _totalDistanceMeters += Geolocator.distanceBetween(
        _runPoints[i].latitude,
        _runPoints[i].longitude,
        _runPoints[i + 1].latitude,
        _runPoints[i + 1].longitude,
      );
    }
  }

  // Add a coordinate point and notify UI
  void _addPoint(RunPoint point) {
    if (_runPoints.isNotEmpty) {
      final lastPoint = _runPoints.last;
      _totalDistanceMeters += Geolocator.distanceBetween(
        lastPoint.latitude,
        lastPoint.longitude,
        point.latitude,
        point.longitude,
      );
    }
    _runPoints.add(point);
    _currentSpeed = point.speed;
    notifyListeners();
  }

  // Start run tracking
  Future<void> startRun() async {
    final hasPermission = await _locationService.handleLocationPermission();
    if (!hasPermission) return;

    _isTracking = true;
    _durationSeconds = 0;
    _totalDistanceMeters = 0.0;
    _runPoints.clear();
    await _runRepository.clearActiveRun();
    notifyListeners();

    // Start background service
    final service = FlutterBackgroundService();
    final isRunning = await service.isRunning();
    if (!isRunning) {
      await service.startService();
    }
    
    // Notify service to initiate location streams
    service.invoke('startTracking', {'mode': _activeMode});

    // Start live timer for duration calculation
    _runTimer?.cancel();
    _runTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _durationSeconds++;
      notifyListeners();
    });
  }

  // Pause tracking
  Future<void> pauseRun() async {
    _isTracking = false;
    _runTimer?.cancel();
    FlutterBackgroundService().invoke('stopTracking');
    notifyListeners();
  }

  // Resume tracking
  Future<void> resumeRun() async {
    _isTracking = true;
    FlutterBackgroundService().invoke('startTracking', {'mode': _activeMode});
    _runTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _durationSeconds++;
      notifyListeners();
    });
    notifyListeners();
  }

  // Complete and save run history
  Future<void> finishRun() async {
    _isTracking = false;
    _runTimer?.cancel();
    _runTimer = null;

    final service = FlutterBackgroundService();
    service.invoke('stopTracking');
    service.invoke('stopService');

    if (_runPoints.isNotEmpty) {
      final runId = const Uuid().v4();
      await _runRepository.saveRunToHistory(
        id: runId,
        points: _runPoints,
        totalDistanceMeters: _totalDistanceMeters,
        durationSeconds: _durationSeconds,
        date: DateTime.now(),
        mode: _activeMode,
      );
    }

    await _runRepository.clearActiveRun();
    _runPoints.clear();
    _durationSeconds = 0;
    _totalDistanceMeters = 0.0;
    _currentSpeed = 0.0;
    notifyListeners();
  }
}
