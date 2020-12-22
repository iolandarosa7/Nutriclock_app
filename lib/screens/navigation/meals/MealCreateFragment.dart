import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutriclock_app/screens/navigation/meals/MealDetailFragment.dart';

class MealCreateFragment extends StatefulWidget {
  @override
  _MealCreateFragmentState createState() => _MealCreateFragmentState();
}

class _MealCreateFragmentState extends State<MealCreateFragment> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _types = [
    MealType('P', 'Pequeno-almoço', Color(0xFFFFAEBC)),
    MealType('M', 'Meio da manhã', Color(0xFFC7CEEA)),
    MealType('A', 'Almoço', Color(0xFFA0E7E5)),
    MealType('L', 'Lanche', Color(0xFFFFDAC1)),
    MealType('J', 'Jantar', Color(0xFFC9E0EC)),
    MealType('O', 'Ceia', Color(0xFFffd5cd)),
    MealType('S', 'Snack', Color(0xFFCCDDC0)),
  ];

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MealDetailFragment(type: element.type),
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
    return list;
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
