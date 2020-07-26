import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInUpPage extends StatefulWidget {
  @override
  _SignInUpPageState createState() => _SignInUpPageState();
}

class _SignInUpPageState extends State<SignInUpPage> {
  bool registration = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
            registration
                ? TextFormField(
                    key: _key,
//                    onChanged: (str) {
//                      _key.currentState.validate();
//                    },
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
              onPressed: () {
//                registration
//                    ? signUp(emailController.text, passwordController.text)
//                    : signIn(emailController.text, passwordController.text);
              },
              child: Container(
                height: 40,
                width: 200,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    registration ? 'Зарегистрироваться' : "Войти",
                    textAlign: TextAlign.center,
                  ),
                ),
                color: Colors.blueAccent,
              ),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  registration ? registration = false : registration = true;
                });
              },
              child: Text(
                registration
                    ? 'Уже зарегистрированы?\nВойти'
                    : 'Нет аккаунта?\nЗарегистрироваться',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
