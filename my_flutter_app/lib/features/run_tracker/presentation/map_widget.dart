import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'run_state_controller.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/features/run_tracker/data/location_service.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController _mapController = MapController();
  bool _hasCentredInitial = false;
  int _lastProcessedRecenterTrigger = 0;

  Future<void> _recenterToCurrentLocation(RunStateController controller) async {
    try {
      final position = await LocationService().getCurrentPosition();
      final target = LatLng(position.latitude, position.longitude);
      _mapController.move(target, 17.0);
    } catch (e) {
      if (controller.runPoints.isNotEmpty) {
        final lastPoint = controller.runPoints.last;
        _mapController.move(LatLng(lastPoint.latitude, lastPoint.longitude), 17.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RunStateController>();
    final mode = controller.activeMode;
    final points = controller.runPoints;

    // Check if map recentering was triggered
    if (controller.recenterTrigger > _lastProcessedRecenterTrigger) {
      _lastProcessedRecenterTrigger = controller.recenterTrigger;
      _recenterToCurrentLocation(controller);
    }

    // Convert RunPoint model coordinates to LatLng coordinates for flutter_map
    final routeCoordinates = points
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    // Map style provider: CartoDB Voyager (Streets), Esri World Imagery (Satellite), CartoDB Dark Matter (Dark)
    final String urlTemplate;
    if (controller.mapStyle == 'SATELLITE') {
      urlTemplate = 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
    } else if (controller.mapStyle == 'DARK') {
      urlTemplate = 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png';
    } else {
      // CartoDB Voyager is a highly readable, clear, modern street style
      urlTemplate = 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png';
    }

    // Auto-center map on new coordinates
    if (routeCoordinates.isNotEmpty) {
      final latestPoint = routeCoordinates.last;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_hasCentredInitial || controller.isTracking) {
          _mapController.move(latestPoint, 17.0);
          _hasCentredInitial = true;
        }
      });
    }

    // Default coordinate if tracking hasn't started or there are no points
    final LatLng initialCenter = routeCoordinates.isNotEmpty
        ? routeCoordinates.last
        : const LatLng(37.7749, -122.4194); // Default to SF or another default coordinate

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: 16.0,
      ),
      children: [
        TileLayer(
          urlTemplate: urlTemplate,
          userAgentPackageName: 'com.fitness.my_flutter_app',
        ),
        if (routeCoordinates.isNotEmpty) ...[
          // Draw live polyline representing the tracking path
          PolylineLayer(
            polylines: [
              Polyline(
                points: routeCoordinates,
                strokeWidth: 5.0,
                color: AppTheme.getAccentColor(mode),
                borderColor: Colors.black.withValues(alpha: 0.4),
                borderStrokeWidth: 1.0,
              ),
            ],
          ),
          // User current position marker
          MarkerLayer(
            markers: [
              Marker(
                point: routeCoordinates.last,
                width: 30,
                height: 30,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.getAccentColor(mode),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.getAccentColor(mode).withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 3,
                      )
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.navigation,
                      color: mode == 'RAID' ? Colors.black : Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
