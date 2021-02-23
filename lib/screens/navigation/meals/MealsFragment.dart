import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Meal.dart';
import 'package:nutriclock_app/models/MealsResponse.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/screens/navigation/meals/MealUpdateFragment.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';

import 'MealCreateFragment.dart';

class MealsFragment extends StatefulWidget {
  @override
  _MealsFragmentState createState() => _MealsFragmentState();
}

class _MealsFragmentState extends State<MealsFragment> {
  var _isLoading = false;
  MealsResponse _data;
  var _daysFromInitialMeal = 4;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var appWidget = AppWidget();

  @override
  void initState() {
    _loadMealsList();
    super.initState();
  }

  _loadMealsList() async {
    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    MealsResponse mealResponse = MealsResponse();
    mealResponse.mealsTypeByDate = [];

    try {
      var response = await Network().getWithAuth(MEALS_USER_URL);

      if (response.statusCode == RESPONSE_SUCCESS) {
        var data = json.decode(response.body);
        var daysFromInitialDate = data["daysFromInitialDate"];
        List<dynamic> meals = data["meals"];
        meals.forEach((element) {
          var mealTypeByDate = MealTypeByDate();
          mealTypeByDate.date = element["date"];
          mealTypeByDate.breakfasts = _populateMeals(element["P"]);
          mealTypeByDate.midMorning = _populateMeals(element["M"]);
          mealTypeByDate.lunchs = _populateMeals(element["A"]);
          mealTypeByDate.dinners = _populateMeals(element["J"]);
          mealTypeByDate.snacks = _populateMeals(element["S"]);
          mealTypeByDate.brunchs = _populateMeals(element["L"]);
          mealTypeByDate.anothers = _populateMeals(element["O"]);
          mealResponse.mealsTypeByDate.add(mealTypeByDate);
        });
        this.setState(() {
          _daysFromInitialMeal = daysFromInitialDate;
          _data = mealResponse;
          _isLoading = false;
        });
      }
    } catch (error) {
      this.setState(() {
        _isLoading = false;
      });
    }
  }

  _populateMeals(List<dynamic> list) {
    List<Meal> meals = [];
    list.forEach((element) {
      Meal meal = Meal.fromJson(element);
      meals.add(meal);
    });

    return meals;
  }

  Widget _renderElement(List<Meal> meals, String description) {
    return (meals.length > 0
        ? Container(
            height: 30,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE6A9A9), Color(0x10FFFFFF)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
              ),
            ),
            child: Text(
              description,
              style: TextStyle(fontFamily: "Pacifico", color: Colors.white),
            ),
          )
        : SizedBox());
  }

  Widget _renderSpace(List<Meal> meals) {
    return (meals.length > 0
        ? SizedBox(
            height: 8,
          )
        : SizedBox());
  }

  List<Widget> data() {
    List<Widget> list = List();
    _data.mealsTypeByDate.forEach((element) {
      list.add(
        Card(
          elevation: 4.0,
          color: Colors.white,
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  element.date,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF60B2A3),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    _renderElement(element.breakfasts, "Pequeno-almoço"),
                    ..._renderMealsByType(element.breakfasts),
                    _renderSpace(element.breakfasts),
                    _renderElement(element.midMorning, "Lanche da manhã"),
                    ..._renderMealsByType(element.midMorning),
                    _renderSpace(element.midMorning),
                    _renderElement(element.lunchs, "Almoço"),
                    ..._renderMealsByType(element.lunchs),
                    _renderSpace(element.lunchs),
                    _renderElement(element.brunchs, "Lanche"),
                    ..._renderMealsByType(element.brunchs),
                    _renderSpace(element.brunchs),
                    _renderElement(element.dinners, "Jantar"),
                    ..._renderMealsByType(element.dinners),
                    _renderSpace(element.dinners),
                    _renderElement(element.anothers, "Ceia"),
                    ..._renderMealsByType(element.anothers),
                    _renderSpace(element.anothers),
                    _renderElement(element.snacks, "Snacks"),
                    ..._renderMealsByType(element.snacks),
                    _renderSpace(element.snacks),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: _daysFromInitialMeal < 3
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MealCreateFragment()),
                ).then((value) => {_loadMealsList()});
              },
              child: Icon(Icons.add),
              backgroundColor: Color(0xFF60B2A3),
              elevation: 50,
            )
          : SizedBox(),
      body: appWidget.getImageContainer(
        "assets/images/bg_home.jpg",
        _isLoading,
        _data == null ||
                _data.mealsTypeByDate == null ||
                _data.mealsTypeByDate.isEmpty
            ? Card(
                elevation: 4.0,
                color: Colors.white,
                margin: EdgeInsets.only(left: 20, right: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Nenhum alimento adicionado.",
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Começa já a registar o teu Diário Alimentar com tudo o que compõe as tuas refeições.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(4),
                child: Column(children: data()),
              ),
      ),
    );
  }

  Widget _renderImageDefault() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border(
          top: BorderSide(color: Colors.white),
          left: BorderSide(color: Colors.white),
        ),
      ),
      child: Icon(
        Icons.image_rounded,
        color: Colors.grey[800],
      ),
    );
  }

  List<Widget> _renderMealsByType(List<Meal> meals) {
    List<Widget> list = List();

    meals.forEach((element) {
      list.add(
        Stack(
          children: [
            Positioned(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Color(0xFFE6A9A9), width: 10.0),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ClipRect(
                    child: element.foodPhotoUrl != null
                        ? Image.network(
                            "$IMAGE_BASE_URL/food/thumb_${element.foodPhotoUrl}",
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                              return _renderImageDefault();
                            },
                          )
                        : _renderImageDefault(),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 0,
              height: 70,
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: FloatingActionButton(
                      heroTag: "edit${element.id}",
                      child: Icon(
                        Icons.edit,
                        size: 15,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MealUpdateFragment(meal: element),
                          ),
                        ).then((value) => {_loadMealsList()});
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    flex: 5,
                    child: FloatingActionButton(
                      heroTag: "delete${element.id}",
                      child: Icon(
                        Icons.delete,
                        size: 15,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.redAccent,
                      onPressed: () {
                        this._showDeleteMealConfirmation(element);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
    return list;
  }

  Future<void> _showDeleteMealConfirmation(Meal meal) async {
    if (_isLoading) return;

    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Apagar refeição / alimento",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFA3E1CB),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    "Tem a certeza que deseja apagar a refeição / alimento selecionado?",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.grey,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Eliminar'),
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteMeal(meal);
                },
              ),
            ],
          );
        });
  }

  _deleteMeal(meal) async {
    var hasError = false;
    if (_isLoading) return;

    this.setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network().deletetWithAuth(MEAL_URL, meal.id);
      setState(() {
        _isLoading = false;
      });
      if (response.statusCode == RESPONSE_SUCCESS) {
        appWidget.showSnackbar(
            "Eliminado com sucesso", Colors.green, _scaffoldKey);
        _loadMealsList();
      } else {
        hasError = true;
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      hasError = true;
    }

    if (hasError)
      appWidget.showSnackbar("Não é possivel eliminar o elemento seleccionado",
          Colors.red, _scaffoldKey);
  }
}
