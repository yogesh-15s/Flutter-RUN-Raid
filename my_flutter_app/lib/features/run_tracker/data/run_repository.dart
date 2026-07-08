import 'package:hive_flutter/hive_flutter.dart';
import '../domain/run_point.dart';

class RunRepository {
  static const String activeRunBoxName = 'active_run_points';
  static const String historicalRunsBoxName = 'completed_runs';

  // Initialize Hive storage
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(activeRunBoxName);
    await Hive.openBox(historicalRunsBoxName);
  }

  // Get active run points (cached local coordinate log for recovery)
  List<RunPoint> getActiveRunPoints() {
    final box = Hive.box(activeRunBoxName);
    final rawPoints = box.get('points', defaultValue: []);
    return (rawPoints as List).map((p) => RunPoint.fromMap(p as Map)).toList();
  }

  // Save active run points list
  Future<void> saveActiveRunPoints(List<RunPoint> points) async {
    final box = Hive.box(activeRunBoxName);
    final serialized = points.map((p) => p.toMap()).toList();
    await box.put('points', serialized);
  }

  // Add a single point to the active run (real-time append)
  Future<void> appendActiveRunPoint(RunPoint point) async {
    final points = getActiveRunPoints();
    points.add(point);
    await saveActiveRunPoints(points);
  }

  // Clear active run (e.g., when starting a new run or discarding)
  Future<void> clearActiveRun() async {
    final box = Hive.box(activeRunBoxName);
    await box.delete('points');
  }

  // Save the run to history
  Future<void> saveRunToHistory({
    required String id,
    required List<RunPoint> points,
    required double totalDistanceMeters,
    required int durationSeconds,
    required DateTime date,
    required String mode, // 'NORMAL' or 'RAID'
  }) async {
    final box = Hive.box(historicalRunsBoxName);
    final runData = {
      'id': id,
      'points': points.map((p) => p.toMap()).toList(),
      'totalDistanceMeters': totalDistanceMeters,
      'durationSeconds': durationSeconds,
      'date': date.toIso8601String(),
      'mode': mode,
    };
    await box.put(id, runData);
  }

  // Fetch all past runs
  List<Map<String, dynamic>> getHistoricalRuns() {
    final box = Hive.box(historicalRunsBoxName);
    return box.values.map((v) => Map<String, dynamic>.from(v as Map)).toList();
  }
}
