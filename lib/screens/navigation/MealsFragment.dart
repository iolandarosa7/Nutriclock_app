import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Meal.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/screens/navigation/MealDetailFragment.dart';

class MealsFragment extends StatefulWidget {
  @override
  _MealsFragmentState createState() => _MealsFragmentState();
}

class _MealsFragmentState extends State<MealsFragment> {
  var _isLoading = false;
  var meals = [];

  @override
  void initState() {
    _loadMealsList();
    super.initState();
  }

  _loadMealsList() async {
    List<Meal> list = [];

    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });
    try {
      var response = await Network().getWithAuth(MEALS_USER_URL);

      var body = json.decode(response.body);
      print(response.statusCode);

      if (response.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];

        data.forEach((element) {
          Meal meal = Meal.fromJson(element);
          list.add(meal);
        });

        this.setState(() {
          meals = list;
        });
      } else {}
    } catch (error) {}

    this.setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x8074D44D), Color(0x20FFFFFF)]),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    margin: EdgeInsets.only(top: 40),
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
                    child: meals.isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Text(
                                  "Nenhum alimento adicionado.",
                                  style: TextStyle(color: Colors.grey),
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
                            ))
                        : Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Estes são os alimentos que tens comido",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Expanded(child:
                            Padding(
                              padding: EdgeInsets.all(4),
                              child: GridView.count(
                                crossAxisCount: 3,
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                                children: meals.map<GridTile>((value) {
                                  return GridTile(
                                    child: Stack(
                                      children: [
                                        value.foodPhotoUrl == null
                                            ? Container(
                                          constraints:
                                          BoxConstraints.expand(),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0x8074D44D),
                                                  Color(0x20FFFFFF)
                                                ]),
                                          ),
                                        )
                                            : Container(
                                          constraints:
                                          BoxConstraints.expand(),
                                          child: Image.network(
                                            "$BASE_URL/storage/food/${value.foodPhotoUrl}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ), /*Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50),
                                  child: Text(value.name),
                                ),*/
                                  );
                                }).toList(),
                              ),
                            )

                        )

                      ],
                    )


                  ),
                ),
                Positioned(
                  top: 10,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MealDetailFragment()),
                      );
                    },
                    child: Icon(Icons.add),
                    backgroundColor: Color(0xFF808e95),
                    elevation: 50,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
