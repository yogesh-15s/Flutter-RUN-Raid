# API Requirements & Endpoint Specifications

This file documents all backend API endpoints, schemas, and payload specifications required by the app as we build out features.

## 1. Authentication & Profile Services
*Used to manage user registration, tokens, and general athlete metadata.*

### POST `/api/auth/register`
*   **Description**: Registers a new runner.
*   **Request Payload**:
    ```json
    {
      "username": "RunnerKing",
      "email": "runner@fitness.com",
      "password": "hashed_password"
    }
    ```
*   **Response**: `201 Created` with session token.

### POST `/api/auth/login`
*   **Description**: Authenticates user credentials.
*   **Request Payload**:
    ```json
    {
      "email": "runner@fitness.com",
      "password": "hashed_password"
    }
    ```
*   **Response**: `200 OK` with JWT token.

### GET `/api/profile`
*   **Headers**: `Authorization: Bearer <token>`
*   **Description**: Retrieves runner stats, levels, and active territory metrics.

---

## 2. Run Synchronizations & Anti-Cheat Validation
*Used to sync local Hive caches after activity completion and run telemetric verification.*

### POST `/api/runs/sync`
*   **Headers**: `Authorization: Bearer <token>`
*   **Description**: Uploads a completed run log from local Hive storage.
*   **Request Payload**:
    ```json
    {
      "runId": "uuid-v4-string",
      "mode": "RAID", // "NORMAL" or "RAID"
      "sport": "Run", // "Run", "Cycle", "Walk"
      "durationSeconds": 1335,
      "distanceMeters": 4250.0,
      "date": "2026-07-08T12:00:00Z",
      "points": [
        {
          "latitude": 37.7749,
          "longitude": -122.4194,
          "timestamp": "2026-07-08T12:00:00Z",
          "speed": 3.2,
          "altitude": 15.4
        }
      ],
      "deviceTelemetry": {
        "averageCadence": 165.0,
        "isMockLocation": false
      }
    }
    ```
*   **Response**:
    ```json
    {
      "status": "VERIFIED", // "VERIFIED" or "FLAGGED_FOR_REVIEW"
      "pointsEarned": 120,
      "validationReport": {
        "speedChecksPassed": true,
        "teleportationChecksPassed": true
      }
    }
    ```

---

## 3. Territory Control & Raid Mode (Grid Engine)
*Used to request grid status overlays and submit claims for capturing real-world grids.*

### GET `/api/territory/grids`
*   **Description**: Returns active territorial grids inside a viewport boundary to draw on the map.
*   **Query Params**: `minLat`, `minLng`, `maxLat`, `maxLng`
*   **Response**:
    ```json
    {
      "grids": [
        {
          "gridId": "grid-tile-xyz",
          "status": "LOCKED", // "CLAIMED", "LOCKED", "UNCLAIMED"
          "ownerName": "RunnerKing",
          "ownerTeam": "Crimson_Alliance",
          "lockExpiresAt": "2026-07-08T23:00:00Z",
          "pointsMultiplier": 1.0
        }
      ]
    }
    ```

### POST `/api/territory/claim`
*   **Headers**: `Authorization: Bearer <token>`
*   **Description**: Submits territory loop boundaries or path corridors to claim grids.
*   **Request Payload**:
    ```json
    {
      "runId": "uuid-v4-string",
      "boundaryCoordinates": [
        { "latitude": 37.7749, "longitude": -122.4194 }
      ]
    }
    ```
*   **Response**:
    ```json
    {
      "claimSuccess": true,
      "capturedGrids": ["grid-tile-xyz"],
      "pointsAwarded": 250,
      "lockExpiresAt": "2026-07-08T23:00:00Z"
    }
    ```

---

## 4. Competitive Leaderboard
*Used to render regional and overall rankings.*

### GET `/api/leaderboards`
*   **Query Params**: `region=regional`, `metric=grids_captured`
*   **Response**:
    ```json
    {
      "rankings": [
        { "rank": 1, "username": "RunnerKing", "gridsCount": 42, "score": 8950 }
      ]
    }
    ```
