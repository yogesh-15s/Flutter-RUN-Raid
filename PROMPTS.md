# Project Prompts

Use this file to queue and write down detailed instructions or prompts for building the app. I will read this file directly to execute tasks and build out the features.

## Prompt Queue

*Write your next prompt or instruction here, and tell me to proceed with it.*


* [x] Prompt 1 (Completed):

# ROLE & GOAL
You are a Senior Mobile Software Engineer specializing in Flutter and real-time mobile app development. Your task is to implement/refactor the core real-time tracking architecture for a mobile running/fitness application.

---

# CURRENT PROJECT STATUS (Update this before running)
- State Management: [e.g., Riverpod / Bloc / Provider / None yet]
- Local Storage: [e.g., Isar / Hive / Sqflite / None yet]
- Map Integration: [e.g., flutter_map / google_maps_flutter / None yet]
- Already Configured Files: [e.g., AndroidManifest.xml updated, pubspec.yaml updated, or Starting from scratch]
- Existing Folder Structure: [Standard lib/ directory / Feature-first structure / Clean architecture]

---

# ARCHITECTURE & TECHNICAL REQUIREMENTS

### 1. Project & Directory Structure
Organize or update the code inside the `lib/` directory using a clean, feature-first structure:
lib/
├── core/
│   ├── network/             # API clients
│   └── theme/               # Colors & app styling
└── features/
    └── run_tracker/
        ├── data/            # location_service.dart & run_repository.dart
        ├── domain/          # run_point.dart model (lat, lng, timestamp, speed, altitude)
        └── presentation/    # UI screens, map widgets, and state controllers

### 2. Fine-Grained GPS Location Service (`location_service.dart`)
- Use `geolocator` (and `permission_handler` if needed).
- **Distance Filter:** Set `distanceFilter: 5` (meters) to reduce hardware wake-ups and prevent battery drain.
- **GPS Drift Prevention:** Filter out location updates where accuracy is worse than 15 meters.
- Expose coordinates as a clean Dart `Stream<Position>`.

### 3. Background Execution & Permissions
Ensure location tracking continues seamlessly when the screen is locked or the app is minimized:
- Use `flutter_background_service` to run a continuous foreground service on Android with a persistent notification ("Tracking your run...").
- Include all necessary permissions in:
  - `android/app/src/main/AndroidManifest.xml` (`ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`, `ACCESS_BACKGROUND_LOCATION`, `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_LOCATION`).
  - `ios/Runner/Info.plist` (`NSLocationWhenInUseUsageDescription`, `NSLocationAlwaysAndWhenInUseUsageDescription`, `UIBackgroundModes` -> `location`).

### 4. High-Performance Local Storage (`run_repository.dart`)
- Store live GPS coordinate updates instantly in local storage (e.g., Isar or Hive) instead of making high-frequency HTTP requests to avoid network battery consumption and offline data loss.

### 5. Interactive UI & Live Route Drawing (`run_screen.dart` & `map_widget.dart`)
- Connect the location stream to state management to render a real-time path polyline on the map along with live run metrics (duration, distance covered, current speed).

---

# INSTRUCTIONS FOR OUTPUT
1. Check my **CURRENT PROJECT STATUS** above and adapt to my current setup without breaking existing configurations.
2. Provide clean, modular, production-ready Dart code with full type safety.
3. Show the exact additions needed for `pubspec.yaml`, `AndroidManifest.xml`, and `Info.plist`.
4. Explain any code changes clearly before providing code blocks.




