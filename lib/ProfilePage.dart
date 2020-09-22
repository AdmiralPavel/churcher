import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'SuggestedChurchesPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState(user);

  ProfilePage(this.user);

  final FirebaseUser user;
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseUser user;

  _ProfilePageState(this.user);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
          onPressed: () {},
          child: Column(
            children: [
              Text(user.email),
              user.email == "admiralpavel99@gmail.com"
                  ? FlatButton(
                      child: Text("Список церквей для модерации"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SuggestedChurchesPage()),
                        );
                      },
                    )
                  : Container(),
            ],
          ),
        )
      ],
    );
  }
}
