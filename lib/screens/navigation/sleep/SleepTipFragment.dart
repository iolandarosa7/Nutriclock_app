import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Tip.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';

class SleepTipFragment extends StatefulWidget {
  @override
  _SleepTipFragmentState createState() => _SleepTipFragmentState();
}

class _SleepTipFragmentState extends State<SleepTipFragment> {
  var _isLoading = false;
  List<Tip> _tips = [];
  var appWidget = AppWidget();

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
      appBar: appWidget.getAppbar("Dicas do Sono"),
      body: appWidget.getImageContainer(
        "assets/images/bg_sleep.jpg",
        _isLoading,
        ListView.builder(
            padding:
                const EdgeInsets.only(top: 16, left: 0, bottom: 8, right: 40),
            itemCount: _tips.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
                margin: EdgeInsets.only(bottom: 10, top: 20),
                shadowColor: Color(0xFFA3E1CB),
                elevation: 10,
                child: ListTile(
                  leading: Icon(
                    Icons.star_rounded,
                    color: Color(0xFFF4D481),
                  ),
                  title: Text(
                    '${_tips[index].description}',
                    style: TextStyle(
                        color: Color(0xFF60B2A3),
                        fontFamily: 'PatrickHand',
                        fontSize: 20),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
