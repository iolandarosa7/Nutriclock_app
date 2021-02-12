import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: AppWidget().getImageContainer(
        "assets/images/bg_run.jpg",
        false,
        Column(
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
                margin: EdgeInsets.only(top: 20, right: 40, bottom: 20),
                shadowColor: Color(0xFFA3E1CB),
                elevation: 10,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8, left: 20),
                    child: Row(
                      children: [
                        Text(
                          "Relatório Gráfico",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'PatrickHand',
                            fontSize: 30,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.insights_rounded,
                              size: 40,
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
                    border:
                        Border.all(color: const Color(0xFFDFDFDF), width: 1),
                    shape: BoxShape.circle),
                blackoutDateTextStyle: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.lineThrough),
              ),
              maxDate: new DateTime.now(),
              minDate: new DateTime.now().subtract(new Duration(days: 2)),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                final dynamic value = args.value;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExerciseFragment(
                            value: value,
                          )),
                ) /* .then((value) => {_loadData()}) */;
              },
              /*monthViewSettings:
      DateRangePickerMonthViewSettings(blackoutDates: _dates),*/
            ),
          ],
        ),
      ),
    );
  }
}
