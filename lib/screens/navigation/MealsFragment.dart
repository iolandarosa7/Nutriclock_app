import 'package:flutter/material.dart';
import 'package:nutriclock_app/screens/navigation/MealDetailFragment.dart';

class MealsFragment extends StatefulWidget {
  @override
  _MealsFragmentState createState() => _MealsFragmentState();
}

class _MealsFragmentState extends State<MealsFragment> {
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
