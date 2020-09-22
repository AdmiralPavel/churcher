import 'package:churcher/ProfilePage.dart';
import 'package:churcher/controllers/UserController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data_models/MyUser.dart';

class SignInUpPage extends StatefulWidget {
  @override
  _SignInUpPageState createState() => _SignInUpPageState();
}

class _SignInUpPageState extends State<SignInUpPage> {
  Status status = Status.sign_in;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  final _key = GlobalKey<FormState>();
  bool progressVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: status == Status.logged_in
            ? Consumer<MyUser>(builder: (context, user, child) {
                return ProfilePage(user.user);
              })
            : Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: "Почта",
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: "Пароль",
                    ),
                  ),
                  status == Status.sign_up
                      ? TextFormField(
                          key: _key,
                          onChanged: (str) {
                            _key.currentState.validate();
                          },
                          obscureText: true,
                          controller: passwordConfirmationController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              labelText: "Подтверждение пароля"),
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    onPressed: () async {
                      setState(() => progressVisibility = true);
                      FirebaseUser user = status == Status.sign_up
                          ? await UserController.signUp(emailController.text,
                              passwordController.text, context)
                          : await UserController.signIn(emailController.text,
                              passwordController.text, context);
                      setState(() => progressVisibility = false);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ProfilePage(user);
                          },
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 200,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          status == Status.sign_up
                              ? 'Зарегистрироваться'
                              : "Войти",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      color: Colors.blueAccent,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        status == Status.sign_up
                            ? status = Status.sign_in
                            : status = Status.sign_up;
                      });
                    },
                    child: Text(
                      status == Status.sign_up
                          ? 'Уже зарегистрированы?\nВойти'
                          : 'Нет аккаунта?\nЗарегистрироваться',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Consumer<MyUser>(builder: (context, user, child) {
                    return user.state == UserState.Loading
                        ? CircularProgressIndicator()
                        : Container();
                  }),
                ],
              ),
      ),
    );
  }
}

enum Status {
  sign_in,
  sign_up,
  logged_in,
}
