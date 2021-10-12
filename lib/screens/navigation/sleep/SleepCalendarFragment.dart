import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/screens/navigation/sleep/SleepRegisterFragment.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SleepCalendarFragment extends StatefulWidget {
  @override
  _SleepCalendarFragmentState createState() => _SleepCalendarFragmentState();
}

class _SleepCalendarFragmentState extends State<SleepCalendarFragment> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<DateTime> _dates = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    try {
      var response = await Network().getWithAuth(SLEEP_DATES_URL);

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
      appBar: AppWidget().getAppbar("Registar Horas de Sono"),
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
                  'assets/images/sleep_man.png',
                  height: MediaQuery.of(context).size.height / 4,
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(bottom: 150),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _showRegisterModal,
                      child: Card(
                        color: Color(0xFFA3E1CB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                        margin: EdgeInsets.only(right: 40, bottom: 20, top: 20),
                        shadowColor: Color(0xFFA3E1CB),
                        elevation: 10,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 16, bottom: 8, top: 8, right: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Seleciona uma data abaixo no calendário:",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
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
                        blackoutDatesDecoration: BoxDecoration(
                            color: const Color(0xFFDFDFDF),
                            border: Border.all(
                                color: const Color(0xFFDFDFDF), width: 1),
                            shape: BoxShape.circle),
                        blackoutDateTextStyle: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.lineThrough),
                      ),
                      maxDate: new DateTime.now(),
                      minDate:
                          new DateTime.now().subtract(new Duration(days: 2)),
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        final dynamic value = args.value;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SleepRegisterFragment(
                                    value: value,
                                  )),
                        ).then((value) => {_loadData()});
                      },
                      monthViewSettings: DateRangePickerMonthViewSettings(
                          blackoutDates: _dates),
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

  Future<void> _showRegisterModal() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Por favor seleciona uma data no calendário para começar!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Ok",
                  style: TextStyle(
                    color: Color(0xFF60B2A3),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
