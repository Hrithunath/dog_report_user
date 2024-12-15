import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapPage extends StatefulWidget {
  final GeoPoint initialPosition;

  const MapPage({
    Key? key,
    required this.initialPosition,
  }) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController controller;

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initPosition: widget.initialPosition,
      areaLimit:
          const BoundingBox(east: 97.4026, north: 37.6, south: 6.7, west: 68.7),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: OSMFlutter(
        controller: controller,
        osmOption: const OSMOption(
          userTrackingOption: UserTrackingOption(
            enableTracking: true,
            unFollowUser: false,
          ),
          zoomOption: ZoomOption(
            initZoom: 15,
            minZoomLevel: 3,
            maxZoomLevel: 19,
            stepZoom: 1.0,
          ),
        ),
      ),
    );
  }
}
