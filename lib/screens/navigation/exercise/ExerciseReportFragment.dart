import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';
import 'package:nutriclock_app/utils/DropMenu.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExerciseReportFragment extends StatefulWidget {
  @override
  _ExerciseReportFragmentState createState() => _ExerciseReportFragmentState();
}

class _ExerciseReportFragmentState extends State<ExerciseReportFragment> {
  var appWidget = AppWidget();
  var _isLoading = false;
  var _data;
  List<_ChartData> _dataSourceDuration = [];
  List<_ChartData> _dataSourceCalories = [];
  List<DropMenu> _years = [];
  List<DropMenu> _monthsByYear = [];
  var _selectedMonth = '';
  var _selectedYear;

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
      var response = await Network().getWithAuth(EXERCISES_STATS_URL);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == RESPONSE_SUCCESS) {
        _data = json.decode(response.body)[JSON_DATA_KEY];

        // get the years
        _data.forEach((key, value) {
          _years.add(DropMenu(key, key));
        });
      }

      this._populateMonthsByYear(_years[0].value);

      this._setDataSource(_years[0].value, _monthsByYear[0].value);
    } catch (error) {
      print(error);
    }

    setState(() {
      _isLoading = false;
    });
  }

  _populateMonthsByYear(String year) {
    _monthsByYear = [];

    _data[year].forEach((key, value) {
      _monthsByYear.add(DropMenu(key, appWidget.getParsedMonths(key)));
    });
  }

  _setDataSource(String year, String month) {
    setState(() {
      _selectedMonth = month;
      _selectedYear = year;
    });

    List<_ChartData> dataDuration = [];
    List<_ChartData> dataCalories = [];

    _data[year][month].forEach((key, value) {
      _data[year][month][key].forEach((key1, value1) {
        var v = value1;
        if (v is int) v = value1.toDouble();
        if (key1 == 'calories') {
          dataCalories.add(_ChartData(key, v));
        }
        if (key1 == 'duration') {
          dataDuration.add(_ChartData(key, v));
        }
      });
    });

    setState(() {
      _dataSourceDuration = dataDuration;
      _dataSourceCalories = dataCalories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appWidget.getAppbar("Relatório Gráfico"),
      body: appWidget.getImageContainer(
        "assets/images/bg_dance.jpg",
        _isLoading,
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),
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
                          child: Text(item.description != null
                              ? item.description
                              : "null"),
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
                      items:
                          _years.map<DropdownMenuItem<String>>((DropMenu item) {
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
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Total minutos por dia',
                style: TextStyle(
                  color: Color(0xFF60B2A3),
                  fontSize: 12.0,
                ),
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
                    LineSeries<_ChartData, String>(
                      name: 'Duração',
                      dataSource: _dataSourceDuration,
                      xValueMapper: (_ChartData sales, _) => sales.day,
                      yValueMapper: (_ChartData sales, _) => sales.hours,
                      color: Color(0xFF000000),
                      // Enable data label
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ]),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Calorias queimadas por dia',
                style: TextStyle(
                  color: Color(0xFF60B2A3),
                  fontSize: 12.0,
                ),
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
                    LineSeries<_ChartData, String>(
                      name: 'Calorias Queimadas',
                      dataSource: _dataSourceCalories,
                      xValueMapper: (_ChartData sales, _) => sales.day,
                      yValueMapper: (_ChartData sales, _) => sales.hours,
                      color: Color(0xFF000000),
                      // Enable data label
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.day, this.hours);

  final String day;
  final double hours;
}
