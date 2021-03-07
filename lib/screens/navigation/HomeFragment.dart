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
  var _averageExerciseHours = 0.0;
  var _totalBurnedCals = 0;
  var _averageBurnedCals = 0;
  var _averageSleepHours = 0.0;
  var _isLoading = false;
  var _totalSportDays = 0;

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

        var daysRegistered = 0;
        var sleeps = 0;

        if (data.totalDaysRegistered != null)
          daysRegistered = data.totalDaysRegistered;
        if (data.totalSleepDays != null) sleeps = data.totalSleepDays;
        this.setState(() {
          _mealDaysRegistered = daysRegistered;
          _totalMeals = data.meals;
          _totalSleeps = sleeps;
          _averageSleepHours = double.parse(data.averageSleepHours);
          _totalExerciseHours = data.totalDuration;
          _averageExerciseHours = double.parse(data.averageDuration);
          _totalBurnedCals = data.totalBurnedCals;
          _averageBurnedCals = data.averageBurnedCals;
          _totalSportDays = data.totalSportDays;
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_home.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: _isLoading
            ? Center(
                child: Loading(
                    indicator: BallPulseIndicator(),
                    size: 50.0,
                    color: Color(0xFFFFBCBC)),
              )
            : SingleChildScrollView(
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
                            color: Color(0xFF60B2A3),
                            fontFamily: 'Pacifico',
                            fontSize: 16),
                      ),
                      CircularPercentIndicator(
                        radius: 100.0,
                        lineWidth: 10.0,
                        percent:
                            _computeProgress(_mealDaysRegistered.toDouble(), 3),
                        center: Column(children: [
                          SizedBox(
                            height: 20,
                          ),
                          new Icon(
                            Icons.ramen_dining,
                            size: 50.0,
                            color: Color(0xFFFFBCBC),
                          ),
                          Text(
                            "$_mealDaysRegistered dias",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ]),
                        backgroundColor: Color(0xFFF6EEEE),
                        progressColor: Color(0xFFFFBCBC),
                        footer: Text(
                          "Total de Alimentos / Refeições: $_totalMeals",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Color(0xFF797979), fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Sono",
                        style: TextStyle(
                            color: Color(0xFF60B2A3),
                            fontFamily: 'Pacifico',
                            fontSize: 16),
                      ),
                      CircularPercentIndicator(
                        radius: 100.0,
                        lineWidth: 10.0,
                        percent: _computeProgress(
                            _totalSleeps.toDouble(), EIGHT_WEEK_DAYS),
                        center: Column(children: [
                          SizedBox(
                            height: 20,
                          ),
                          new Icon(
                            Icons.bedtime,
                            size: 50.0,
                            color: Color(0xFFA0DDFF),
                          ),
                          Text(
                            "$_totalSleeps dias",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ]),
                        backgroundColor: Color(0xFFDEF3FF),
                        progressColor: Color(0xFFA0DDFF),
                        footer: Text(
                          "Média de Horas de Sono: $_averageSleepHours",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Color(0xFF797979), fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Exercicio",
                        style: TextStyle(
                            color: Color(0xFF60B2A3),
                            fontFamily: 'Pacifico',
                            fontSize: 16),
                      ),
                      CircularPercentIndicator(
                        radius: 100.0,
                        lineWidth: 10.0,
                        percent:
                            _totalSportDays.toDouble() / EIGHT_WEEK_FIVE_DAYS,
                        center: Column(children: [
                          SizedBox(
                            height: 20,
                          ),
                          new Icon(
                            Icons.directions_run_rounded,
                            size: 50.0,
                            color: Color(0xFFF4D481),
                          ),
                          Text(
                            "$_totalSportDays dias",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ]),
                        backgroundColor: Color(0xFFFFF4D6),
                        progressColor: Color(0xFFF4D481),
                        footer: Column(
                          children: [
                            Text(
                              "Duração total: ${_totalExerciseHours} horas",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF797979), fontSize: 12),
                            ),
                            Text(
                              "Duração média: ${_averageExerciseHours}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF797979), fontSize: 12),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Total calorias queimadas: ${_totalBurnedCals}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF797979), fontSize: 12),
                            ),
                            Text(
                              "Média de calorias queimadas: ${_averageBurnedCals}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF797979), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  _computeProgress(double value, int max) {
    var aux = value / max;

    if (aux < 0.0) return 0.0;
    if (aux > 1.0) return 1.0;
    return aux;
  }
}
