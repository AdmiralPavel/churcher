import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(0, 0),
      ),
    );
  }
}
