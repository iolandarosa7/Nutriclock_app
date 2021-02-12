import 'package:flutter/material.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExerciseReportFragment extends StatefulWidget {
  @override
  _ExerciseReportFragmentState createState() => _ExerciseReportFragmentState();
}

class _ExerciseReportFragmentState extends State<ExerciseReportFragment> {
  var appWidget = AppWidget();
  var _isLoading = false;
  var _selectedMonth = '';
  var _selectedYear = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appWidget.getAppbar("Estatísticas de Sono"),
      body: appWidget.getImageContainer(
        "assets/images/bg_dance.jpg",
        _isLoading,
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Relatório Gráfico',
                style: TextStyle(
                  color: Color(0xFF60B2A3),
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 8),
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
                        // _setDataSource(_selectedYear, newValue);
                      },
                      isExpanded: true,
                      /*items: _monthsByYear
                          .map<DropdownMenuItem<String>>((DropMenu item) {
                        return DropdownMenuItem<String>(
                          value: item.value,
                          child: Text(item.description),
                        );
                      }).toList(),*/
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
                        //_populateMonthsByYear(newValue);
                        //_setDataSource(newValue, _monthsByYear[0].value);
                      },
                      isExpanded: true,
                      /*items:
                          _years.map<DropdownMenuItem<String>>((DropMenu item) {
                        return DropdownMenuItem<String>(
                          value: item.value,
                          child: Text(item.description),
                        );
                      }).toList(),*/
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
                        name: 'Horas de Exercicio',
                        dataSource: [],//_dataSource,
                        xValueMapper: (_ChartData sales, _) => sales.day,
                        yValueMapper: (_ChartData sales, _) => sales.hours,
                        color: Color(0xFFC18C8C),
                        opacity: 0.6,
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true)),
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
