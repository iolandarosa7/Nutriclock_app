import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Report.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';

class ReportsFragment extends StatefulWidget {
  const ReportsFragment({Key key}) : super(key: key);

  @override
  _ReportsFragmentState createState() => _ReportsFragmentState();
}

class _ReportsFragmentState extends State<ReportsFragment> {
  var appWidget = AppWidget();
  var _isLoading = false;
  var _totalSleeps = '-';
  var _averageSleepTime = '-';
  var _maximumSleepHour = '-';
  var _maximumSleepDate = '-';
  var _minimumSleepHour = '-';
  var _minimumSleepDate = '-';
  List<double> _averageSleepArray = [0, 0, 0, 0, 0, 0, 0];
  List<double> _percentageSleepArray = [0, 0, 0, 0, 0, 0, 0];
  var _totalExercises = '-';
  var _averageExerciseTime = '-';
  var _averageExerciseCalories = '-';
  var _maximumExercise = '-';
  var _minimumExercise = '-';
  var _maximumCalories = '-';
  var _minimumCalories = '-';
  List<double> _averageExerciseArray = [0, 0, 0, 0, 0, 0, 0];
  List<double> _percentageExerciseArray = [0, 0, 0, 0, 0, 0, 0];
  List<double> _averageCaloriesArray = [0, 0, 0, 0, 0, 0, 0];
  List<double> _percentageCaloriesArray = [0, 0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    _loadReport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appWidget.getAppbar("Relatórios"),
      body: AppWidget().getImageContainer(
        "assets/images/bg_green.png",
        _isLoading,
        SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shadowColor: Color(0xFFA3E1CB),
                elevation: 10,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _renderTitle("Diário do Sono"),
                      _renderIcon(Icons.bedtime_rounded),
                      _renderSingleRowWithDivider(
                          "Total de registos", _totalSleeps),
                      _renderSingleRowWithDivider(
                          "Média de horas sono", "$_averageSleepTime h"),
                      _renderDoubleRowWithDivider("Máximo de horas sono",
                          "$_maximumSleepHour h", _maximumSleepDate),
                      _renderDoubleRowWithDivider("Mínimo de horas Sono",
                          "$_minimumSleepHour h", _minimumSleepDate),
                      _renderWeekAverage(
                          "Média horas sono / dia de semana",
                          _averageSleepArray,
                          _percentageSleepArray,
                          null,
                          null),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shadowColor: Color(0xFFA3E1CB),
                elevation: 10,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _renderTitle("Atividade Física"),
                      _renderIcon(Icons.directions_run_rounded),
                      _renderSingleRowWithDivider(
                          "Total de registos", _totalExercises),
                      _renderSingleRowWithDivider("Duração média da atividade",
                          "$_averageExerciseTime min"),
                      _renderSingleRowWithDivider("Calorias médias gastas",
                          "$_averageExerciseCalories kcal"),
                      _renderMaxMinExercise("Máximo", "$_maximumExercise min",
                          "$_maximumCalories kcal"),
                      _renderMaxMinExercise("Mínimo", "$_minimumExercise min",
                          "$_minimumCalories kcal"),
                      _renderWeekAverage(
                          "Duração e calorias médias  / dia de semana",
                          _averageExerciseArray,
                          _percentageExerciseArray,
                          _averageCaloriesArray,
                          _percentageCaloriesArray),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _renderTitle(value) {
    return Center(
      child: Text(
        value,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFA3E1CB),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  _renderIcon(icon) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Icon(
          icon,
          color: Color(0xFFA3E1CB),
          size: 40,
        ),
      ),
    );
  }

  _renderSingleRowWithDivider(label, value) {
    return Column(
      children: [
        _renderSingleRow(label, value),
        Divider(
          height: 10,
          thickness: 2,
        ),
      ],
    );
  }

  _renderSingleRow(label, value) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Color(0xFF707070),
                fontWeight: FontWeight.bold,
              ),
            ),
            flex: 1,
          ),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF898989),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _renderDoubleRowWithDivider(label, value1, value2) {
    return Column(
      children: [
        _renderDoubleRow(label, value1, value2),
        Divider(height: 10, thickness: 2),
      ],
    );
  }

  _renderDoubleRow(label, value1, value2) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            value1,
            style: TextStyle(
              color: Color(0xFF898989),
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Color(0xFF707070),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                flex: 1,
              ),
              Text(
                value2,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF898989),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _renderMaxMinExercise(title, time, calories) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF707070),
              fontWeight: FontWeight.bold,
            ),
          ),
          _renderMaxMinRow("Duração", time),
          _renderMaxMinRow("Calorias gastas", calories),
          Divider(height: 10, thickness: 2),
        ],
      ),
    );
  }

  _renderMaxMinRow(label, value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Color(0xFF898989),
              fontSize: 12,
            ),
          ),
          flex: 1,
        ),
        Text(
          value,
          style: TextStyle(
            color: Color(0xFF898989),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _renderWeekAverage(
      title, averageArray1, percentageArray1, averageArray2, percentageArray2) {
    //print(percentageArray2);
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF707070),
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _renderDayOfWeekChart(
                  "Seg",
                  averageArray1[0],
                  percentageArray1[0],
                  averageArray2 == null ? null : averageArray2[0],
                  percentageArray2 == null ? null : percentageArray2[0]),
              _renderDayOfWeekChart(
                  "Ter",
                  averageArray1[1],
                  percentageArray1[1],
                  averageArray2 == null ? null : averageArray2[1],
                  percentageArray2 == null ? null : percentageArray2[1]),
              _renderDayOfWeekChart(
                  "Qua",
                  averageArray1[2],
                  percentageArray1[2],
                  averageArray2 == null ? null : averageArray2[2],
                  percentageArray2 == null ? null : percentageArray2[2]),
              _renderDayOfWeekChart(
                  "Qui",
                  averageArray1[3],
                  percentageArray1[3],
                  averageArray2 == null ? null : averageArray2[3],
                  percentageArray2 == null ? null : percentageArray2[3]),
              _renderDayOfWeekChart(
                  "Sex",
                  averageArray1[4],
                  percentageArray1[4],
                  averageArray2 == null ? null : averageArray2[4],
                  percentageArray2 == null ? null : percentageArray2[4]),
              _renderDayOfWeekChart(
                  "Sab",
                  averageArray1[5],
                  percentageArray1[5],
                  averageArray2 == null ? null : averageArray2[5],
                  percentageArray2 == null ? null : percentageArray2[5]),
              _renderDayOfWeekChart(
                  "Dom",
                  averageArray1[6],
                  percentageArray1[6],
                  averageArray2 == null ? null : averageArray2[6],
                  percentageArray2 == null ? null : percentageArray2[6])
            ],
          ),
        ],
      ),
    );
  }

  _renderDayOfWeekChart(day, value1, percentage1, value2, percentage2) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 10,
                  height: percentage1,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
                if (percentage2 != null)
                  SizedBox(
                    width: 2,
                  ),
                if (percentage2 != null)
                  Container(
                    width: 10,
                    height: percentage2,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Text(day),
          Text(
            "($value1)",
            style: TextStyle(fontSize: 12, color: Colors.amber),
          ),
          if (value2 != null)
            Text(
              "($value2)",
              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
            )
        ],
      ),
    );
  }

  _loadReport() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    List<double> auxSleepAverage = [];
    List<double> auxSleepPercentage = [];
    List<double> auxCaloriesAverage = [];
    List<double> auxCaloriesPercentage = [];
    List<double> auxExerciseAverage = [];
    List<double> auxExercisePercentage = [];

    try {
      var response = await Network().getWithAuth(REPORT_URL);

      if (response.statusCode == RESPONSE_SUCCESS) {
        Report r = Report.fromJson(json.decode(response.body));

        //print(r.percentageCaloriesArray);

        r.averageSleepArray.forEach((element) {
          auxSleepAverage.add(double.parse(element));
        });

        r.percentageSleepArray.forEach((element) {
          auxSleepPercentage.add(double.parse(element));
        });

        r.averageCaloriesArray.forEach((element) {
          auxCaloriesAverage.add(double.parse(element));
        });

        r.percentageCaloriesArray.forEach((element) {
          auxCaloriesPercentage.add(double.parse(element));
        });

        r.averageExerciseArray.forEach((element) {
          auxExerciseAverage.add(double.parse(element));
        });

        r.percentageExerciseArray.forEach((element) {
          auxExercisePercentage.add(double.parse(element));
        });

        setState(() {
          _totalSleeps = r.totalSleeps;
          _averageSleepTime = r.averageSleepTime;
          _maximumSleepHour = r.maximumSleepHour;
          _maximumSleepDate = r.maximumSleepDate;
          _minimumSleepHour = r.minimumSleepHour;
          _minimumSleepDate = r.minimumSleepDate;
          _averageSleepArray = auxSleepAverage;
          _percentageSleepArray = auxSleepPercentage;
          _totalExercises = r.totalExercises;
          _averageExerciseTime = r.averageExerciseTime;
          _averageExerciseCalories = r.averageExerciseCalories;
          _maximumExercise = r.maximumExercise;
          _minimumExercise = r.minimumExercise;
          _maximumCalories = r.maximumCalories;
          _minimumCalories = r.minimumCalories;
          _averageExerciseArray = auxExerciseAverage;
          _percentageExerciseArray = auxExercisePercentage;
          _averageCaloriesArray = auxCaloriesAverage;
          _percentageCaloriesArray = auxCaloriesPercentage;
        });
      }
    } catch (error) {
      //print(error);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
