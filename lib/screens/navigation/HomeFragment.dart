import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Ingredient.dart';
import 'package:nutriclock_app/models/MealPlanType.dart';
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
  MealPlanType _mealPlanType;

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
        MealPlanType mealPlanType;
        List<Ingredient> ingredients = [];
        if (data.mealPlanType != null) {
          mealPlanType = MealPlanType.fromJson(data.mealPlanType);
          mealPlanType.ingredients.forEach((element) {
            ingredients.add(Ingredient.fromJson(element));
          });
          mealPlanType.ingredients = ingredients;
        }

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
          _mealPlanType = mealPlanType;
          _isLoading = false;
        });
      } else {
        this.setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print(error);
      this.setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _renderLastMealCard() {
    return Container(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Color(0xFFA3E1CB),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.restaurant_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 7,
                    child: Text(
                      "Próxima Refeição",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 3,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Text(
                      _renderType(_mealPlanType.type),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Icon(
                    Icons.access_time_rounded,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    _mealPlanType.hour,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ..._renderIngredient()
          ],
        ),
      ),
    );
  }

  _renderType(type) {
    switch (type) {
      case 'P':
        return 'Pequeno-almoço';
      case 'A':
        return 'Almoço';
      case 'J':
        return 'Jantar';
      case 'S':
        return 'Snacks';
      case 'O':
        return 'Ceia';
      case 'L':
        return 'Lanche';
      default:
        return 'Meio da manhã';
    }
  }

  List<Widget> _renderIngredient() {
    List<Widget> list = [];

    _mealPlanType.ingredients.forEach((element) {
      list.add(Container(
        decoration: BoxDecoration(
          color: Colors.white54,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.room_service,
                color: Colors.black,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 7,
                child: Text(
                  element.name,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                "${element.quantity} ${element.unit}",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ));
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFF1F1F1),
              ),
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/lateral_bar.png',
              alignment: Alignment.bottomLeft,
            ),
          ),
          Positioned.fill(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (_mealPlanType != null) _renderLastMealCard(),
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
                            percent: _computeProgress(
                                _mealDaysRegistered.toDouble(), 3),
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
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ]),
                            backgroundColor: Color(0xFFF6EEEE),
                            progressColor: Color(0xFFFFBCBC),
                            footer: Text(
                              "Total de Alimentos / Refeições: $_totalMeals",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
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
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ]),
                            backgroundColor: Color(0xFFDEF3FF),
                            progressColor: Color(0xFFA0DDFF),
                            footer: Text(
                              "Média de Horas de Sono: $_averageSleepHours",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Exercício",
                            style: TextStyle(
                                color: Color(0xFF60B2A3),
                                fontFamily: 'Pacifico',
                                fontSize: 16),
                          ),
                          CircularPercentIndicator(
                            radius: 100.0,
                            lineWidth: 10.0,
                            percent: _totalSportDays.toDouble() /
                                EIGHT_WEEK_FIVE_DAYS,
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
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ]),
                            backgroundColor: Color(0xFFFFF4D6),
                            progressColor: Color(0xFFF4D481),
                            footer: Column(
                              children: [
                                Text(
                                  "Duração total: $_totalExerciseHours horas",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Duração média: $_averageExerciseHours",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Total calorias gastas: $_totalBurnedCals",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Média de calorias gastas: $_averageBurnedCals",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
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
