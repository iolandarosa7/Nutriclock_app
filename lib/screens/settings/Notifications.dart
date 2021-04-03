import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/NotificationModel.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';

class NotificationsFragment extends StatefulWidget {
  @override
  _NotificationsFragmentState createState() => _NotificationsFragmentState();
}

class _NotificationsFragmentState extends State<NotificationsFragment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _appWidget = AppWidget();
  var _isLoading = false;
  var _sleepNotification = true;
  var _exerciseNotification = true;
  var _mealDiaryNotification = true;

  @override
  void initState() {
    _loadNotificationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appWidget.getAppbar("Notificações"),
      body: _appWidget.getImageContainer(
        "assets/images/bg_login.png",
        _isLoading,
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 8),
            child: Card(
              elevation: 4.0,
              color: Colors.white,
              margin: EdgeInsets.only(left: 20, right: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Image(
                      image: AssetImage("assets/images/nutri.png"),
                      height: 45,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.nights_stay,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Notificações do Sono",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Switch(
                          value: _sleepNotification,
                          onChanged: (value) {
                            setState(() {
                              _sleepNotification = value;
                            });
                            _toggleNotifications('SLEEP', value);
                          },
                          activeColor: Color(0xFFA3E1CB),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.directions_run,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Notificações do Exercício",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Switch(
                          value: _exerciseNotification,
                          onChanged: (value) {
                            setState(() {
                              _exerciseNotification = value;
                            });
                            _toggleNotifications('EXERCISE', value);
                          },
                          activeColor: Color(0xFFA3E1CB),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.restaurant_menu_rounded,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Notificações do Diário Alimentar",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Switch(
                          value: _mealDiaryNotification,
                          onChanged: (value) {
                            setState(() {
                              _mealDiaryNotification = value;
                            });
                            _toggleNotifications('MEAL', value);
                          },
                          activeColor: Color(0xFFA3E1CB),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _toggleNotifications(type, value) async {
    var sleep = _sleepNotification;
    var exercise = _exerciseNotification;
    var mealDiary = _mealDiaryNotification;

    switch (type) {
      case 'SLEEP':
        sleep = value;
        break;
      case 'EXERCISE':
        exercise = value;
        break;
      case 'MEAL_DIARY':
        mealDiary = value;
        break;
      default:
        return;
    }

    if (this._isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network().postWithAuth({
        'notificationsSleep': sleep,
        'notificationsExercise': exercise,
        'notificationsMealDiary': mealDiary,
      }, NOTIFICATION_URL);

      if (response.statusCode == RESPONSE_SUCCESS_201 ||
          response.statusCode == RESPONSE_SUCCESS) {
        _appWidget.showSnackbar("Informação alterada com sucesso!", Colors.green, _scaffoldKey);
      } else {
        _appWidget.showSnackbar("Ocorreu um erro!", Colors.red, _scaffoldKey);
      }
    } catch (error) {
      print(error);
      _appWidget.showSnackbar("Ocorreu um erro!", Colors.red, _scaffoldKey);
    } finally {
      this.setState(() {
        _isLoading = false;
      });
    }
  }

  _loadNotificationData() async {
    if (this._isLoading) return;
    this.setState(() {
      _isLoading = true;
    });
    try {
      var response = await Network().getWithAuth(NOTIFICATION_URL);
      if (response.statusCode == RESPONSE_SUCCESS_201 ||
          response.statusCode == RESPONSE_SUCCESS) {
        var data = NotificationModel.fromJson(
            json.decode(response.body)[JSON_DATA_KEY]);
        this.setState(() {
          _sleepNotification = data.notificationsSleep == 0 ? false : true;
          _exerciseNotification =
              data.notificationsExercise == 0 ? false : true;
          _mealDiaryNotification =
              data.notificationsMealDiary == 0 ? false : true;
        });
      }
    } catch (error) {} finally {
      this.setState(() {
        _isLoading = false;
      });
    }
  }
}
