import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Statistics.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  var _totalMeals = 0;
  var _mealDaysRegistered = 0;
  var _totalSleeps = 0;
  var _totalExerciseHours = 0;
  var _averageSleepHours = 0.0;
  var _isLoading = false;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    if (_isLoading) return;

    this.setState(() {
      _isLoading = true;
    });
    try {
      var response = await Network().getWithAuth(STATS_URL);

      if (response.statusCode == RESPONSE_SUCCESS) {
        var data = Statistics.fromJson(json.decode(response.body));
        this.setState(() {
          _mealDaysRegistered = data.totalDaysRegistered;
          _totalMeals = data.meals;
          _totalSleeps = data.totalSleepDays;
          _averageSleepHours = double.parse(data.averageSleepHours);
          _isLoading = false;
        });
      }
    } catch (error) {
      this.setState(() {
        _isLoading = false;
      });
    }
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
          : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x8074D44D), Color(0x20FFFFFF)]),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Diário Alimentar",
                        style: TextStyle(
                            color: Color(0xFF74D44D),
                            fontFamily: 'Pacifico',
                            fontSize: 16),
                      ),
                      CircularPercentIndicator(
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
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ]),
                        backgroundColor: Colors.black12,
                        progressColor: Colors.green,
                        footer: Text(
                          "Total de Alimentos / Refeições: $_totalMeals",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Sono",
                        style: TextStyle(
                            color: Color(0xFF74D44D),
                            fontFamily: 'Pacifico',
                            fontSize: 16),
                      ),
                      CircularPercentIndicator(
                        radius: 100.0,
                        lineWidth: 10.0,
                        percent: _totalSleeps / EIGHT_WEEK_DAYS,
                        center: Column(children: [
                          SizedBox(
                            height: 20,
                          ),
                          new Icon(
                            Icons.bedtime,
                            size: 50.0,
                            color: Colors.green,
                          ),
                          Text(
                            "$_totalSleeps dias",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ]),
                        backgroundColor: Colors.black12,
                        progressColor: Colors.green,
                        footer: Text(
                          "Média de Horas de Sono: $_averageSleepHours",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Exercicio",
                        style: TextStyle(
                            color: Color(0xFF74D44D),
                            fontFamily: 'Pacifico',
                            fontSize: 16),
                      ),
                      CircularPercentIndicator(
                        radius: 100.0,
                        lineWidth: 10.0,
                        percent: _totalExerciseHours.toDouble(),
                        center: Column(children: [
                          SizedBox(
                            height: 20,
                          ),
                          new Icon(
                            Icons.directions_run_rounded,
                            size: 50.0,
                            color: Colors.green,
                          ),
                          Text(
                            "$_totalExerciseHours dias",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ]),
                        backgroundColor: Colors.black12,
                        progressColor: Colors.green,
                        footer: Text(
                          "Média de Horas de Exercicio: 0",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
