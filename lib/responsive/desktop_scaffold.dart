import 'package:flutter/material.dart';
import 'package:godey/responsive/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  List<TemperatureData> data = [
    TemperatureData(DateTime(2025, 3, 1, 12, 0), 25.5),
    TemperatureData(DateTime(2025, 3, 1, 12, 30), 26.0),
    TemperatureData(DateTime(2025, 3, 1, 13, 0), 26.5),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: myDrawer,
      appBar: AppBar(title: const Text('Dashboard Nhiệt Độ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCartesianChart(
          title: ChartTitle(text: 'Dữ liệu nhiệt độ'),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(labelFormat: '{value}°C'),
          series: <CartesianSeries<TemperatureData, DateTime>>[
            LineSeries<TemperatureData, DateTime>(
              dataSource: data,
              xValueMapper: (TemperatureData temp, _) => temp.time,
              yValueMapper: (TemperatureData temp, _) => temp.temperature,
            ),
          ],
        ),
      ),
    );
  }
}

class TemperatureData {
  final DateTime time;
  final double temperature;

  TemperatureData(this.time, this.temperature);
}
