import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ErrorDonutChart extends StatelessWidget {
  final List<ErrorData> errorData;

  const ErrorDonutChart({super.key, required this.errorData});

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(text: 'Overall Equipment Effectiveness'),
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        position: LegendPosition.bottom,
      ),
      series: <DoughnutSeries<ErrorData, String>>[
        DoughnutSeries<ErrorData, String>(
          dataSource: errorData,
          xValueMapper: (ErrorData error, _) => error.errorName,
          yValueMapper: (ErrorData error, _) => error.count,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          radius: '90%',
          innerRadius: '60%',
        ),
      ],
    );
  }
}

class ErrorData {
  final String errorName;
  final int count;

  ErrorData(this.errorName, this.count);
}
