import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutriclock_app/screens/login.dart';
import 'package:nutriclock_app/screens/home.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(
    new MaterialApp(
      home: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 2,
        navigateAfterSeconds: new AfterSplash(),
        imageBackground: AssetImage("assets/images/splash.png"),
        loaderColor: Colors.transparent
    );
  }
}


class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutriclock',
      debugShowCheckedModeBanner: false,
      home: CheckAuth(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString(Constants.LOCAL_STORAGE_TOKEN_KEY);

    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (isAuth) {
      child = Home();
    } else {
      child = Login();
    }

    return Scaffold(
      body: child,
    );
  }
}
