import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:godey/config.dart';
import 'package:godey/const/constant.dart';
import 'package:godey/responsive/constants.dart';
import 'package:godey/widgets/donut_chart.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}


final List<ErrorData> errorList = [
  ErrorData('1', 30),
  ErrorData('2', 3),
  ErrorData('3', 2),
  ErrorData('4', 4),
  ErrorData('5', 1),
];


class _DesktopScaffoldState extends State<DesktopScaffold> {
  List<TemperatureData> data = [
    TemperatureData(DateTime(2025, 3, 1, 12, 0), 25.5),
    TemperatureData(DateTime(2025, 3, 1, 12, 30), 26.0),
    TemperatureData(DateTime(2025, 3, 1, 13, 0), 26.5),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          'Desktop scaffold',
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Row(
        children: [
          myDrawer(context),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SfCartesianChart(
                      title: ChartTitle(text: 'Chart 1'),
                      primaryXAxis: DateTimeAxis(),
                      primaryYAxis: NumericAxis(labelFormat: '{value}°C'),
                      series: <CartesianSeries<TemperatureData, DateTime>>[
                        LineSeries<TemperatureData, DateTime>(
                          dataSource: data,
                          xValueMapper: (TemperatureData temp, _) => temp.time,
                          yValueMapper:
                              (TemperatureData temp, _) => temp.temperature,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SfCartesianChart(
                      title: ChartTitle(text: 'Chart 2'),
                      primaryXAxis: DateTimeAxis(),
                      primaryYAxis: NumericAxis(labelFormat: '{value}°C'),
                      series: <CartesianSeries<TemperatureData, DateTime>>[
                        LineSeries<TemperatureData, DateTime>(
                          dataSource: data,
                          xValueMapper: (TemperatureData temp, _) => temp.time,
                          yValueMapper:
                              (TemperatureData temp, _) => temp.temperature,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SfCartesianChart(
                      title: ChartTitle(text: 'Chart 3'),
                      primaryXAxis: DateTimeAxis(),
                      primaryYAxis: NumericAxis(labelFormat: '{value}°C'),
                      series: <CartesianSeries<TemperatureData, DateTime>>[
                        LineSeries<TemperatureData, DateTime>(
                          dataSource: data,
                          xValueMapper: (TemperatureData temp, _) => temp.time,
                          yValueMapper:
                              (TemperatureData temp, _) => temp.temperature,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: const Color.fromARGB(255, 77, 93, 93),
              child: Column(
                children: [
                  SizedBox(child: ErrorDonutChart(errorData: errorList)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TemperatureData {
  final DateTime time;
  final double temperature;

  TemperatureData(this.time, this.temperature);
}
