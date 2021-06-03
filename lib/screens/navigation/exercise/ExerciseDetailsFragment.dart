import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Exercise.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';

class ExerciseDetailsFragment extends StatefulWidget {
  final dynamic value;

  ExerciseDetailsFragment({Key key, @required this.value}) : super(key: key);

  @override
  _ExerciseDetailsFragmentState createState() =>
      _ExerciseDetailsFragmentState();
}

class _ExerciseDetailsFragmentState extends State<ExerciseDetailsFragment> {
  var _isLoading = false;
  List<Exercise> _exercises = [];
  var appWidget = AppWidget();
  final dateFormat = new DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    List<Exercise> exercises = [];
    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    try {
      var responseExercises = await Network().getWithAuthParam(
          EXERCISES_DETAIL_URL, widget.value.toIso8601String());
      if (responseExercises.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data = json.decode(responseExercises.body)[JSON_DATA_KEY];
        data.forEach((element) {
          Exercise e = Exercise.fromJson(element);
          exercises.add(e);
        });

        this.setState(() {
          _exercises = exercises;
        });
      }
    } catch (error) {}

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          appWidget.getAppbar("Exercício ${dateFormat.format(widget.value)}"),
      body: appWidget.getImageContainer(
        "assets/images/bg_sport_detail.jpg",
        _isLoading,
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.only(left: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _renderData(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _renderData() {
    List<Widget> list = [];

    _exercises.forEach((element) {
      var item = Container(
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
            ),
          ),
          margin: EdgeInsets.only(top: 20, right: 40, bottom: 20),
          shadowColor: Color(0xFFA3E1CB),
          elevation: 10,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: Color(element.type == 'E' ? 0xFFA0DDFF : 0xFFE6A9A9),
                    width: 10.0),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 8, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    element.type == 'E'
                        ? 'Atividade Desportiva'
                        : 'Atividade Doméstica',
                    style: TextStyle(
                      fontSize: 10,
                      color:
                          Color(element.type == 'E' ? 0xFFA0DDFF : 0xFFE6A9A9),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    element.name,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Color(0xFFF4D481),
                              size: 16,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "MET",
                              style: TextStyle(
                                  fontSize: 10, color: Colors.black87),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text("${element.met}"),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Icon(
                              Icons.timer,
                              color: Color(0xFFF4D481),
                              size: 16,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text("${element.met}"),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "minutos",
                              style: TextStyle(
                                  fontSize: 10, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Icon(
                        Icons.fitness_center,
                        color: Color(0xFFF4D481),
                        size: 16,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "${element.burnedCalories}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "calorias gastas",
                        style: TextStyle(fontSize: 10, color: Colors.black87),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );

      list.add(item);
    });
    return list;
  }
}
