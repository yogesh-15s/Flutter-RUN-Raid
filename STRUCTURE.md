# Project Structure

This file describes the directory structure of the application and the purpose of each key file and directory.

## Directory Layout

```text
my_flutter_app/                      <-- Root Project Folder
├── lib/                             <-- ALL Frontend & Logic (Dart)
│   ├── main.dart                    <-- Application entry point
│   ├── core/                        <-- Shared core components
│   │   ├── theme/
│   │   │   └── app_theme.dart       <-- Dynamic Normal/Raid modes styling
│   │   └── network/                 <-- Core API clients
│   ├── features/                    <-- Feature modules
│   │   └── run_tracker/
│   │       ├── data/                
│   │       │   ├── location_service.dart <-- GPS Geolocator tracking logic
│   │       │   ├── background_tracker.dart <-- Foreground service settings
│   │       │   └── run_repository.dart  <-- Local caching repository via Hive
│   │       ├── domain/
│   │       │   └── run_point.dart   <-- Core GPS coordinate data model
│   │       └── presentation/
│   │           ├── run_screen.dart  <-- Spatial Stack tracking controller UI
│   │           ├── map_widget.dart  <-- Route polyline renderer widget
│   │           └── run_state_controller.dart <-- Real-time state state controller
│   ├── screens/                     <-- Legacy / Global UI screens (placeholder)
│   │   └── home_screen.dart
│   └── services/                    <-- Legacy / Global API callers (placeholder)
│       └── fitness_api_service.dart
├── android/                         <-- Auto-generated Android native wrapper
├── ios/                             <-- Auto-generated iOS native wrapper
└── pubspec.yaml                     <-- Dependencies and assets configuration
```

## Details of Directories & Files

- **Root Project Documentation**:
  - **[CHANGES.md](file:///C:/NEW%20RUN%20RAID/CHANGES.md)**: Sequential change logs.
  - **[STRUCTURE.md](file:///C:/NEW%20RUN%20RAID/STRUCTURE.md)**: Current file layout registry.
  - **[PROMPTS.md](file:///C:/NEW%20RUN%20RAID/PROMPTS.md)**: Next prompt task queues.
  - **[PROJECT_IDEA.md](file:///C:/NEW%20RUN%20RAID/PROJECT_IDEA.md)**: Project scope, goals, and dual design themes.
  - **[API_REQUIREMENTS.md](file:///C:/NEW%20RUN%20RAID/API_REQUIREMENTS.md)**: Backend REST endpoint request/response payloads specifications.
  - **[.gitignore](file:///C:/NEW%20RUN%20RAID/.gitignore)**: Root git configuration to ignore API keys, secrets, and IDE configs.
- **[lib/](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib)**: All Dart code.
  - **[lib/main.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/main.dart)**: Boots the app, sets up providers, and initializes services.
  - **[lib/core/theme/app_theme.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/core/theme/app_theme.dart)**: Contains color variables and design metrics for normal (emerald green) and raid (crimson/black) themes.
  - **[lib/features/run_tracker/domain/run_point.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/features/run_tracker/domain/run_point.dart)**: Defines Lat/Lng coordinates, altitude, speeds, and timestamps.
  - **[lib/features/run_tracker/data/location_service.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/features/run_tracker/data/location_service.dart)**: Fine-grained GPS filtering (distance filter 5m, accuracy < 15m) to avoid drift.
  - **[lib/features/run_tracker/data/background_tracker.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/features/run_tracker/data/background_tracker.dart)**: Orchestrates background execution via a persistent foreground notifications wrapper.
  - **[lib/features/run_tracker/data/run_repository.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/features/run_tracker/data/run_repository.dart)**: Saves and restores active runs from Hive.
  - **[lib/features/run_tracker/presentation/run_state_controller.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/features/run_tracker/presentation/run_state_controller.dart)**: Coordinates the GPS stream, UI notifications, activity category, and modes.
  - **[lib/features/run_tracker/presentation/run_screen.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/features/run_tracker/presentation/run_screen.dart)**: Real-time UI displaying distance, pace, time, mode switches, and action buttons.
  - **[lib/features/run_tracker/presentation/map_widget.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/features/run_tracker/presentation/map_widget.dart)**: Dynamic tiles map layer showing route paths.
- **[android/](file:///C:/NEW%20RUN%20RAID/my_flutter_app/android)**: Android-specific build setups, configurations, and permissions manifest.
- **[ios/](file:///C:/NEW%20RUN%20RAID/my_flutter_app/ios)**: iOS PLIST settings and orientation constraints.
- **[pubspec.yaml](file:///C:/NEW%20RUN%20RAID/my_flutter_app/pubspec.yaml)**: Project dependencies and media assets.

