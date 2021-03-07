import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutriclock_app/models/Ingredient.dart';
import 'package:nutriclock_app/models/MealPlanType.dart';
import 'package:nutriclock_app/models/WeekDay.dart';

class FoodPlanFragment extends StatefulWidget {
  @override
  _FoodPlanFragmentState createState() => _FoodPlanFragmentState();
}

class _FoodPlanFragmentState extends State<FoodPlanFragment>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _selectedDayIndex = 0;
  List<WeekDay> _weekDates = [
    WeekDay('SEG'),
    WeekDay('TER'),
    WeekDay('QUA'),
    WeekDay('QUI'),
    WeekDay('SEX'),
    WeekDay('SAB'),
    WeekDay('DOM'),
  ];
  List<Ingredient> _ingredients = [];
  List<MealPlanType> _meals = [];

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    _populateWeek();
    _getMealsByDate(_weekDates[_selectedDayIndex].date);
    /*var ingredient = Ingredient();
    ingredient.name = 'Banana';
    ingredient.quantity = 200;
    ingredient.unit = 'Gramas';
    ingredient.description = '1 Banana grande';

    _ingredients.add(ingredient);
    _ingredients.add(ingredient);

    var mealType = MealPlanType();
    mealType.type = 'P';
    mealType.portion = 1;
    mealType.hour = '08:00';
    mealType.opened = false;
    mealType.ingredients = _ingredients;

    _meals.add(mealType);
    _meals.add(mealType);
    _meals.add(mealType);*/
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFA3E1CB),
        appBar: TabBar(
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
        body: TabBarView(
          children: [_renderWeeklyPlan(), _renderHistoryPlan()],
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
            ..._renderMeals()
          ],
        ),
      ),
    );
  }

  List<Widget> _renderMeals() {
    List<Widget> list = [];
    _meals.forEach((element) {
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
                                Icons.keyboard_arrow_up,
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
                              tooltip: 'Fechar detalhes',
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
              children: [
                element.opened && element.ingredients != null ?
                _renderIngredients(element.ingredients):
                SizedBox()
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
                    left: BorderSide(color: Color(0xFFA3E1CB), width: 8),
                  ),
                  color: Color(0xFFECECEC),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.room_service),
                          SizedBox(
                            width: 4,
                          ),
                          Text(element.name),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text("${element.quantity} ${element.unit}"),
                      Text(element.description),
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
      decoration: BoxDecoration(color: Color(0xFFCECFCF)),
      child: Text("plano historico"),
    );
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

  _populateWeek() {
    List<WeekDay> weeks = _weekDates;
    DateTime date = DateTime.now();
    var auxDate = DateTime(date.year, date.month, date.day + 1);
    int dayIndex = _getSelectedIndexByDay(DateFormat('E').format(date));
    int auxDayIndex = dayIndex+1;
    String currentDateString = DateFormat('dd/MM/yyyy').format(date);
    setState(() {
      _selectedDayIndex = dayIndex;
    });

    while(dayIndex >= 0) {
      weeks[dayIndex].date = currentDateString;
      dayIndex --;
      date = DateTime(date.year, date.month, date.day - 1);
      currentDateString = DateFormat('dd/MM/yyyy').format(date);
    }

    while(auxDayIndex <= 6) {
      weeks[auxDayIndex].date = currentDateString;
      auxDate = DateTime(auxDate.year, auxDate.month, auxDate.day - 1);
      auxDayIndex++;
      currentDateString = DateFormat('dd/MM/yyyy').format(auxDate);
    }

    setState(() {
      _weekDates = weeks;
    });
  }
  _getMealsByDate(String date) {
    print(date);
  }

  _getSelectedIndexByDay(day) {
    switch (day) {
      case 'Mon': return 0;
      case 'Tue': return 1;
      case 'Wed': return 2;
      case 'Thu': return 3;
      case 'Fri': return 4;
      case 'Sat': return 5;
      default: return 6;
    }
  }
}
