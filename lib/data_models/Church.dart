import 'package:google_maps_flutter/google_maps_flutter.dart';

class Church {
  LatLng coords;
  String name;
  String imageSource;
  CameraPosition cameraPosition;
  String description;
  bool confirmed;

  Church(
      {this.coords,
      this.name,
      this.imageSource,
      this.description,
      this.confirmed}) {
    cameraPosition = CameraPosition(target: coords, zoom: 18);
  }
}
