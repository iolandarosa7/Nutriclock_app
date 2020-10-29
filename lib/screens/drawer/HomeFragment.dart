import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Statistics.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  var _totalMeals = 0;
  var _mealDaysRegistered = 0;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var storeUser = localStorage.getString(LOCAL_STORAGE_USER_KEY);
    var days = 0;

    if (storeUser != null) {
      User user = User.fromJson(json.decode(storeUser));
      try {
        var response =
            await Network().getWithAuth("$MEALS_STATS_URL/${user.id}");

        if (response.statusCode == RESPONSE_SUCCESS) {
          var data = Statistics.fromJson(json.decode(response.body));
          this.setState(() {
            _mealDaysRegistered = data.totalDaysRegistered;
            _totalMeals = data.meals;
          });

          days = data.daysFromInitialDate;
        }
      } catch (error) {
        print(error.toString());
      }

      localStorage.setInt(LOCAL_STORAGE_MEALS_DAYS_DURATION_KEY, days);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x8074D44D), Color(0x20FFFFFF)]),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  ClipRect(
                    child: Image.asset(
                      "assets/images/header.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Diário Alimentar",
                          style: TextStyle(
                              color: _mealDaysRegistered == 0
                                  ? Color(0x9074D44D)
                                  : Color(0xFF74D44D),
                              fontFamily: 'Pacifico',
                              fontSize: 16),
                        ),
                        _mealDaysRegistered == 0
                            ? Text(
                                "Começa já a registar todos os alimentos que ingeres durante 3 dias no Diário Alimentar!",
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              )
                            : new CircularPercentIndicator(
                                radius: 100.0,
                                lineWidth: 10.0,
                                percent: _mealDaysRegistered / 3,
                                center: Column(children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  new Icon(
                                    Icons.ramen_dining,
                                    size: 50.0,
                                    color: Colors.green,
                                  ),
                                  Text(
                                    "$_mealDaysRegistered dias",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 12),
                                  ),
                                ]),
                                backgroundColor: Colors.black12,
                                progressColor: Colors.green,
                                footer: Text(
                                  "Total de Alimentos: $_totalMeals",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                              ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Sono",
                          style: TextStyle(
                              color: Color(0x9074D44D),
                              fontFamily: 'Pacifico',
                              fontSize: 16),
                        ),
                        Text(
                          "Ainda não há progresso para mostrar!",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Exercicio",
                          style: TextStyle(
                              color: Color(0x9074D44D),
                              fontFamily: 'Pacifico',
                              fontSize: 16),
                        ),
                        Text(
                          "Ainda não há progresso para mostrar!",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
