import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'LatLngPickerPage.dart';
import 'data_models/Church.dart';
import 'resources/Strings.dart';

class ChurchCreationPage extends StatefulWidget {
  @override
  _ChurchCreationPageState createState() => _ChurchCreationPageState();
}

class _ChurchCreationPageState extends State<ChurchCreationPage> {
  final picker = ImagePicker();
  File _image;
  LatLng coords;
  bool _imagePicked = false;
  bool _progressVisibility = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    child: !_imagePicked
                        ? Container(
                            color: Colors.grey,
                            child: Icon(
                              Icons.add,
                              size: 120,
                            ),
                          )
                        : Image.file(
                            _image,
                            width: 120,
                            height: 120,
                          ),
                    onPressed: () => getImage(),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: Strings.churchName),
                  )),
                ],
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 4,
                controller: descriptionController,
              ),
              FlatButton(
                child: Text(Strings.chooseOnMap),
                onPressed: () async {
                  coords = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LatLngPickerPage()));
                },
              ),
              _progressVisibility ? CircularProgressIndicator() : SizedBox(),
              Expanded(
                child: SizedBox(),
                flex: 1,
              ),
              FlatButton(
                child: Text(Strings.confirm),
                onPressed: () {
                  uploadChurch(
                      Church(
                        coords: coords,
                        name: nameController.text,
                        description: descriptionController.text,
                      ),
                      _image);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> uploadChurchExceptImage(Church church) async {
    var doc = await Firestore.instance.collection('churches').add({
      'coords': GeoPoint(church.coords.latitude, church.coords.longitude),
      'description': church.description,
      'name': church.name,
    });
    return doc.documentID;
  }

  void getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imagePicked = true;
      _image = File(pickedFile.path);
    });
  }

  Future<void> uploadImage(
    String externalPath,
    Uint8List data,
  ) async {
    final StorageReference storageReference =
        FirebaseStorage().ref().child(externalPath);
    final StorageUploadTask uploadTask = storageReference.putData(data);

    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      // You can use this to notify yourself or your user in any kind of way.
      // For example: you could use the uploadTask.events stream in a StreamBuilder instead
      // to show your user what the current status is. In that case, you would not need to cancel any
      // subscription as StreamBuilder handles this automatically.

      // Here, every StorageTaskEvent concerning the upload is printed to the logs.
      print('EVENT ${event.type}');
    });

// Cancel your subscription when done.
    await uploadTask.onComplete;
    streamSubscription.cancel();
  }

  void uploadChurch(Church church, File image) async {
    setState(() => _progressVisibility = true);
    var path = await uploadChurchExceptImage(church);
    await uploadImage(path, image.readAsBytesSync());
    setState(() => _progressVisibility = false);
    Navigator.pop(context, true);
  }
}
