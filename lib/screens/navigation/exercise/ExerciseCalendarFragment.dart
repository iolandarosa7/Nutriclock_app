import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/screens/navigation/exercise/ExerciseDetailsFragment.dart';
import 'package:nutriclock_app/screens/navigation/exercise/ExerciseFragment.dart';
import 'package:nutriclock_app/screens/navigation/exercise/ExerciseReportFragment.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ExerciseCalendarFragment extends StatefulWidget {
  @override
  _ExerciseCalendarFragmentState createState() =>
      _ExerciseCalendarFragmentState();
}

class _ExerciseCalendarFragmentState extends State<ExerciseCalendarFragment> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<DateTime> _dates = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    try {
      var response = await Network().getWithAuth(EXERCISES_DATES_URL);

      if (response.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];
        List<DateTime> dates = [];

        data.forEach((element) {
          var dateArray = element.split("/");
          dates.add(DateTime(int.parse(dateArray[2]), int.parse(dateArray[1]),
              int.parse(dateArray[0])));
        });

        this.setState(() {
          _dates = dates;
        });
      }
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: AppWidget().getImageContainer(
        "assets/images/bg_green_gradient.png",
        false,
        Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Image.asset(
                  'assets/images/sport_woman.png',
                  height: MediaQuery.of(context).size.height / 4,
                ),
              ),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseReportFragment(),
                          ),
                        );
                      },
                      child: Card(
                        color: Color(0xFFA3E1CB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                        margin: EdgeInsets.only(top: 20, right: 40, bottom: 16),
                        shadowColor: Color(0xFFA3E1CB),
                        elevation: 10,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 4, bottom: 4, left: 16),
                            child: Row(
                              children: [
                                Text(
                                  "Relatório Gráfico",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.insights_rounded,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      color: Color(0xFFA3E1CB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      margin: EdgeInsets.only(right: 40, bottom: 20),
                      shadowColor: Color(0xFFA3E1CB),
                      elevation: 10,
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding:
                          EdgeInsets.only(left: 16, bottom: 4, top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Registar Atividade Física",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text("Seleciona uma data abaixo no calendário",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SfDateRangePicker(
                      view: DateRangePickerView.month,
                      todayHighlightColor: Color(0xFF60B2A3),
                      selectionColor: Color(0xFFA3E1CB),
                      monthCellStyle: DateRangePickerMonthCellStyle(
                        todayTextStyle: TextStyle(
                          color: Color(0xFF60B2A3),
                        ),
                        specialDatesDecoration: BoxDecoration(
                            color: const Color(0xFFDFDFDF),
                            border: Border.all(
                                color: const Color(0xFFDFDFDF), width: 1),
                            shape: BoxShape.circle),
                        specialDatesTextStyle: TextStyle(color: Colors.white),
                      ),
                      maxDate: new DateTime.now(),
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        final DateTime value = args.value;
                        if (value.compareTo(new DateTime.now()
                                .subtract(new Duration(days: 3))) <
                            0) {
                          _showExerciseDetails(value);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExerciseFragment(
                                      value: value,
                                    )),
                          ).then((value) => {_loadData()});
                        }
                      },
                      monthViewSettings: DateRangePickerMonthViewSettings(
                          specialDates: _dates),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showExerciseDetails(DateTime value) {
    if (_dates.length > 0) {
      _dates.forEach((element) {
        if (element.compareTo(value) == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExerciseDetailsFragment(
                      value: value,
                    )),
          );
        }
      });
    }
  }
}
