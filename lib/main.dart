import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nutriclock_app/constants/constants.dart' as Constants;
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/notifications/NotificationsService.dart';
import 'package:nutriclock_app/screens/home.dart';
import 'package:nutriclock_app/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'constants/constants.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      SfGlobalLocalizations.delegate
    ],
    supportedLocales: [
      const Locale('pt', ''),
      const Locale('en', ''),
      const Locale('fr', ''),
    ],
    locale: const Locale('pt'),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initFirebase();
    super.initState();
  }

  initFirebase () async {
    await Firebase.initializeApp();
    NotificationsService(FirebaseMessaging.instance).initialize();
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 2,
        navigateAfterSeconds: new AfterSplash(),
        imageBackground: AssetImage("assets/images/splash.png"),
        loaderColor: Colors.transparent);
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
      var response = await Network().getWithAuth(USERS_ME_URL);
      if (response.statusCode == RESPONSE_SUCCESS) {
        setState(() {
          isAuth = true;
        });
      }
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
