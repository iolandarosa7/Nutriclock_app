import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'MealDetailFragment.dart';

class MealCreateFragment extends StatefulWidget {
  @override
  _MealCreateFragmentState createState() => _MealCreateFragmentState();
}

class _MealCreateFragmentState extends State<MealCreateFragment> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ptDatesFuture = initializeDateFormatting('pt', null);
  final dateFormat = new DateFormat('dd/MM/yyyy');
  final _types = [
    MealType('P', 'Pequeno-almoço', Color(0xFFFFAEBC)),
    MealType('M', 'Meio da manhã', Color(0xFFC7CEEA)),
    MealType('A', 'Almoço', Color(0xFFA0E7E5)),
    MealType('L', 'Lanche', Color(0xFFFFDAC1)),
    MealType('J', 'Jantar', Color(0xFFC9E0EC)),
    MealType('O', 'Ceia', Color(0xFFffd5cd)),
    MealType('S', 'Snack', Color(0xFFCCDDC0)),
  ];
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Nova Refeição",
          style: TextStyle(
            fontFamily: 'Pacifico',
          ),
        ),
        backgroundColor: Color(0xFF74D44D),
      ),
      body: Container(
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
      list.add(
        Padding(
          padding: const EdgeInsets.only(top: 32.0, left: 32, right: 32),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              child: Padding(
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                child: Text(
                  element.name,
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 15.0,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              color: element.color,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(25.0),
              ),
              onPressed: () {
                _showDateTimeModal(element.type);
              },
            ),
          ),
        ),
      );
    });
    return list;
  }

  Future<void> _showDateTimeModal(type) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Data / Hora da Refeição'),
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
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Data',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.grey),
                      ),
                      FlatButton(
                        color: Colors.transparent,
                        splashColor: Colors.black26,
                        onPressed: () => _selectDate(context, 'DATE'),
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
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Hora',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.grey),
                      ),
                      FlatButton(
                        color: Colors.transparent,
                        splashColor: Colors.black26,
                        onPressed: () => _selectDate(context, 'TIME'),
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
                child: Text('Ok'),
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

  void _selectDate(BuildContext context, String type) async {
    final ThemeData themeData = Theme.of(context);
    assert(themeData.platform != null);

    switch (themeData.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context, type);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context, type);
    }
  }

  void buildMaterialDatePicker(BuildContext context, String type) async {
    if (type == 'TIME') {
      final pickedTime =
          await showTimePicker(context: context, initialTime: _time);

      if (pickedTime != null && pickedTime != _time) {
        setState(() {
          _time = pickedTime;
        });
      }

      return;
    }

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      cancelText: 'Cancelar',
      fieldLabelText: 'Data da Refeição',
    );

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void buildCupertinoDatePicker(BuildContext context, String type) async {
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
                  setState(() {
                    _date = picked;
                  });

                if (type == 'TIME' && picked != null && picked != _time)
                  setState(() {
                    _time = TimeOfDay(hour: picked.hour, minute: picked.minute);
                  });
              },
              initialDateTime: type == 'TIME'
                  ? DateTime(1969, 1, 1, _time.hour, _time.minute)
                  : _date,
              minimumYear: 2000,
              maximumYear: 2025,
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
  Color color;

  MealType(type, name, color) {
    this.type = type;
    this.name = name;
    this.color = color;
  }
}
