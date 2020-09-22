import 'package:churcher/custom_views/ChurchElement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'custom_views/ChurchElement.dart';
import 'data_models/Church.dart';

class SuggestedChurchesPage extends StatefulWidget {
  @override
  _SuggestedChurchesPageState createState() => _SuggestedChurchesPageState();
}

class _SuggestedChurchesPageState extends State<SuggestedChurchesPage> {
  List<Church> churches = List();
  Color color;

  bool loaded = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список предложенных'),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: updateChurches,
        header: WaterDropHeader(),
        child: ListView.builder(
          itemCount: churches.length,
          itemBuilder: (BuildContext context, int index) {
            Church church = churches[index];
            return !loaded
                ? CircularProgressIndicator()
                : Dismissible(
                    key: Key(church.id),
                    child: ChurchElement(church),
                    onDismissed: (direction) {
                      direction == DismissDirection.endToStart
                          ? deleteChurch(church, "churchesSuggested")
                          : approveChurch(church);

                      setState(() {
                        churches.removeAt(index);
                      });
                    },
                    background: Container(
                      color: Colors.green,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Подтвердить',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Удалить',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    updateChurches();
  }

  void deleteChurch(Church church, String collection) async {
    await Firestore.instance
        .collection(collection)
        .document(church.id)
        .delete();
  }

  void approveChurch(Church church) async {
    await Firestore.instance
        .collection("churches")
        .document(church.id)
        .setData({
      'coords': GeoPoint(church.coords.latitude, church.coords.longitude),
      'description': church.description,
      'name': church.name,
    });
    await Firestore.instance
        .collection("churchesSuggested")
        .document(church.id)
        .delete();
  }

  Future<List<Church>> getChurches(String collectionName) async {
    List<Church> churches = List();
    await Firestore.instance
        .collection(collectionName)
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              churches.add(Church(
                  id: element.documentID,
                  name: element.data['name'],
                  description: element.data['description'],
                  coords: LatLng((element.data['coords'] as GeoPoint).latitude,
                      (element.data['coords'] as GeoPoint).longitude)));
            }));
    loaded = true;
    return churches;
  }

  void updateChurches() async {
    var churches = await getChurches("churchesSuggested");
    setState(() {
      this.churches = churches;
    });
    _refreshController.refreshCompleted();
  }
}
