import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'data_models/Church.dart';

class ChurchPage extends StatefulWidget {
  final Church church;

  ChurchPage(this.church);

  @override
  State<ChurchPage> createState() => ChurchPageState(church);
}

class ChurchPageState extends State<ChurchPage> {
  final Church church;

  ChurchPageState(this.church);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(),
      ),
    );
  }
}
