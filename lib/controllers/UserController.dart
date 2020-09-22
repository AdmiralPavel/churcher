import 'package:churcher/data_models/MyUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<FirebaseUser> signIn(
      String email, String password, var context) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    context.read()<MyUser>().user = user;
    saveCredentials(email, password);
    return user;
  }

  static Future<FirebaseUser> signUp(
      String email, String password, var context) async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    context.read()<MyUser>().user = user;
    saveCredentials(email, password);
    return user;
  }

  static Future<void> saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('login', email);
    await prefs.setString('password', password);
  }

  static Future<void> autoSignIn(var context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login = prefs.getString('login');
    String password = prefs.getString('password');
    signIn(login, password, context);
  }
}
