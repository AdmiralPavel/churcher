import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyUser extends ChangeNotifier {
  FirebaseUser _user;
  UserState _state = UserState.LoggedOut;

  set state(UserState state) {
    _state = state;
    notifyListeners();
  }

  UserState get state => _state;

  set user(FirebaseUser user) {
    _user = user;
    notifyListeners();
  }

  FirebaseUser get user => _user;
}

enum UserState {
  LoggedIn,
  LoggedOut,
  Loading,
}
