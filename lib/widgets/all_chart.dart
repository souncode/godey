import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:godey/config.dart';
import 'package:godey/widgets/chart_show.dart';
import 'package:http/http.dart' as http;

import '../model/ctrl_model.dart';

class AllCharts extends StatefulWidget {
  final String lineId;

  AllCharts({required this.lineId});

  @override
  _AllChartsState createState() => _AllChartsState();
}

class _AllChartsState extends State<AllCharts> {
  List<Map<String, dynamic>> chartDataList = []; // mỗi item gồm title + data
  bool loading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadAllCharts();
    // Lặp lại việc tải dữ liệu mỗi 30 giây
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => loadAllCharts());
  }

  @override
  void dispose() {
    _timer?.cancel(); // Dọn dẹp khi widget bị hủy
    super.dispose();
  }

  void loadAllCharts() async {
    try {
      var response = await http.post(
        Uri.parse(getDevicecfg),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"line": widget.lineId}),
      );

      if (response.statusCode == 200) {
        var jsonRes = jsonDecode(response.body);
        List devices = jsonRes['success'] ?? [];

        List<Map<String, dynamic>> updatedList = [];

        for (var device in devices) {
          String title = device['stat'] ?? 'Unknown';
          List<TemperatureData> newData = extractTemperatureData(device);

          // tìm biểu đồ tương ứng đã có
          var existingChart = chartDataList.firstWhere(
            (element) => element['title'] == title,
            orElse: () => {'title': title, 'data': <TemperatureData>[]},
          );

          List<TemperatureData> combinedData = List<TemperatureData>.from(
            existingChart['data'],
          );
          combinedData.addAll(newData);

          // giữ tối đa 30 điểm
          if (combinedData.length > 300) {
            combinedData = combinedData.sublist(combinedData.length - 300);
          }

          updatedList.add({'title': title, 'data': combinedData});
        }

        setState(() {
          chartDataList = updatedList;
          loading = false;
        });
      } else {
        print("Failed to load: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  List<TemperatureData> extractTemperatureData(
    Map<String, dynamic> deviceData,
  ) {
    List<TemperatureData> tempData = [];
    DateTime now = DateTime.now();
    for (var ctrl in deviceData['ctrl']) {
      if (ctrl['temp'] != null && ctrl['inde'] != null) {
        tempData.add(
          TemperatureData(
            time: now,
            temperature: double.tryParse(ctrl['temp'].toString()) ?? 0.0,
            ctrlName: ctrl['inde'].toString(),
          ),
        );
      }
    }

    return tempData;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : Column(
          children:
              chartDataList
                  .map(
                    (chart) => ChartShow(
                      chartTitle: chart['title'],
                      tempData: chart['data'],
                    ),
                  )
                  .toList(),
        );
  }
}
