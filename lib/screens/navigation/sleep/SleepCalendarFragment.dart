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
    } catch (error) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppWidget().getAppbar("Registar Horas de Sono"),
      body: SfDateRangePicker(
        view: DateRangePickerView.month,
        todayHighlightColor: Color(0xFF60B2A3),
        selectionColor: Color(0xFFA3E1CB),
        monthCellStyle: DateRangePickerMonthCellStyle(
          todayTextStyle: TextStyle(
            color: Color(0xFF60B2A3),
          ),
          blackoutDatesDecoration: BoxDecoration(
              color: const Color(0xFFDFDFDF),
              border: Border.all(color: const Color(0xFFDFDFDF), width: 1),
              shape: BoxShape.circle),
          blackoutDateTextStyle: TextStyle(
              color: Colors.white, decoration: TextDecoration.lineThrough),
        ),
        maxDate: new DateTime.now(),
        minDate: new DateTime.now().subtract(new Duration(days: 2)),
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          final dynamic value = args.value;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SleepRegisterFragment(
                      value: value,
                    )),
          ).then((value) => {_loadData()});
        },
        monthViewSettings:
            DateRangePickerMonthViewSettings(blackoutDates: _dates),
      ),
    );
  }
}
