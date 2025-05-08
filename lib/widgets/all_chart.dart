import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:godey/config.dart';
import 'package:godey/services/log_service.dart';
import 'package:godey/widgets/chart_show.dart';
import 'package:http/http.dart' as http;

import '../model/ctrl_model.dart';

class AllCharts extends StatefulWidget {
  final String lineId;

  const AllCharts({super.key, required this.lineId});

  @override
  AllChartsState createState() => AllChartsState();
}

class AllChartsState extends State<AllCharts> {
  List<Map<String, dynamic>> chartDataList = [];
  bool loading = true;
  Timer? _timer;
  final int _duration = 5;

  @override
  void initState() {
    super.initState();
    loadAllCharts();

    _timer = Timer.periodic(
      Duration(seconds: _duration),
      (timer) => loadAllCharts(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
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
          String dvID = device['_id'] ?? 'Unknown';
          List<TemperatureData> newData = extractTemperatureData(device);

          var existingChart = chartDataList.firstWhere(
            (element) => element['title'] == title,
            orElse:
                () => {
                  'title': title,
                  '_id': dvID,
                  'data': <TemperatureData>[],
                },
          );

          List<TemperatureData> combinedData = List<TemperatureData>.from(
            existingChart['data'],
          );
          combinedData.addAll(newData);

          // giữ tối đa 30 điểm
          if (combinedData.length > 300) {
            combinedData = combinedData.sublist(combinedData.length - 300);
          }

          updatedList.add({'title': title, '_id': dvID, 'data': combinedData});
        }

        setState(() {
          chartDataList = updatedList;
          loading = false;
        });
      } else {
        LogService().add("Failed to load: ${response.body}");
      }
    } catch (e) {
      LogService().add("Exception: $e");
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
                      chartID: chart['_id'],
                      chartTitle: chart['title'],
                      tempData: chart['data'],
                    ),
                  )
                  .toList(),
        );
  }
}
