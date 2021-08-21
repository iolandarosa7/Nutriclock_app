import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/StaticExerciseHousehold.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';
import 'package:nutriclock_app/utils/DropMenu.dart';

class ExerciseFragment extends StatefulWidget {
  final dynamic value;

  ExerciseFragment({Key key, @required this.value}) : super(key: key);

  @override
  _ExerciseFragmentState createState() => _ExerciseFragmentState();
}

class _ExerciseFragmentState extends State<ExerciseFragment> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<StaticExerciseHousehold> _exercises = [];
  List<StaticExerciseHousehold> _households = [];
  var appWidget = AppWidget();
  final dateFormat = new DateFormat('dd/MM/yyyy');
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  final TextEditingController _typeAheadController = TextEditingController();
  var _isLoading = false;
  var _name;
  var _type;
  List<DropMenu> _activitiesList = [
    DropMenu('H', 'Domésticas'),
    DropMenu('E', 'Desportivas')
  ];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    List<StaticExerciseHousehold> staticExercises = [];
    List<StaticExerciseHousehold> staticHouseholds = [];
    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    try {
      var responseExercises = await Network().getWithAuth(EXERCISES_LIST_URL);
      if (responseExercises.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data = json.decode(responseExercises.body)[JSON_DATA_KEY];
        data.forEach((element) {
          StaticExerciseHousehold value =
              StaticExerciseHousehold.fromJson(element);
          staticExercises.add(value);
        });

        this.setState(() {
          _exercises = staticExercises;
        });
      }
    } catch (error) {}

    try {
      var responseHouseholds = await Network().getWithAuth(HOUSEHOLDS_URL);
      if (responseHouseholds.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data =
            json.decode(responseHouseholds.body)[JSON_DATA_KEY];
        data.forEach((element) {
          StaticExerciseHousehold value =
              StaticExerciseHousehold.fromJson(element);
          staticHouseholds.add(value);
        });

        this.setState(() {
          _households = staticHouseholds;
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
      key: _scaffoldKey,
      appBar: appWidget.getAppbar("Atividade Física"),
      body: appWidget.getImageContainer(
        "assets/images/bg_green_gradient.png",
        _isLoading,
        Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Image.asset(
                  'assets/images/sport_man.png',
                  height: MediaQuery.of(context).size.height / 4,
                ),
              ),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: (Card(
                    elevation: 4.0,
                    color: Colors.white,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Image(
                                  image: AssetImage("assets/images/nutri.png"),
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
                              height: 15,
                            ),
                            Stack(
                              children: <Widget>[
                                DropdownButton(
                                  value: _type,
                                  hint: Padding(
                                    padding: const EdgeInsets.only(left: 50),
                                    child: Text(
                                      "Tipo de Atividade",
                                      style: TextStyle(
                                          color: Color(0xFF9b9b9b),
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: Color(0xFFA3E1CB)),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _type = newValue;
                                    });
                                  },
                                  isExpanded: true,
                                  items: _activitiesList
                                      .map<DropdownMenuItem<String>>(
                                          (DropMenu item) {
                                    return DropdownMenuItem<String>(
                                      value: item.value,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50),
                                        child: Text(item.description),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    child: Icon(
                                      Icons.sports_handball_sharp,
                                      color: Color(0xFFA3E1CB),
                                    )),
                              ],
                            ),
                            _type == 'E'
                                ? TypeAheadFormField(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      controller: _typeAheadController,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFA3E1CB)),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search_rounded,
                                          color: Color(0xFFA3E1CB),
                                        ),
                                        hintText: "Pesquisar...",
                                        labelText: 'Nome',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(suggestion),
                                      );
                                    },
                                    transitionBuilder:
                                        (context, suggestionsBox, controller) {
                                      return suggestionsBox;
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      this._typeAheadController.text =
                                          suggestion;
                                    },
                                    suggestionsCallback: (pattern) {
                                      var list = [];
                                      var size = 0;
                                      _exercises.forEach((element) {
                                        if (size <= 20 &&
                                            element.name
                                                .toString()
                                                .toLowerCase()
                                                .startsWith(pattern)) {
                                          list.add(element.name);
                                          size++;
                                        }
                                      });
                                      return list;
                                    },
                                    validator: (value) {
                                      _name = value;
                                      return null;
                                    },
                                  )
                                : SizedBox(),
                            _type == 'H'
                                ? TypeAheadFormField(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      controller: _typeAheadController,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFA3E1CB)),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search_rounded,
                                          color: Color(0xFFA3E1CB),
                                        ),
                                        hintText: "Pesquisar...",
                                        labelText: 'Nome',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(suggestion),
                                      );
                                    },
                                    transitionBuilder:
                                        (context, suggestionsBox, controller) {
                                      return suggestionsBox;
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      this._typeAheadController.text =
                                          suggestion;
                                    },
                                    suggestionsCallback: (pattern) {
                                      var list = [];
                                      var size = 0;
                                      _households.forEach((element) {
                                        if (size <= 20 &&
                                            element.name
                                                .toString()
                                                .toLowerCase()
                                                .contains(pattern)) {
                                          list.add(element.name);
                                          size++;
                                        }
                                      });
                                      return list;
                                    },
                                    validator: (value) {
                                      _name = value;
                                      return null;
                                    },
                                  )
                                : SizedBox(),
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
                                    'Duração do Exercício',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color(0xFFA3E1CB), fontSize: 15),
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
                                      'Hora de início',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: TextButton(
                                    onPressed: () => _selectDate(context, true),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${_startTime.hour}:${_startTime.minute > 9 ? _startTime.minute : "0${_startTime.minute}"}",
                                        style: TextStyle(
                                          color: Color(0xFF000000),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                        backgroundColor: Color(0x50A3E1CB)
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
                                      'Hora de fim',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: TextButton(
                                    onPressed: () =>
                                        _selectDate(context, false),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${_endTime.hour}:${_endTime.minute > 9 ? _endTime.minute : "0${_endTime.minute}"}",
                                        style: TextStyle(
                                          color: Color(0xFF000000),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                        backgroundColor: Color(0x50A3E1CB)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                child: Text(
                                  _isLoading ? 'Aguarde...' : 'Guardar',
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
                                  if (!_formKey.currentState.validate() ||
                                      _name == null ||
                                      _name.trim() == "" ||
                                      _type == null) {
                                    appWidget.showSnackbar(
                                        "Todos os campos são obrigatórios",
                                        Colors.red,
                                        _scaffoldKey);
                                    return;
                                  }

                                  if (_startTime == _endTime) {
                                    appWidget.showSnackbar(
                                        "A hora de início e fim devem ser diferentes",
                                        Colors.red,
                                        _scaffoldKey);
                                    return;
                                  }

                                  if (_calculateTime(_startTime) > _calculateTime(_endTime)) {
                                    appWidget.showSnackbar(
                                        "A hora de início deve ser inferior à hora de fim",
                                        Colors.red,
                                        _scaffoldKey);
                                    return;
                                  }
                                  _registerExercise();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerExercise() async {
    var isShowMessage = false;
    var message = "Ocorreu um erro ao registar o exercicio";
    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network().postWithAuth({
        'name': _name,
        'startTime': _convertToMillis(_startTime.hour, _startTime.minute),
        'endTime': _convertToMillis(_endTime.hour, _endTime.minute),
        'date': widget.value.toIso8601String(),
        'type': _type,
      }, EXERCISES_URL);

      var body = json.decode(response.body);

      if (response.statusCode == RESPONSE_SUCCESS_201) {
        appWidget.showSnackbar(
            "A atividade foi registada. Pode adicionar mais na mesma data ou voltar ao ecra anterior",
            Colors.green,
            _scaffoldKey);
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
      _name = '';
      _type = null;
    });
  }

  int _convertToMillis(hour, min) {
    return hour * 3600000 + min * 60000;
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
    var time = isWakeUp ? _startTime : _endTime;
    final pickedTime = await showTimePicker(
        context: context,
        initialTime: time,
        helpText: "Seleciona a hora:",
        cancelText: "Cancelar");

    if (pickedTime != null && pickedTime != time && _calculateTime(pickedTime) < _calculateTime(TimeOfDay.now())) {
      if (isWakeUp) {
        setState(() {
          _startTime = pickedTime;
        });
        return;
      }

      setState(() {
        _endTime = pickedTime;
      });
    }
  }
  
  _calculateTime(TimeOfDay time) {
    return time.hour.toDouble() +
        (time.minute.toDouble() / 60);
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
                    _startTime =
                        TimeOfDay(hour: picked.hour, minute: picked.minute);
                  });
                  return;
                }
                setState(() {
                  _endTime =
                      TimeOfDay(hour: picked.hour, minute: picked.minute);
                });
              },
              initialDateTime:
                  DateTime(1969, 1, 1, _startTime.hour, _startTime.minute),
              use24hFormat: true,
              minuteInterval: 1,
            ),
          );
        });
  }
}
