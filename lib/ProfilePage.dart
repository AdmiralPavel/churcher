import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlatButton(
        onPressed: () {},
        child: Text('Press me'),
      ),
    );
  }

//  Future<FirebaseUser> _handleSignIn() async {
//    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//    final GoogleSignInAuthentication googleAuth =
//        await googleUser.authentication;
//
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleAuth.accessToken,
//      idToken: googleAuth.idToken,
//    );
//
//    final FirebaseUser user =
//        (await _auth.signInWithCredential(credential)).user;
//    print("signed in " + user.displayName);
//    return user;
//  }
}
