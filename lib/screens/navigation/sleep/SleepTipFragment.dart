import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Tip.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SleepTipFragment extends StatefulWidget {
  @override
  _SleepTipFragmentState createState() => _SleepTipFragmentState();
}

class _SleepTipFragmentState extends State<SleepTipFragment> {
  var _isLoading = false;
  List<Tip> _tips = [];

  @override
  void initState() {
    _loadTips();
    super.initState();
  }

  _loadTips() async {
    List<Tip> list = [];

    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network().getWithAuth(SLEEP_TIPS_URL);
      if (response.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];

        data.forEach((element) {
          Tip tip = Tip.fromJson(element);
          list.add(tip);
        });

        this.setState(() {
          _tips = list;
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
        appBar: AppBar(
          title: Text(
            "Dicas do Sono",
            style: TextStyle(
              fontFamily: 'Pacifico',
            ),
          ),
          backgroundColor: Color(0xFF74D44D),
        ),
        body: ListView.builder(
              padding: const EdgeInsets.only(top: 16, left: 8, bottom: 8, right: 8),
              itemCount: _tips.length,
              itemBuilder: (BuildContext context, int index) {
                return
                  Card(child:ListTile(
                    leading: Icon(
                    Icons.check_circle_outline_rounded,
                    color: Color(0xFF74D44D),
                  ),
                title: Text(
                '${_tips[index].description}'),
                ) ,)
                  ;
              }
          ),
    );
  }
}
