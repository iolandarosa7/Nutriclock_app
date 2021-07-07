import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Ingredient.dart';
import 'package:nutriclock_app/models/MealPlan.dart';
import 'package:nutriclock_app/models/MealPlanType.dart';
import 'package:nutriclock_app/models/WeekDay.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';

class FoodPlanFragment extends StatefulWidget {
  @override
  _FoodPlanFragmentState createState() => _FoodPlanFragmentState();
}

class _FoodPlanFragmentState extends State<FoodPlanFragment> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _selectedDayIndex = 0;
  final picker = ImagePicker();
  File _photo;
  List<WeekDay> _weekDates = [
    WeekDay('SEG'),
    WeekDay('TER'),
    WeekDay('QUA'),
    WeekDay('QUI'),
    WeekDay('SEX'),
    WeekDay('SAB'),
    WeekDay('DOM'),
  ];
  List<MealPlanType> _meals = [];
  List<MealPlan> _history = [];
  var _isLoading = false;
  TimeOfDay _time = TimeOfDay.now();

  @override
  void initState() {
    _populateWeek();
    _getMealsByDate(_weekDates[_selectedDayIndex].date);
    _getHistoryFromDate(_weekDates[0].date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFA3E1CB),
        appBar: AppWidget().getAppbar("Plano Alimentar"),
        body: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      icon: const Icon(Icons.restaurant_menu_rounded),
                      text: 'Semanal',
                    ),
                    Tab(
                      icon: const Icon(Icons.history),
                      text: 'Histórico',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(
                    children: [_renderWeeklyPlan(), _renderHistoryPlan()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderWeeklyPlan() {
    return Container(
      color: Color(0xFFE2E2E2),
      padding: EdgeInsets.only(top: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _renderDaysOfWeek(),
                ),
              ),
            ),
            _isLoading == true
                ? Center(
                    child: Loading(
                        indicator: BallPulseIndicator(),
                        size: 50.0,
                        color: Color(0xFFFFBCBC)),
                  )
                : SizedBox(),
            ..._renderMeals(_meals, false)
          ],
        ),
      ),
    );
  }

  List<Widget> _renderMeals(List<MealPlanType> meals, bool isHistory) {
    List<Widget> list = [];
    if (meals == null || meals.length == 0)
      list.add(Padding(
        padding: EdgeInsets.only(top: 20),
        child: Center(
          child: Text("Não tem plano"),
        ),
      ));

    meals.forEach((element) {
      list.add(
        Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Container(
              color: Colors.white,
              child: Padding(
                  padding:
                      EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFA3E1CB),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _getFirstLetterFromName(element.type),
                                style: TextStyle(
                                    color: Color(0xFFA3E1CB),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_renderType(element.type)),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.schedule,
                                        color: Color(0xFFCFCECE),
                                      ),
                                      Text(
                                        element.hour,
                                        style: TextStyle(
                                          color: Color(0xFFCFCECE),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Icon(
                                        Icons.people,
                                        color: Color(0xFFCFCECE),
                                      ),
                                      Text(
                                        _renderPortion(element.portion),
                                        style: TextStyle(
                                          color: Color(0xFFCFCECE),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: element.opened
                                ? IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Color(0xFFA3E1CB),
                                    ),
                                    tooltip: 'Fechar detalhes',
                                    onPressed: () {
                                      element.opened = false;
                                      setState(() {
                                        _meals = _meals;
                                      });
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xFFA3E1CB),
                                    ),
                                    tooltip: 'Abrir detalhes',
                                    onPressed: () {
                                      element.opened = true;
                                      setState(() {
                                        _meals = _meals;
                                      });
                                    },
                                  ),
                          ),
                        ],
                      ),
                      if (!isHistory)
                        TextButton.icon(
                          label: Text(
                            element.confirmed ? 'Confirmar' : 'Confirmado',
                            style: TextStyle(
                              color: Color(0xFFA3E1CB),
                              fontSize: 15.0,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          icon: Icon(
                            Icons.check,
                            color: Color(0xFFA3E1CB),
                          ),
                          style: TextButton.styleFrom(
                            side: BorderSide(
                              color: Color(0xFFA3E1CB),
                              width: 1,
                            ),
                          ),
                          onPressed: () {
                            _showPhotoTimeModal(element);
                          },
                        ),
                    ],
                  )),
            ),
            Column(
              children: [
                element.opened && element.ingredients != null
                    ? _renderIngredients(element.ingredients)
                    : SizedBox()
              ],
            )
          ],
        ),
      );
    });
    return list;
  }

  Widget _renderIngredients(List<Ingredient> ingredients) {
    List<Widget> list = [];
    ingredients.forEach((element) {
      list.add(
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Color(0xFFA3E1CB),
                      width: 8,
                    ),
                  ),
                  color: Color(0xFFECECEC),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.room_service),
                          SizedBox(
                            width: 4,
                          ),
                          Flexible(
                            child: Text(element.name),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text("${element.quantity} ${element.unit}"),
                      Text(element.description == null
                          ? ""
                          : element.description),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              )
            ],
          ),
        ),
      );
    });
    return Column(
      children: list,
    );
  }

  List<Widget> _renderDaysOfWeek() {
    List<Widget> list = [];

    for (var i = 0; i < _weekDates.length; i++) {
      list.add(
        GestureDetector(
          onTap: () => {
            this.setState(() {
              _selectedDayIndex = i;
              _getMealsByDate(_weekDates[i].date);
            }),
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFA3E1CB),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                  color: this._selectedDayIndex == i
                      ? Color(0xFFA3E1CB)
                      : Colors.white),
              child: Center(
                child: Text(
                  _weekDates[i].name,
                  style: TextStyle(
                    color: this._selectedDayIndex == i
                        ? Colors.white
                        : Color(0xFFA3E1CB),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return list;
  }

  Widget _renderHistoryPlan() {
    return Container(
      color: Color(0xFFE2E2E2),
      padding: EdgeInsets.only(top: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: _renderHistory(),
        ),
      ),
    );
  }

  List<Widget> _renderHistory() {
    List<Widget> list = [];
    if (_history == null || _history.length == 0)
      list.add(Padding(
        padding: EdgeInsets.only(top: 20),
        child: Center(
          child: Text("Não existem dados no histórico"),
        ),
      ));

    _history.forEach((element) {
      list.add(
        Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFA3E1CB),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(40),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.calendar_today,
                          color: Color(0xFFA3E1CB),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_renderDate(element.dayOfWeek, element.date)),
                            SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: element.opened
                          ? IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Color(0xFFA3E1CB),
                              ),
                              tooltip: 'Fechar detalhes',
                              onPressed: () {
                                element.opened = false;
                                setState(() {
                                  _meals = _meals;
                                });
                              },
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFFA3E1CB),
                              ),
                              tooltip: 'Abrir detalhes',
                              onPressed: () {
                                element.opened = true;
                                setState(() {
                                  _meals = _meals;
                                });
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: element.opened && element.mealTypes != null
                  ? _renderMeals(element.mealTypes, true)
                  : [SizedBox()],
            )
          ],
        ),
      );
    });

    return list;
  }

  _getFirstLetterFromName(type) {
    switch (type) {
      case 'O':
        return 'C';
      default:
        return type;
    }
  }

  _renderType(type) {
    switch (type) {
      case 'P':
        return 'Pequeno-almoço';
      case 'A':
        return 'Almoço';
      case 'J':
        return 'Jantar';
      case 'S':
        return 'Snacks';
      case 'O':
        return 'Ceia';
      case 'L':
        return 'Lanche';
      default:
        return 'Meio da manhã';
    }
  }

  _renderPortion(portion) {
    if (portion > 1) return "$portion porções";
    return "$portion porção";
  }

  _renderDate(dayOfWeek, date) {
    var d = 'Domingo';
    switch (dayOfWeek) {
      case 'MON':
        d = 'Segunda-feira';
        break;
      case 'TUE':
        d = 'Terça-feira';
        break;
      case 'WED':
        d = 'Quarta-feira';
        break;
      case 'THU':
        d = 'Quinta-feira';
        break;
      case 'FRI':
        d = 'Sexta-feira';
        break;
      case 'SAT':
        d = 'Sábado';
        break;
      default:
        d = 'Domingo';
    }

    return "$d, $date";
  }

  _populateWeek() {
    List<WeekDay> weeks = _weekDates;
    DateTime date = DateTime.now();
    var auxDate = DateTime(date.year, date.month, date.day + 1);
    int dayIndex = _getSelectedIndexByDay(DateFormat('E').format(date));
    int auxDayIndex = dayIndex + 1;
    String currentDateString = DateFormat('dd-MM-yyyy').format(date);
    String currentAuxDateString = DateFormat('dd-MM-yyyy').format(auxDate);
    setState(() {
      _selectedDayIndex = dayIndex;
    });

    while (dayIndex >= 0) {
      weeks[dayIndex].date = currentDateString;
      dayIndex--;
      date = DateTime(date.year, date.month, date.day - 1);
      currentDateString = DateFormat('dd-MM-yyyy').format(date);
    }

    while (auxDayIndex <= 6) {
      weeks[auxDayIndex].date = currentAuxDateString;
      auxDate = DateTime(auxDate.year, auxDate.month, auxDate.day + 1);
      auxDayIndex++;
      currentAuxDateString = DateFormat('dd-MM-yyyy').format(auxDate);
    }

    setState(() {
      _weekDates = weeks;
    });
  }

  _getMealsByDate(String date) async {
    List<MealPlanType> meals = [];

    if (_isLoading) return;

    this.setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network().getWithAuthParam(MEAL_PLAN_TYPE_URL, date);

      if (response.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];

        data.forEach((element) {
          MealPlanType m = MealPlanType.fromJson(element);
          List<Ingredient> ingredients = [];
          m.ingredients.forEach((i) {
            Ingredient ing = Ingredient.fromJson(i);
            ingredients.add(ing);
          });
          m.ingredients = ingredients;
          meals.add(m);
        });
      }
    } catch (error) {
      print(error);
    }

    setState(() {
      _isLoading = false;
      _meals = meals;
    });
  }

  _getHistoryFromDate(String date) async {
    List<MealPlan> history = [];

    try {
      var response =
          await Network().getWithAuthParam(MEAL_PLAN_HISTORY_URL, date);

      if (response.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];
        List<MealPlanType> mealPlanTypes = [];
        data.forEach((element) {
          MealPlan m = MealPlan.fromJson(element);
          m.mealTypes.forEach((elementMealType) {
            MealPlanType mealPlanType = MealPlanType.fromJson(elementMealType);
            mealPlanTypes.add(mealPlanType);

            List<Ingredient> ingredients = [];
            mealPlanType.ingredients.forEach((i) {
              Ingredient ing = Ingredient.fromJson(i);
              ingredients.add(ing);
            });

            mealPlanType.ingredients = ingredients;
          });
          m.mealTypes = mealPlanTypes;
          history.add(m);
        });
      }
    } catch (error) {
      print(error);
    }

    setState(() {
      _history = history;
    });
  }

  _getSelectedIndexByDay(day) {
    switch (day) {
      case 'Mon':
        return 0;
      case 'Tue':
        return 1;
      case 'Wed':
        return 2;
      case 'Thu':
        return 3;
      case 'Fri':
        return 4;
      case 'Sat':
        return 5;
      default:
        return 6;
    }
  }

  Future<void> _showPhotoTimeModal(MealPlanType mealPlanType) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return AlertDialog(
            title: Text(
              'Hora e Foto da Refeição',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFA3E1CB)),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        style: TextStyle(
                          color: Color(0xFFA3E1CB),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _selectTime(context, setModalState),
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
                  TextButton.icon(
                    onPressed: () => {_showPicker(context)},
                    label: Text(
                      "Adicionar / Alterar Fotografia",
                      style: TextStyle(color: Color(0xFFA3E1CB)),
                    ),
                    icon: Icon(
                      Icons.restaurant,
                      color: Color(0xFFA3E1CB),
                    ),
                    style: TextButton.styleFrom(
                      side: BorderSide(
                        color: Color(0xFFA3E1CB),
                        width: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Ok',
                  style: TextStyle(color: Color(0xFF60B2A3)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _updateMealPlan(mealPlanType);
                },
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _updateMealPlan(MealPlanType mealPlanType) async {
    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    try {
      var t =
          "${_time.hour > 9 ? _time.hour : '0${_time.hour}'}:${_time.minute > 9 ? _time.minute : '0${_time.minute}'}";
      var response =
          await Network().postMealTypeConfirmation(t, _photo, mealPlanType.id);
      print(response.statusCode);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      this.setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectTime(BuildContext context, StateSetter setModalState) async {
    final ThemeData themeData = Theme.of(context);
    assert(themeData.platform != null);

    switch (themeData.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context, setModalState);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context, setModalState);
    }
  }

  void buildMaterialDatePicker(
      BuildContext context, StateSetter setModalState) async {
    final pickedTime = await showTimePicker(
        context: context,
        initialTime: _time,
        helpText: "Seleciona a hora:",
        cancelText: "Cancelar");

    if (pickedTime != null && pickedTime != _time) {
      setModalState(() {
        _time = pickedTime;
      });
    }
  }

  void buildCupertinoDatePicker(
      BuildContext context, StateSetter setModalState) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: (picked) {
                setModalState(() {
                  _time = TimeOfDay(hour: picked.hour, minute: picked.minute);
                });
              },
              initialDateTime: DateTime(1969, 1, 1, _time.hour, _time.minute),
              minimumYear: 1900,
              maximumDate: DateTime.now(),
              use24hFormat: true,
              minuteInterval: 1,
            ),
          );
        });
  }

  // show image picker
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galeria de Imagens'),
                      onTap: () {
                        getImage(ImageSource.gallery);
                        Navigator.pop(context);
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Câmara'),
                    onTap: () {
                      getImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      }
    });
  }
}
