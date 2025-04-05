import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ErrorPieChart extends StatelessWidget {
  final List<ErrorData> errorData;

  const ErrorPieChart({super.key, required this.errorData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCircularChart(
          title: ChartTitle(
            text: 'OEE',
            textStyle: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          legend: Legend(
            isVisible: true,
            textStyle: const TextStyle(color: Colors.white),
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          series: <PieSeries<ErrorData, String>>[
            PieSeries<ErrorData, String>(
              dataSource: errorData,
              xValueMapper: (ErrorData data, _) => data.name,
              yValueMapper: (ErrorData data, _) => data.count,
              dataLabelMapper: (ErrorData data, _) => '${data.count}',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorData {
  final String name;
  final int count;

  ErrorData(this.name, this.count);
}
