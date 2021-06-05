import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Procedure.dart';
import 'package:nutriclock_app/models/Sample.dart';
import 'package:nutriclock_app/models/SampleInterval.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';

class BioMarkersFragment extends StatefulWidget {
  @override
  _BioMarkersFragmentState createState() => _BioMarkersFragmentState();
}

class _BioMarkersFragmentState extends State<BioMarkersFragment> {
  var appWidget = AppWidget();
  var _isLoading = false;
  List<Procedure> _procedures = [];
  List<Sample> _samples = [];

  @override
  void initState() {
    _loadProcedures();
    _loadSamples();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appWidget.getAppbar("Biomarcadores"),
      body: AppWidget().getImageContainer(
        "assets/images/bg_green.png",
        _isLoading,
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              Text(
                "Recolhas",
                style: TextStyle(
                    fontFamily: 'PatrickHand',
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              ..._renderSamples(),
              SizedBox(
                height: 30,
              ),
              Text(
                "Procedimento",
                style: TextStyle(
                    fontFamily: 'PatrickHand',
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shadowColor: Color(0xFFA3E1CB),
                elevation: 10,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [..._renderProcedures()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _renderSampleIntervals(List<SampleInterval> list) {
    List<Widget> widgets = [];

    list.forEach((element) {
      var widget = Padding(
        padding: EdgeInsets.only(right: 16),
        child: Text("${element.hour}"),
      );

      widgets.add(widget);
    });
    return widgets;
  }

  _renderSamples() {
    List<Widget> widgets = [];

    _samples.forEach((element) {
      var widget = Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shadowColor: Color(0xFFA3E1CB),
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "${element.name}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF60B2A3),
                  fontFamily: 'PatrickHand',
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "${element.date}",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Horas da Recolha",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 4, left: 30),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  children: <Widget>[
                    ..._renderSampleIntervals(element.intervals),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

      widgets.add(widget);
    });
    return widgets;
  }

  _renderProcedures() {
    List<Widget> widgets = [];
    var index = 0;

    _procedures.forEach((element) {
      var widget = Column(
        children: [
          ListTile(
            leading: Text(
              'Passo ${element.orderNumber + 1}',
              style: TextStyle(
                  color: Color(0xFF60B2A3),
                  fontFamily: 'PatrickHand',
                  fontSize: 18),
            ),
            title: Text(
              '${element.value}',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          if (index < _procedures.length - 1) Divider(),
        ],
      );
      widgets.add(widget);
      index++;
    });
    return widgets;
  }

  _loadProcedures() async {
    List<Procedure> procedures = [];

    try {
      var response = await Network().getWithAuth(BIOMETRIC_PROCEDURES_URL);

      if (response.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];

        data.forEach((element) {
          Procedure p = Procedure.fromJson(element);
          procedures.add(p);
        });
      }
    } catch (error) {
      print(error);
    }

    setState(() {
      _procedures = procedures;
    });
  }

  _loadSamples() async {
    List<Sample> samples = [];

    if (_isLoading) return;

    this.setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network().getWithAuth(BIOMETRIC_SAMPLES_URL);

      if (response.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];

        data.forEach((element) {
          Sample s = Sample.fromJson(element);
          List<SampleInterval> intervals = [];
          s.intervals.forEach((i) {
            SampleInterval int = SampleInterval.fromJson(i);
            intervals.add(int);
          });
          s.intervals = intervals;
          samples.add(s);
        });
      }
    } catch (error) {
      print(error);
    }

    setState(() {
      _isLoading = false;
      _samples = samples;
    });
  }
}
