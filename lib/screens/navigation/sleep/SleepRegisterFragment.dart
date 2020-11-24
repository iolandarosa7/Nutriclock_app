import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

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
  var _myActivities = [];
  var _myMotives = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Horas de Sono",
          style: TextStyle(
            fontFamily: 'Pacifico',
          ),
        ),
        backgroundColor: Color(0xFF74D44D),
      ),
      body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x9074D44D), Color(0x20FFFFFF)]),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
                child: Text(
                  dateFormat.format(widget.value),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              Stack(
                children: [
                  Positioned(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height - 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 2.0,
                                spreadRadius: 0.4,
                                offset: Offset(0.1, 0.5)),
                          ],
                          color: Colors.white),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 16.0),
                                      child: Text(
                                        'Horários',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15),
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
                                        padding: EdgeInsets.only(left: 40.0),
                                        child: Text(
                                          'Hora de deitar',
                                          textAlign: TextAlign.left,
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: FlatButton(
                                        color: Colors.transparent,
                                        splashColor: Colors.black26,
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
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 40.0),
                                        child: Text(
                                          'Hora de levantar',
                                          textAlign: TextAlign.left,
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: FlatButton(
                                        color: Colors.transparent,
                                        splashColor: Colors.black26,
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
                                        color: Colors.grey,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          'Acordou durante a noite?',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 15),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 40.0),
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
                                                  color: Colors.grey,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16.0),
                                                  child: Text(
                                                    'O que fez antes de se deitar?',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 40, right: 20),
                                            child: MultiSelectFormField(
                                              autovalidate: false,
                                              title: Text(
                                                'Atividades',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              dataSource: [
                                                {
                                                  "display":
                                                      "Beber bebidas alcoólica",
                                                  "value": "alcohol",
                                                },
                                                {
                                                  "display":
                                                      "Beber bebidas com cafeína",
                                                  "value": "coffee",
                                                },
                                                {
                                                  "display":
                                                      "Comer refeição pesada",
                                                  "value": "meal",
                                                },
                                                {
                                                  "display":
                                                      "Comeu doces / açúcares",
                                                  "value": "sugars",
                                                },
                                                {
                                                  "display": "Estudar",
                                                  "value": "study",
                                                },
                                                {
                                                  "display":
                                                      "Praticar exercício físico",
                                                  "value": "exercise",
                                                },
                                                {
                                                  "display": "Fumar",
                                                  "value": "smoke",
                                                },
                                                {
                                                  "display":
                                                      "Olhar para ecrã de smartphone, PC ou similar",
                                                  "value": "screen",
                                                },
                                                {
                                                  "display": "Ver televisão",
                                                  "value": "tv",
                                                },
                                                {
                                                  "display": "Ler",
                                                  "value": "read",
                                                },
                                                {
                                                  "display": "Outra",
                                                  "value": "another",
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
                                                print(value);
                                                setState(() {
                                                  _myActivities = value;
                                                });
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.list,
                                                  color: Colors.grey,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16.0),
                                                  child: Text(
                                                    'Outros motivos que podem influenciar...',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 40, right: 20),
                                            child: MultiSelectFormField(
                                              autovalidate: false,
                                              title: Text(
                                                'Motivos',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              dataSource: [
                                                {
                                                  "display": "Dores",
                                                  "value": "pain",
                                                },
                                                {
                                                  "display": "Medicação",
                                                  "value": "medication",
                                                },
                                                {
                                                  "display": "Insónia",
                                                  "value": "insomnia",
                                                },
                                                {
                                                  "display": "Barulho",
                                                  "value": "noise",
                                                },
                                                {
                                                  "display": "Pesadelo",
                                                  "value": "dream",
                                                },
                                                {
                                                  "display": "Claridade",
                                                  "value": "light",
                                                },
                                                {
                                                  "display": "Stress",
                                                  "value": "stress",
                                                },
                                                {
                                                  "display": "Outra",
                                                  "value": "another",
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
                                                print(value);
                                                setState(() {
                                                  _myMotives = value;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(""),
                                SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: FlatButton(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                          left: 10,
                                          right: 10),
                                      child: Text(
                                        _isLoading ? 'Aguarde...' : 'Confirmar',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    color: Color(0xFFA3DC92),
                                    disabledColor: Colors.grey,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(20.0)),
                                    onPressed: () {
                                      _registerSleep();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  void _registerSleep() {}

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
    final pickedTime =
        await showTimePicker(context: context, initialTime: time);

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
