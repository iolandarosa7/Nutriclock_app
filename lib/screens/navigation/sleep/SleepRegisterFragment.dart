import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';

class SleepRegisterFragment extends StatefulWidget {
  final dynamic value;

  SleepRegisterFragment({Key key, @required this.value}) : super(key: key);

  @override
  _SleepRegisterFragmentState createState() => _SleepRegisterFragmentState();
}

class _SleepRegisterFragmentState extends State<SleepRegisterFragment> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _isLoading = false;
  final ptDatesFuture = initializeDateFormatting('pt', null);
  final dateFormat = new DateFormat('dd/MM/yyyy');
  TimeOfDay _wakeUpTime = TimeOfDay.now();
  TimeOfDay _endUpTime = TimeOfDay.now();
  var _hasWakeUp = false;
  List<dynamic> _myActivities = [];
  List<dynamic> _myMotives = [];
  var appWidget = AppWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appWidget.getAppbar("Horas de Sono"),
      body: appWidget.getImageContainer(
        "assets/images/bg_sleep.jpg",
        _isLoading,
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(children: [
            Positioned(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 4.0,
                        color: Colors.white,
                        margin: EdgeInsets.only(left: 8.0, right: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 20, left: 16, right: 8),
                            child: Form(
                              key: _formKey,
                              child: Column(children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Image(
                                      image:
                                          AssetImage("assets/images/nutri.png"),
                                      height: 45,
                                    ),
                                    Text(
                                      dateFormat.format(widget.value),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFF60B2A3),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: Color(0xFFA3E1CB),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Horários',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(0xFFA3E1CB),
                                            fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 32.0),
                                        child: Text(
                                          'Hora de deitar da véspera',
                                          textAlign: TextAlign.left,
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: TextButton(
                                        onPressed: () =>
                                            _selectDate(context, false),
                                        child: Text(
                                          "${_endUpTime.hour}:${_endUpTime.minute > 9 ? _endUpTime.minute : "0${_endUpTime.minute}"}",
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 32.0),
                                        child: Text(
                                          'Hora de levantar de hoje',
                                          textAlign: TextAlign.left,
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: TextButton(
                                        onPressed: () =>
                                            _selectDate(context, true),
                                        child: Text(
                                          "${_wakeUpTime.hour}:${_wakeUpTime.minute > 9 ? _wakeUpTime.minute : "0${_wakeUpTime.minute}"}",
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.bedtime_outlined,
                                        color: Color(0xFFA3E1CB),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Acordou durante a noite?',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Color(0xFFA3E1CB),
                                              fontSize: 15),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 32.0),
                                      child: Text(
                                        'Sim',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Radio(
                                      value: true,
                                      groupValue: _hasWakeUp,
                                      onChanged: (value) => {
                                        this.setState(() {
                                          _hasWakeUp = value;
                                        }),
                                      },
                                      activeColor: Color(0xFFA3E1CB),
                                    ),
                                    Text(
                                      "Não",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Radio(
                                      value: false,
                                      groupValue: _hasWakeUp,
                                      onChanged: (value) => {
                                        this.setState(() {
                                          _hasWakeUp = value;
                                        }),
                                      },
                                      activeColor: Color(0xFFA3E1CB),
                                    ),
                                  ],
                                ),
                                _hasWakeUp
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.king_bed_outlined,
                                                  color: Color(0xFFA3E1CB),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.0),
                                                  child: Text(
                                                    'O que fez antes de se deitar?',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFA3E1CB),
                                                        fontSize: 15),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          MultiSelectFormField(
                                            autovalidate: false,
                                            title: Text(
                                              'Atividades',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            dataSource: [
                                              {
                                                "display":
                                                    "Beber bebidas alcoólicas",
                                                "value":
                                                    "Beber bebidas alcoólicas",
                                              },
                                              {
                                                "display":
                                                    "Beber bebidas com cafeína",
                                                "value":
                                                    "Beber bebidas com cafeína",
                                              },
                                              {
                                                "display":
                                                    "Comer refeição pesada",
                                                "value":
                                                    "Comer refeição pesada",
                                              },
                                              {
                                                "display":
                                                    "Comer doces / açúcares",
                                                "value":
                                                    "Comer doces / açúcares",
                                              },
                                              {
                                                "display":
                                                    "Estudar / Trabalhar",
                                                "value": "Estudar / Trabalhar",
                                              },
                                              {
                                                "display":
                                                    "Praticar exercício físico",
                                                "value":
                                                    "Praticar exercício físico",
                                              },
                                              {
                                                "display": "Fumar",
                                                "value": "Fumar",
                                              },
                                              {
                                                "display":
                                                    "Olhar para ecrã de smartphone, PC ou similar",
                                                "value":
                                                    "Olhar para ecrã de smartphone, PC ou similar",
                                              },
                                              {
                                                "display": "Ver televisão",
                                                "value": "Ver televisão",
                                              },
                                              {
                                                "display": "Ler",
                                                "value": "Ler",
                                              },
                                              {
                                                "display": "Outra(s)",
                                                "value": "Outra(s)",
                                              },
                                            ],
                                            textField: 'display',
                                            valueField: 'value',
                                            okButtonLabel: 'Confirmar',
                                            cancelButtonLabel: 'Cancelar',
                                            hintWidget: Text(
                                                'Escolha uma ou mais opções'),
                                            initialValue: _myActivities,
                                            onSaved: (value) {
                                              if (value == null) return;
                                              setState(() {
                                                _myActivities = value;
                                              });
                                            },
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.list,
                                                  color: Color(0xFFA3E1CB),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.0),
                                                  child: Text(
                                                    'Outros motivos para ter acordado',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFA3E1CB),
                                                        fontSize: 15),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          MultiSelectFormField(
                                            autovalidate: false,
                                            title: Text(
                                              'Motivos',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            dataSource: [
                                              {
                                                "display": "Dores",
                                                "value": "Dores",
                                              },
                                              {
                                                "display": "Medicação",
                                                "value": "Medicação",
                                              },
                                              {
                                                "display": "Insónia",
                                                "value": "Insónia",
                                              },
                                              {
                                                "display": "Barulho",
                                                "value": "Barulho",
                                              },
                                              {
                                                "display": "Pesadelo",
                                                "value": "Pesadelo",
                                              },
                                              {
                                                "display": "Claridade",
                                                "value": "Claridade",
                                              },
                                              {
                                                "display": "Stress",
                                                "value": "Stress",
                                              },
                                              {
                                                "display": "Outra(s)",
                                                "value": "Outra(s)",
                                              },
                                              {
                                                "display": "Nenhum",
                                                "value": "Nenhum",
                                              },
                                            ],
                                            textField: 'display',
                                            valueField: 'value',
                                            okButtonLabel: 'Confirmar',
                                            cancelButtonLabel: 'Cancelar',
                                            hintWidget: Text(
                                                'Escolha uma ou mais opções'),
                                            initialValue: _myMotives,
                                            onSaved: (value) {
                                              if (value == null) return;
                                              setState(() {
                                                _myMotives = value;
                                              });
                                            },
                                          ),
                                        ],
                                      )
                                    : Text(""),
                                SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    child: Text(
                                      _isLoading ? 'Aguarde...' : 'Confirmar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Color(0xFFA3E1CB),
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_wakeUpTime == _endUpTime) {
                                        appWidget.showSnackbar(
                                            "A hora de deitar e levantar devem ser diferentes",
                                            Colors.red,
                                            _scaffoldKey);
                                        return;
                                      }
                                      _registerSleep();
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  )),
            ),
          ]),
        ),
      ),
    );
  }

  void _registerSleep() async {
    var isShowMessage = false;
    var message = "Ocorreu um erro ao registar o sono";
    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network().postWithAuth({
        'date': dateFormat.format(widget.value),
        'wakeUpTime':
            "${_parseTwoNumber(_wakeUpTime.hour)}:${_parseTwoNumber(_wakeUpTime.minute)}",
        'sleepTime':
            "${_parseTwoNumber(_endUpTime.hour)}:${_parseTwoNumber(_endUpTime.minute)}",
        'hasWakeUp': _hasWakeUp,
        'activities': _myActivities,
        'motives': _myMotives
      }, SLEEP_URL);

      print({
        'date': dateFormat.format(widget.value),
        'wakeUpTime':
            "${_parseTwoNumber(_wakeUpTime.hour)}:${_parseTwoNumber(_wakeUpTime.minute)}",
        'sleepTime':
            "${_parseTwoNumber(_endUpTime.hour)}:${_parseTwoNumber(_endUpTime.minute)}",
        'hasWakeUp': _hasWakeUp,
        'activities': _myActivities,
        'motives': _myMotives
      });

      var body = json.decode(response.body);

      if (response.statusCode == RESPONSE_SUCCESS_201) {
        Navigator.of(context).pop();
        appWidget.showSnackbar(
            "Registado com sucesso!", Colors.green, _scaffoldKey);
      } else {
        isShowMessage = true;
        if (body[JSON_ERROR_KEY] != null) message = (body[JSON_ERROR_KEY]);
      }
    } catch (error) {
      isShowMessage = true;
    }

    if (isShowMessage)
      appWidget.showSnackbar(message, Colors.red, _scaffoldKey);

    setState(() {
      _isLoading = false;
    });
  }

  _parseTwoNumber(value) {
    if (value > 9)
      return "$value";
    else
      return "0$value";
  }

  // show datepicker
  void _selectDate(BuildContext context, bool isWakeUp) async {
    final ThemeData themeData = Theme.of(context);
    assert(themeData.platform != null);

    switch (themeData.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context, isWakeUp);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context, isWakeUp);
    }
  }

  void buildMaterialDatePicker(BuildContext context, bool isWakeUp) async {
    var time = isWakeUp ? _wakeUpTime : _endUpTime;
    final pickedTime = await showTimePicker(
        context: context,
        initialTime: time,
        helpText: "Seleciona a hora:",
        cancelText: "Cancelar");

    if (pickedTime != null && pickedTime != time) {
      if (isWakeUp) {
        setState(() {
          _wakeUpTime = pickedTime;
        });
        return;
      }

      setState(() {
        _endUpTime = pickedTime;
      });
    }
  }

  void buildCupertinoDatePicker(BuildContext context, bool isWakeUp) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: (picked) {
                if (picked != null) if (isWakeUp) {
                  setState(() {
                    _wakeUpTime =
                        TimeOfDay(hour: picked.hour, minute: picked.minute);
                  });
                  return;
                }
                setState(() {
                  _endUpTime =
                      TimeOfDay(hour: picked.hour, minute: picked.minute);
                });
              },
              initialDateTime:
                  DateTime(1969, 1, 1, _wakeUpTime.hour, _wakeUpTime.minute),
              use24hFormat: true,
              minuteInterval: 1,
            ),
          );
        });
  }
}
