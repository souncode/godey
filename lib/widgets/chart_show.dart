import 'package:flutter/material.dart';
import 'package:godey/const/constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/ctrl_model.dart';
import 'package:intl/intl.dart';

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
              : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 17, 52, 52),
                  boxShadow: [
                    BoxShadow(
                      color: cardBackgroundColor,
                      offset: const Offset(5.0, 5.0), //Offset
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: SfCartesianChart(
                  title: ChartTitle(text: chartTitle),
                  legend: Legend(isVisible: true),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  crosshairBehavior: CrosshairBehavior(
                    enable: true,
                    lineType: CrosshairLineType.both,
                    activationMode: ActivationMode.longPress,
                  ),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePinching: true,
                    enablePanning: true,
                    zoomMode: ZoomMode.x,
                  ),
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat.Hms(), // Hiển thị HH:mm:ss
                    intervalType: DateTimeIntervalType.seconds,
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                  ),
                  primaryYAxis: NumericAxis(labelFormat: '{value}°C'),
                  series: _buildSeries(),
                ),
              ),
    );
  }

  List<LineSeries<TemperatureData, DateTime>> _buildSeries() {
    final Map<String, List<TemperatureData>> groupedData = {};

    for (var data in tempData) {
      groupedData.putIfAbsent(data.ctrlName, () => []).add(data);
    }

    return groupedData.entries.map((entry) {
      return LineSeries<TemperatureData, DateTime>(
        name: entry.key,
        dataSource: entry.value,
        xValueMapper: (TemperatureData temp, _) => temp.time,
        yValueMapper: (TemperatureData temp, _) => temp.temperature,
        markerSettings: MarkerSettings(isVisible: true),
        dataLabelSettings: DataLabelSettings(isVisible: false),
        enableTooltip: true,
      );
    }).toList();
  }
}
