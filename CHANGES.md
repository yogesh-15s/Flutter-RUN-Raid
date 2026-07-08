# Project Changes Log

This file tracks all updates and modifications made to the project.

## Log of Changes

### Change-1: Initial setup
- Date: 2026-07-08
- Description: Created project documentation structure including:
  - [CHANGES.md](file:///C:/NEW%20RUN%20RAID/CHANGES.md)
  - [STRUCTURE.md](file:///C:/NEW%20RUN%20RAID/STRUCTURE.md)
  - [PROMPTS.md](file:///C:/NEW%20RUN%20RAID/PROMPTS.md)
  - [PROJECT_IDEA.md](file:///C:/NEW%20RUN%20RAID/PROJECT_IDEA.md)

### Change-2: Initialize Flutter App
- Date: 2026-07-08
- Description: Ran `flutter create` to initialize the project, cleaned up `lib/main.dart`, and created initial layout placeholders:
  - [home_screen.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/screens/home_screen.dart)
  - [fitness_api_service.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/services/fitness_api_service.dart)
  - [main.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/main.dart)

### Change-3: Implement Real-Time GPS Tracking Architecture
- Date: 2026-07-08
- Description: Implemented the location tracking module, local caching, background execution, dual visual theme toggling, and real-time map drawing:
  - Added package dependencies: `geolocator`, `permission_handler`, `flutter_background_service`, `hive_flutter`, `flutter_map`, `latlong2`, `provider`, `uuid`.
  - Created domain model: [run_point.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/features/run_tracker/domain/run_point.dart)
  - Created database repository: [run_repository.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/features/run_tracker/data/run_repository.dart)
  - Created GPS stream handler: [location_service.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/features/run_tracker/data/location_service.dart)
  - Created foreground listener: [background_tracker.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/features/run_tracker/data/background_tracker.dart)
  - Created state management controller: [run_state_controller.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/features/run_tracker/presentation/run_state_controller.dart)
  - Created style/colors layer: [app_theme.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/core/theme/app_theme.dart)
  - Created polyline map component: [map_widget.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/features/run_tracker/presentation/map_widget.dart)
  - Created main tracking view: [run_screen.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/features/run_tracker/presentation/run_screen.dart)
  - Registered service and controller in [main.dart](file:///C:/NEW%20RUN%20RAID/my_flutter_app/lib/main.dart)
  - Configured permissions in [AndroidManifest.xml](file:///C:/NEW%20RUN%20RAID/my_flutter_app/android/app/src/main/AndroidManifest.xml) and [Info.plist](file:///C:/NEW%20RUN%20RAID/my_flutter_app/ios/Runner/Info.plist).

### Change-4: Created API Requirements Log
- Date: 2026-07-08
- Description: Created [API_REQUIREMENTS.md](file:///C:/NEW%20RUN%20RAID/API_REQUIREMENTS.md) mapping all future authentication, synchronization, anti-cheat, territory claim, and leaderboard REST API specifications.
### Change-5: Created Root Gitignore
- Date: 2026-07-08
- Description: Created root [.gitignore](file:///C:/NEW%20RUN%20RAID/.gitignore) to protect local environment configurations, secrets, and IDE settings.

### Change-6: Resolved Deprecated Color APIs
- Date: 2026-07-08
### Change-7: Excluded Dart Tool from C/C++ Indexer
- Date: 2026-07-08
- Description: Created workspace settings [.vscode/settings.json](file:///C:/NEW%20RUN%20RAID/.vscode/settings.json) to exclude `.dart_tool/` files from being parsed as C++ syntax by VS Code IntelliSense.
