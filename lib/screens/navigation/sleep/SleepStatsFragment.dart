import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/DropMenu.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SleepStatsFragment extends StatefulWidget {
  @override
  _SleepStatsFragmentState createState() => _SleepStatsFragmentState();
}

class _SleepStatsFragmentState extends State<SleepStatsFragment> {
  var _isLoading = false;
  var _data;
  List<_ChartData> _dataSource = [];
  List<DropMenu> _years = [];
  List<DropMenu> _monthsByYear = [];
  var _selectedMonth = '';
  var _selectedYear = '';

  @override
  void initState() {
    this._loadData();
    super.initState();
  }

  _loadData() async {
    if (_isLoading) return;

    this.setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network().getWithAuth(SLEEP_STATS_ME_URL);

      if (response.statusCode == RESPONSE_SUCCESS) {
        _data = json.decode(response.body)[JSON_DATA_KEY];

        // get the years
        _data.forEach((key, value) {
          _years.add(DropMenu(key, key));
        });
      }

      this._populateMonthsByYear(_years[0].value);

      this._setDataSource(_years[0].value, _monthsByYear[0].value);
    } catch (error) {}

    setState(() {
      _isLoading = false;
      // _autocompleteSuggestions = list;
    });
  }

  _populateMonthsByYear(String year) {
    _monthsByYear = [];

    _data[year].forEach((key, value) {
      _monthsByYear.add(DropMenu(key, _parseMonths(key)));
    });
  }

  _setDataSource(String year, String month) {
    setState(() {
      _selectedMonth = month;
      _selectedYear = year;
    });
    List<_ChartData> data = [];
    _data[year][month].forEach((element) {
      var value = element["value"];
      value is int ? value = value.toDouble() : value = value;

      data.add(_ChartData(element["label"], value));
    });

    setState(() {
      _dataSource = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Estatísticas de Sono",
          style: TextStyle(
            fontFamily: 'Pacifico',
          ),
        ),
        backgroundColor: Color(0xFFA3E1CB),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_sleep.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: _isLoading
            ? Center(
                child: Loading(
                  indicator: BallPulseIndicator(),
                  size: 50.0,
                  color: Color(0xFFFFBCBC),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'Horas de Sono',
                      style: TextStyle(
                          color: Color(0xFF60B2A3),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Color(0xFF60B2A3),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 7,
                          child: DropdownButton(
                            value: _selectedMonth,
                            hint: Text(
                              "Filtrar por ano",
                              style: TextStyle(
                                  color: Color(0xFF9b9b9b),
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF60B2A3),
                            ),
                            onChanged: (newValue) {
                              _setDataSource(_selectedYear, newValue);
                            },
                            isExpanded: true,
                            items: _monthsByYear
                                .map<DropdownMenuItem<String>>((DropMenu item) {
                              return DropdownMenuItem<String>(
                                value: item.value,
                                child: Text(item.description),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 3,
                          child: DropdownButton(
                            value: _selectedYear,
                            hint: Text(
                              "Filtrar por ano",
                              style: TextStyle(
                                  color: Color(0xFF9b9b9b),
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF60B2A3),
                            ),
                            onChanged: (newValue) {
                              _populateMonthsByYear(newValue);
                              _setDataSource(newValue, _monthsByYear[0].value);
                            },
                            isExpanded: true,
                            items: _years
                                .map<DropdownMenuItem<String>>((DropMenu item) {
                              return DropdownMenuItem<String>(
                                value: item.value,
                                child: Text(item.description),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        // Enable legend
                        legend: Legend(
                          isVisible: false,
                        ),
                        // Enable tooltip
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <ChartSeries<_ChartData, String>>[
                          ColumnSeries<_ChartData, String>(
                              name: 'Horas de Sono',
                              dataSource: _dataSource,
                              xValueMapper: (_ChartData sales, _) => sales.day,
                              yValueMapper: (_ChartData sales, _) =>
                                  sales.hours,
                              color: Color(0xFFC18C8C),
                              opacity: 0.6,
                              // Enable data label
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true)),
                        ]),
                  ),
                ],
              ),
      ),
    );
  }

  _parseMonths(value) {
    switch (value) {
      case '1':
        return 'Janeiro';
      case '2':
        return 'Fevereiro';
      case '3':
        return 'Março';
      case '4':
        return 'Abril';
      case '5':
        return 'Maio';
      case '6':
        return 'Junho';
      case '7':
        return 'Julho';
      case '8':
        return 'Agosto';
      case '9':
        return 'Setembro';
      case '10':
        return 'Outobro';
      case '11':
        return 'Novembro';
      case '12':
        return 'Dezembro';
    }
  }
}

class _ChartData {
  _ChartData(this.day, this.hours);

  final String day;
  final double hours;
}
