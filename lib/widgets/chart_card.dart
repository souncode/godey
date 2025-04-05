import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:godey/widgets/custom_card.dart';

class ChartCard extends StatelessWidget {
  
  const ChartCard({super.key});
  

  @override
  Widget build(BuildContext context) {
      List<TemperatureData> data = [
    TemperatureData(DateTime(2025, 3, 1, 12, 0), 25.5),
    TemperatureData(DateTime(2025, 3, 1, 12, 30), 26.0),
    TemperatureData(DateTime(2025, 3, 1, 13, 0), 26.5),
  ];
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("Chart",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
        const SizedBox(height: 10,),
        AspectRatio(aspectRatio: 16/6,
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
        ),)
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