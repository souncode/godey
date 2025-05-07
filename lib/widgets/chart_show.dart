import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
              : Slidable(
                key: const ValueKey(0),

                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) async {
                        /*
                    //  final success = await DeleteLine(line['id']);
                      if (success) {
                       // refreshLines(); // Làm mới danh sách nếu xoá thành công
                      } else {
                        // Optionally hiển thị thông báo lỗi
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to delete line'),
                          ),
                        );
                      }*/
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: secondaryCardColor,
                  ),
                  child: SfCartesianChart(
                    title: ChartTitle(
                      text: chartTitle,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textDarkColor,
                      ),
                    ),
                    legend: Legend(
                      isVisible: true,
                      textStyle: TextStyle(color: textDarkColor, fontSize: 12),
                    ),
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
                      dateFormat: DateFormat.Hms(),
                      intervalType: DateTimeIntervalType.seconds,
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      labelStyle: TextStyle(color: textDarkColor, fontSize: 12),
                    ),
                    primaryYAxis: NumericAxis(
                      labelFormat: '{value}°C',
                      labelStyle: TextStyle(color: textDarkColor, fontSize: 12),
                    ),
                    series: _buildSeries(),
                  ),
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
        animationDuration: 00,
      );
    }).toList();
  }
}
