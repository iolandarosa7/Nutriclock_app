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
        image: DecorationImage(
          image: AssetImage("assets/images/bg_sleep.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SleepCalendarFragment()),
              );
            },
            child: Image(image: AssetImage('assets/sleep/sleep.png')),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SleepStatsFragment()),
              );
            },
            child: Image(image: AssetImage('assets/sleep/stats.png')),
          ),
          SizedBox(
            height: 20,
          ),
          _showTips
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SleepTipFragment()),
                    );
                  },
                  child: Image(image: AssetImage('assets/sleep/tip.png')),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
