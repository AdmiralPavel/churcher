import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'ChurchCreationPage.dart';
import 'ChurchProvider.dart';
import 'Coordinates.dart';
import 'resources/Strings.dart';

class MainMapPage extends StatefulWidget {
  @override
  State<MainMapPage> createState() => MainMapPageState();
}

class MainMapPageState extends State<MainMapPage> {
  Completer<GoogleMapController> _controller = Completer();
  ChurchProvider churchProvider;
  static final CameraPosition _cameraPosition = CameraPosition(
    target: Coordinates.moscow,
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    churchProvider = ChurchProvider(context);
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _cameraPosition,
        markers: churchProvider.markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton.extended(
          onPressed: () => _createNewChurch(context),
          label: Text(Strings.newChurch),
          icon: Icon(Icons.add),
        ),
      ),
    );
  }

  void _createNewChurch(BuildContext buildContext) async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChurchCreationPage()));
    if (result != null)
      Scaffold.of(buildContext).showSnackBar(SnackBar(
        content: Text("Добавленная вами церковь отправлена на модерацию"),
      ));
  }
}
