import 'package:flutter/material.dart';
import 'package:nutriclock_app/screens/navigation/sleep/SleepRegisterFragment.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SleepCalendarFragment extends StatefulWidget {
  @override
  _SleepCalendarFragmentState createState() => _SleepCalendarFragmentState();
}

class _SleepCalendarFragmentState extends State<SleepCalendarFragment> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Registar Horas de Sono",
          style: TextStyle(
            fontFamily: 'Pacifico',
          ),
        ),
        backgroundColor: Color(0xFF74D44D),
      ),
      body: SfDateRangePicker(
        view: DateRangePickerView.month,
        todayHighlightColor: Color(0xFF74D44D),
        selectionColor: Color(0xFF74D44D),
        monthCellStyle: DateRangePickerMonthCellStyle(
            todayTextStyle: TextStyle(
              color:  Color(0xFF74D44D),
            )
        ),
        minDate: new DateTime.now().subtract(new Duration(days: 2)),
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          final dynamic value = args.value;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SleepRegisterFragment(value: value,)),
          );
        },
      ),
    );
  }
}