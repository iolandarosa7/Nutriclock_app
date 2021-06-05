import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';

import 'MealDetailFragment.dart';

class MealCreateFragment extends StatefulWidget {
  @override
  _MealCreateFragmentState createState() => _MealCreateFragmentState();
}

class _MealCreateFragmentState extends State<MealCreateFragment> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ptDatesFuture = initializeDateFormatting('pt', null);
  final dateFormat = new DateFormat('dd/MM/yyyy');
  var appWidget = AppWidget();
  final _types = [
    MealType('P', 'Pequeno-almoço', Icons.breakfast_dining),
    MealType('M', 'Meio da manhã', Icons.local_cafe),
    MealType('A', 'Almoço', Icons.dinner_dining),
    MealType('L', 'Lanche', Icons.local_drink_rounded),
    MealType('J', 'Jantar', Icons.brunch_dining),
    MealType('O', 'Ceia', Icons.emoji_food_beverage),
    MealType('S', 'Snack', Icons.local_pizza_rounded),
  ];
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appWidget.getAppbar("Nova Refeição"),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_green.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: data(),
          ),
        ),
      ),
    );
  }

  List<Widget> data() {
    List<Widget> list = List();
    _types.forEach((element) {
      list.add(GestureDetector(
          onTap: () {
            _showDateTimeModal(element.type);
          },
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
            margin: EdgeInsets.only(top: 30, right: 40),
            shadowColor: Color(0xFFA3E1CB),
            elevation: 10,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 20),
                  child: Row(
                    children: [
                      Icon(
                        element.icon,
                        color: Color(0xFFF4D481),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        element.name,
                        style: TextStyle(
                          color: Color(0xFF60B2A3),
                          fontFamily: 'PatrickHand',
                          fontSize: 20,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  )),
            ),
          )));
    });
    return list;
  }

  Future<void> _showDateTimeModal(type) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return AlertDialog(
            title: Text(
              'Data / Hora da Refeição',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFA3E1CB)),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8, right: 4),
                        child: Icon(
                          Icons.calendar_today,
                          color: Color(0xFFA3E1CB),
                        ),
                      ),
                      Text(
                        'Data',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xFFA3E1CB)),
                      ),
                      FlatButton(
                        color: Colors.transparent,
                        splashColor: Colors.black26,
                        onPressed: () => _selectDate(context, 'DATE', setModalState),
                        child: Text(
                          dateFormat.format(_date),
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4, right: 4),
                        child: Icon(
                          Icons.access_time,
                          color: Color(0xFFA3E1CB),
                        ),
                      ),
                      Text(
                        'Hora',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xFFA3E1CB)),
                      ),
                      FlatButton(
                        color: Colors.transparent,
                        splashColor: Colors.black26,
                        onPressed: () => _selectDate(context, 'TIME', setModalState),
                        child: Text(
                          "${_time.hour}:${_time.minute > 9 ? _time.minute : "0${_time.minute}"} horas",
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Ok',
                  style: TextStyle(color: Color(0xFF60B2A3)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealDetailFragment(
                          type: type,
                          date: _date,
                          time:
                              "${_time.hour}:${_time.minute > 9 ? _time.minute : "0${_time.minute}"}"),
                    ),
                  );
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _selectDate(BuildContext context, String type, StateSetter setModalState) async {
    final ThemeData themeData = Theme.of(context);
    assert(themeData.platform != null);

    switch (themeData.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context, type, setModalState);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context, type, setModalState);
    }
  }

  void buildMaterialDatePicker(BuildContext context, String type, StateSetter setModalState) async {
    var nowDate = DateTime.now();
    
    if (type == 'TIME') {
      final pickedTime =
          await showTimePicker(context: context, initialTime: _time);

      if (pickedTime != null && pickedTime != _time) {
        setModalState(() {
          _time = pickedTime;
        });
      }

      return;
    }

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: nowDate.subtract(Duration(days: 3)),
      lastDate: nowDate,
      cancelText: 'Cancelar',
      fieldLabelText: 'Data da Refeição',
    );

    if (picked != null && picked != _date) {
      setModalState(() {
        _date = picked;
      });
    }
  }

  void buildCupertinoDatePicker(BuildContext context, String type, StateSetter setModalState) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: type == 'TIME'
                  ? CupertinoDatePickerMode.time
                  : CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (type != 'TIME' && picked != null && picked != _date)
                  setModalState(() {
                    _date = picked;
                  });

                if (type == 'TIME' && picked != null && picked != _time)
                  setModalState(() {
                    _time = TimeOfDay(hour: picked.hour, minute: picked.minute);
                  });
              },
              initialDateTime: type == 'TIME'
                  ? DateTime(1969, 1, 1, _time.hour, _time.minute)
                  : _date,
              minimumYear: 1900,
              maximumDate: DateTime.now(),
              use24hFormat: true,
              minuteInterval: 1,
            ),
          );
        });
  }
}

class MealType {
  String type;
  String name;
  IconData icon;

  MealType(type, name, icon) {
    this.type = type;
    this.name = name;
    this.icon = icon;
  }
}
