import 'dart:async';

import 'package:churcher/Coordinates.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'resources/Strings.dart';

class LatLngPickerPage extends StatefulWidget {
  @override
  State<LatLngPickerPage> createState() => LatLngPickerPageState();
}

class LatLngPickerPageState extends State<LatLngPickerPage> {
  Set<Marker> _markers = Set();
  Completer<GoogleMapController> _controller = Completer();
  bool buttonFlag = false;

  CameraPosition _cameraPosition = CameraPosition(
    target: Coordinates.moscow,
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    LatLng coords;
    return MaterialApp(
      title: 'Churcher',
      home: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _cameraPosition,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (LatLng point) {
                setState(() {
                  buttonFlag = true;
                  _markers.clear();
                  _markers.add(Marker(
                    markerId: MarkerId(point.toString()),
                    position: point,
                  ));
                });
              },
            ),
            buttonFlag
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context, _markers.first.position);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 200,
                          child: Text(Strings.confirm),
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            goToUser();
          },
          child: Icon(Icons.my_location),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    goToUser();
  }

  void goToUser() async {
    final GoogleMapController controller = await _controller.future;
    var pos = await getLocation();
    CameraPosition cameraPosition =
        CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 15);
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Future<LocationData> getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }
}
