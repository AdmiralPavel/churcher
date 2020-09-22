import 'package:churcher/data_models/Church.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChurchElement extends StatefulWidget {
  @override
  _ChurchElementState createState() => _ChurchElementState(church);

  ChurchElement(this.church);

  final church;
}

class _ChurchElementState extends State<ChurchElement> {
  final Church church;
  String imageLink = "";

  _ChurchElementState(this.church);

  @override
  Widget build(BuildContext context) {
    _getImageLink(church.id);
    return Card(
      child: Row(
        children: [
          Image.network(
            imageLink,
            height: 100,
            width: 100,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            church.name,
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _getImageLink(String image) async {
    var tempLink =
        await FirebaseStorage.instance.ref().child(image).getDownloadURL();
    setState(() {
      imageLink = tempLink;
    });
  }
}
