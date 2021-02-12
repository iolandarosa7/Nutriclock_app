import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';

class ExerciseFragment extends StatefulWidget {
  final dynamic value;

  ExerciseFragment({Key key, @required this.value}) : super(key: key);

  @override
  _ExerciseFragmentState createState() => _ExerciseFragmentState();
}

class _ExerciseFragmentState extends State<ExerciseFragment> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var appWidget = AppWidget();
  final dateFormat = new DateFormat('dd/MM/yyyy');
  TimeOfDay _wakeUpTime = TimeOfDay.now();
  TimeOfDay _endUpTime = TimeOfDay.now();
  final TextEditingController _typeAheadController = TextEditingController();
  var _autocompleteSuggestions = [];
  var _isLoading = false;
  var _name;
  var _duration = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appWidget.getAppbar("Exercício Física"),
      body: appWidget.getImageContainer(
        "assets/images/bg_exercise.jpg",
        _isLoading,
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Card(
            elevation: 4.0,
            color: Colors.white,
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _typeAheadController,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFA3E1CB)),
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Color(0xFFA3E1CB),
                          ),
                          hintText: "Pesquisar...",
                          labelText: 'Atividade Física',
                          labelStyle: TextStyle(color: Colors.grey),
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
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (suggestion) {
                        this._typeAheadController.text = suggestion;
                      },
                      suggestionsCallback: (pattern) {
                        var list = [];
                        var size = 0;
                        _autocompleteSuggestions.forEach((element) {
                          if (size <= 20 &&
                              element
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(pattern)) {
                            list.add(element);
                            size++;
                          }
                        });
                        return list;
                      },
                      validator: (value) {
                        _name = value;
                        return null;
                      },
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
                          child: FlatButton(
                            color: Colors.transparent,
                            splashColor: Colors.black26,
                            onPressed: () => _selectDate(context, false),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "${_wakeUpTime.hour}:${_wakeUpTime.minute > 9 ? _wakeUpTime.minute : "0${_wakeUpTime.minute}"}",
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 15,
                                ),
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
                              'Hora de fim',
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: FlatButton(
                            color: Colors.transparent,
                            splashColor: Colors.black26,
                            onPressed: () => _selectDate(context, true),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "${_endUpTime.hour}:${_endUpTime.minute > 9 ? _endUpTime.minute : "0${_endUpTime.minute}"}",
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
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
                              'Total',
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: FlatButton(
                            color: Colors.transparent,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "${_duration}",
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 15,
                                ),
                              ),
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
                      child: FlatButton(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 8, bottom: 8, left: 10, right: 10),
                          child: Text(
                            _isLoading ? 'Aguarde...' : 'Guardar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        color: Color(0xFFA3E1CB),
                        disabledColor: Colors.grey,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                        onPressed: () {
                          if (_wakeUpTime == _endUpTime) {
                            appWidget.showSnackbar(
                                "A hora de início e fim devem ser diferentes",
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
          ),
        ),
      ),
    );
  }

  void _registerExercise() {}

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
