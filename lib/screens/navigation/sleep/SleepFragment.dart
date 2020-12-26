import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/screens/navigation/sleep/SleepCalendarFragment.dart';
import 'package:nutriclock_app/screens/navigation/sleep/SleepTipFragment.dart';

import 'SleepStatsFragment.dart';

class SleepFragment extends StatefulWidget {
  @override
  _SleepFragmentState createState() => _SleepFragmentState();
}

class _SleepFragmentState extends State<SleepFragment> {
  var _showTips = false;

  @override
  void initState() {
    _loadShowTip();
    super.initState();
  }

  _loadShowTip() async {
    try {
      var response = await Network().getWithAuth(CONFIG_TIP_URL);
      if (response.statusCode == RESPONSE_SUCCESS) {
        var showTips = json.decode(response.body)[JSON_DATA_KEY]['value'];
        print(showTips);

        this.setState(() {
          _showTips = (showTips == "true" || showTips == "1") ? true : false;
        });
      } else {}
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x8074D44D), Color(0x20FFFFFF)]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            elevation: 2.0,
            color: Colors.white,
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SleepCalendarFragment()),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                    ),
                    ClipRect(
                      child: Icon(
                        Icons.bedtime,
                        size: 50.0,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      "Diário do Sono",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Pacifico'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            elevation: 2.0,
            color: Colors.white,
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SleepStatsFragment()),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                    ),
                    ClipRect(
                      child: Icon(
                        Icons.bar_chart,
                        size: 50.0,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      "Estatísticas",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Pacifico'),
                    ),
                  ],
                ),
              ),
            ),
          ),
      _showTips ?
          Card(
            elevation: 2.0,
            color: Colors.white,
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SleepTipFragment()),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                        children: [
                          ClipRect(
                            child: Icon(
                              Icons.lightbulb,
                              size: 50.0,
                              color: Colors.yellow,
                            ),
                          ),
                          Text(
                            "Dicas",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Pacifico'),
                          ),
                          SizedBox(
                            width: double.infinity,
                          ),
                        ],
                      )
              ),
            ),
          ) : SizedBox(),
        ],
      ),
    );
  }
}
