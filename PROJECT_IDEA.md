# Project Idea, Theme & Future Tech Stack

This file will contain the details of the fitness application, including its core value proposition, targeted features, design system/theme, and the integrations we plan to use.

## Core Idea
1. Core VisionA gamified, location-based fitness platform that combines traditional workout tracking with a real-time competitive Territory Control Game. Users track everyday runs while competing to capture real-world geographic grids and climb regional leaderboards.
2. Core Game ModesMode A: Standard Mode (24/7)Availability: Accessible 24 hours a day, 7 days a week.Purpose: Classic fitness logging for individual workouts.Key Metrics Captured:Total Distance and PaceElapsed Time and Moving TimeCalorie Burn EstimateGPS Route PathTarget User: Casual runners wanting simple performance tracking without competitive pressure.Mode B: Raid Mode (Time-Windowed Territory Control)Availability: Daily scheduled time windows:Morning Window: 4:00 AM to 8:00 AMEvening Window: 7:00 PM to 11:00 PMCore Mechanics:Path Buffer Capture (Point A to Point B): Straight-line or open-path runs expand out by a dynamic width buffer (for example, 10 to 20 meters on each side of the route) to paint or capture a thick territory corridor.Enclosed Loop Capture (Point A to B to C back to A): If a runner completes a closed loop or perimeter, the system uses a polygon-filling algorithm to claim the entire area enclosed inside the loop.
3. Competitive and Scoring Mechanics+------------------------+
| Runner Completes Loop  |
+------------------------+
           |
           v
+------------------------+
| Area Polygon Computed  |
+------------------------+
           |
           v
+------------------------+
| Lock Timer Activated   |
+------------------------+
           |
     +-----+-----+
     |           |
     v           v
+----------+  +------------------+
| First    |  | Subsequent       |
| Claim:   |  | Claims:          |
| 100% Pts |  | Reduced Points   |
+----------+  +------------------+

First-Mover Advantage:The first player to capture a previously unclaimed grid or zone earns maximum leaderboard points, and it will be shown on map other who will capture will see them selfs but he king will the on who captures it first.Subsequent players who claim or overlap the same zone receive reduced/decayed points.Territory Lock System (Cooldown):Once a territory is captured, a lock timer is activated (for example, locked untill raid mode time starts for next session).During the lock period, rival runners cannot steal or overwrite that specific area, protecting early runners from losing their progress immediately.
4. Anti-Cheat and Integrity SystemTo maintain fair competition on public leaderboards, an automated verification engine monitors run telemetry:Activity-Specific Speed Caps:Walking: Maximum speed cutoff around 7 to 8 km/h.Running: Maximum speed cutoff around 25 km/h (flags unnatural acceleration spikes).Cycling: Maximum speed cutoff around 45 to 50 km/h.Telemetric Checks:Cadence and Step Rate Validation: Cross-references GPS speed with hardware accelerometer data to flag motor vehicle usage (such as cars or e-scooters).Teleportation / GPS Mocking Filter: Ignores sudden erratic location leaps.
5. Key Technical Modules RequiredModuleCore ResponsibilityGPS Tracker EngineStreams position data using a distance filter (5 meters) and accuracy threshold (less than 15 meters).Polygon / Buffer ProcessorCalculates corridor buffers and solves point-in-polygon math for loop closures.Local-First Sync EngineCaches GPS points locally (Isar or Hive) and syncs via batched APIs to save battery and data.Grid Ownership ServerManages zone claims, lock timers, and decayed point allocation on the backend database.

## Design Theme
Dual Dynamic Color Themes
To make Raid Mode feel intensely competitive compared to Normal Mode, your theme variables will dynamically toggle when long-pressing the start button:


               NORMAL MODE (24/7)                |                RAID MODE (Time Window)
-------------------------------------------------+-------------------------------------------------
Primary Accent : Emerald Green (#00E676)         | Primary Accent : Flame Red (#FF1744) / Crimson
Background     : Pure White / Light Slate        | Background     : Pitch Black (#0A0A0A) / Dark Charcoal
Map Tile Theme : Light / Standard Vector Map     | Map Tile Theme : Dark / Midnight / High Contrast
Bottom Bar     : Clean Light Grey + Green Accent | Bottom Bar     : Deep Obsidian + Red Glow
Top Stat Card  : Frosted Glass (Light)           | Top Stat Card  : Dark Carbon Fiber Style

* Activity:
📱 Main Activity Screen UI Layout
Here is the spatial architecture for your main screen. The layout uses a Stack so the map fills the background while all UI elements overlay smoothly.


+-------------------------------------------------------------+
|                     TOP STATS BOARD                         |
|   +-----------------------------------------------------+   |
|   |  DISTANCE     TIME        CALORIES     SPEED        |   |
|   |  4.25 km    22:15 min     310 kcal    11.4 km/h     |   |
|   +-----------------------------------------------------+   |
|                                                             |
|                   [ MAP DISPLAY AREA ]                      |
|                                                             |
|  * Mode Indicator Tag (e.g., "RAID MODE ACTIVE")            |
|                                                             |
|                                       ( Location Refresh )  |
|                                       (      [ O ]       )  |
|                                                             |
|                           [ Category Selector Bar ]         |
|                           [ Run | Cycle | Walk | More ]     |
|                                                             |
|      ( Music )             [ START RUN ]          ( Quick ) |
|      (  [♪]  )             [  BUTTON   ]          ( Settings)
|                                                             |
+-------------------------------------------------------------+
|                PERSISTENT BOTTOM NAVIGATION                 |
|            [ Activity ]    [ Leaderboard ]    [ Profile ]   |
+-------------------------------------------------------------+

just work on activity , the leaderboard and profile details will be given later 

* leaderboard: 

* Profile:

## Planned Technologies & Integrations
- **Frontend Framework**: Flutter (v3.44.0, stable channel)
- **Programming Language**: Dart (v3.12.0)
- **State Management**: Provider (configured)
- **GPS Location Engine**: Geolocator (configured)
- **Offline Caching**: Hive (configured)
- **Background Execution**: Flutter Background Service (configured)
- **Maps API**: Flutter Map & OpenStreetMap / CartoDB tiles (configured)
- **Backend Services**: To be decided (e.g., Firebase / REST API)


---

## Simultaneous Readme Updates Policy
> [!IMPORTANT]
> To maintain complete transparency, as changes are made to the codebase, the following files must be updated simultaneously:
> 1. [CHANGES.md](file:///C:/NEW%20RUN%20RAID/CHANGES.md) (logging modifications sequentially as `Change-1`, `Change-2`, etc.)
> 2. [STRUCTURE.md](file:///C:/NEW%20RUN%20RAID/STRUCTURE.md) (updating file structures and file/directory definitions if they change)
> 3. [PROJECT_IDEA.md](file:///C:/NEW%20RUN%20RAID/PROJECT_IDEA.md) (documenting new features, themes, or technology choices)
> 4. [API_REQUIREMENTS.md](file:///C:/NEW%20RUN%20RAID/API_REQUIREMENTS.md) (documenting backend endpoint request/response payloads as features progress)

