import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatFragment extends StatefulWidget {
  @override
  _ChatFragmentState createState() => _ChatFragmentState();
}

class _ChatFragmentState extends State<ChatFragment> {
  var _isLoading = false;
  List<User> _professionals = [];

  @override
  void initState() {
    _getProfessionalsByUsf();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: Loading(
                  indicator: BallPulseIndicator(),
                  size: 50.0,
                  color: Colors.orangeAccent),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.only(top: 16, left: 8, bottom: 8, right: 8),
              itemCount: _professionals.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: _professionals[index].unreadMessages > 0
                        ? Badge(
                            shape: BadgeShape.circle,
                            badgeColor: Colors.redAccent,
                            badgeContent: Text(
                                "${_professionals[index].unreadMessages}",
                                style: TextStyle(color: Colors.white)),
                          )
                        : SizedBox(),
                    trailing: Icon(
                      Icons.chat_rounded,
                      color: Color(0xFF74D44D),
                    ),
                    title: Text('${_professionals[index].name}'),
                  ),
                );
              }),
    );
  }

  _getProfessionalsByUsf() async {
    List<User> list = [];

    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var storeUser = localStorage.getString(LOCAL_STORAGE_USER_KEY);

    if (storeUser != null) {
      User user = User.fromJson(json.decode(storeUser));
      try {
        var response =
            await Network().getWithAuth("$PROFESSIONALS_BY_USF/${user.ufc_id}");

        if (response.statusCode == RESPONSE_SUCCESS) {
          List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];

          data.forEach((element) {
            User user = User.fromJson(element);
            list.add(user);
          });

          this.setState(() {
            _professionals = list;
          });
        } else {}
      } catch (error) {}

      this.setState(() {
        _isLoading = false;
      });
    }
  }
}
