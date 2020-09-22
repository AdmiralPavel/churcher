import 'package:google_maps_flutter/google_maps_flutter.dart';

class Church {
  String id;
  LatLng coords;
  String name;
  String imageSource;
  CameraPosition cameraPosition;
  String description;

  Church({
    this.id,
    this.coords,
    this.name,
    this.imageSource,
    this.description,
  }) {
    cameraPosition = CameraPosition(target: coords, zoom: 18);
  }
}
