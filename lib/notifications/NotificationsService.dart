import 'dart:io' show Platform;
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsService {
  /*final FirebaseMessaging _fcm;

  NotificationsService(this._fcm);

  Future initialize() async {
    if (Platform.isIOS) {
      var settings = await _fcm.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized)
        return;
    }

    String token = await _fcm.getToken();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString(FCM_TOKEN, token);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }*/
}
