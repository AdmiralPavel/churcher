import 'package:churcher/ChurchPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'data_models/Church.dart';

class ChurchProvider {
  final List<Church> churches = [
    Church(
        coords: LatLng(55.9205493, 37.9992362),
        name: 'Троицкий собор',
        description: 'Троицкий собор города Щёлково',
        imageSource:
            'https://blagochinie.info/images/phocagallery/hramy/troiskijsobor2/5.jpg')
  ];
  final Set<Marker> markers = Set();

  ChurchProvider(BuildContext context) {
    for (Church church in churches) {
      markers.add(
        Marker(
            position: church.coords,
            markerId: MarkerId(church.name),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChurchPage(church)));
            }),
      );
    }
  }
}
