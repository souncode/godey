import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/ctrl_model.dart';

class ChartShow extends StatelessWidget {
  final String chartTitle;
  final List<TemperatureData> tempData;

  ChartShow({required this.chartTitle, required this.tempData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child:
          tempData.isEmpty
              ? Center(child: CircularProgressIndicator())
              : SfCartesianChart(
                title: ChartTitle(text: chartTitle),
                primaryXAxis: DateTimeAxis(),
                primaryYAxis: NumericAxis(labelFormat: '{value}°C'),
                series: <CartesianSeries<TemperatureData, DateTime>>[
                  LineSeries<TemperatureData, DateTime>(
                    dataSource: tempData,
                    xValueMapper: (TemperatureData temp, _) => temp.time,
                    yValueMapper: (TemperatureData temp, _) => temp.temperature,
                  ),
                ],
              ),
    );
  }
}
