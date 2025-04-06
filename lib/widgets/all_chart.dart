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

  @override
  void initState() {
    super.initState();
    loadAllCharts();
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

        List<Map<String, dynamic>> tempList = [];

        for (var device in devices) {
          String title = device['stat'] ?? 'Unknown';
          List<TemperatureData> data = extractTemperatureData(device);

          tempList.add({
            'title': title,
            'data': data,
          });
        }

        setState(() {
          chartDataList = tempList;
          loading = false;
        });
      } else {
        print("Failed to load: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  List<TemperatureData> extractTemperatureData(Map<String, dynamic> deviceData) {
    List<TemperatureData> tempData = [];
    String commonTime = deviceData['ctrl'][0]['time'].toString();
    DateTime baseTime = DateTime.now().add(Duration(minutes: int.tryParse(commonTime) ?? 0));

    for (var ctrl in deviceData['ctrl']) {
      if (ctrl['temp'] != null) {
        tempData.add(
          TemperatureData(
            time: baseTime,
            temperature: double.tryParse(ctrl['temp'].toString()) ?? 0.0,
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
            children: chartDataList
                .map((chart) => ChartShow(
                      chartTitle: chart['title'],
                      tempData: chart['data'],
                    ))
                .toList(),
          );
  }
}
