import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';

import 'SleepCalendarFragment.dart';
import 'SleepStatsFragment.dart';
import 'SleepTipFragment.dart';

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
    return Scaffold(
      body: AppWidget().getImageContainer(
        "assets/images/bg_sleep.jpg",
        false,
        Stack(
          children: [
            Positioned(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height < 600 ? 0: MediaQuery.of(context).size.height / 12, left: 30),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SleepCalendarFragment(),
                      ),
                    );
                  },
                  child: Image(
                    image: AssetImage('assets/sleep/sleep.png'),
                    width: 210,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height < 600 ? MediaQuery.of(context).size.height / 4: MediaQuery.of(context).size.height / 3, right: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SleepStatsFragment()),
                    );
                  },
                  child: Image(
                    image: AssetImage('assets/sleep/stats.png'),
                    width: 210,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height < 600 ? 0: MediaQuery.of(context).size.height / 12, left: 16
                ),
                child: _showTips
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SleepTipFragment(),
                            ),
                          );
                        },
                        child: Image(
                          image: AssetImage('assets/sleep/tip.png'),
                          width: 210,
                        ),
                      )
                    : SizedBox(
                        height: 100,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}