import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'run_state_controller.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController _mapController = MapController();
  bool _hasCentredInitial = false;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RunStateController>();
    final mode = controller.activeMode;
    final points = controller.runPoints;

    // Convert RunPoint model coordinates to LatLng coordinates for flutter_map
    final routeCoordinates = points
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    // Map style provider (OpenStreetMap for normal, CartoDB Dark Matter for Raid mode)
    final String urlTemplate = mode == 'RAID'
        ? 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png'
        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

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
                borderColor: Colors.black.withOpacity(0.4),
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
                        color: AppTheme.getAccentColor(mode).withOpacity(0.5),
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
