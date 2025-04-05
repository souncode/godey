import 'package:flutter/material.dart';
import 'package:godey/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';

// Định nghĩa lớp dữ liệu nhiệt độ
class TemperatureData {
  final DateTime time;
  final double temperature;

  TemperatureData({required this.time, required this.temperature});
}

class ChartShow extends StatefulWidget {
  @override
  _ChartShowState createState() => _ChartShowState();
}

class _ChartShowState extends State<ChartShow> {
  List<TemperatureData> tempData = [];
  String chartTitle = ''; // Biến để lưu tên tiêu đề của biểu đồ

  // Hàm để gọi API và lấy dữ liệu
  void getDevice(String line) async {
    try {
      var regBody = {"line": line};

      var response = await http.post(
        Uri.parse(getDevicecfg), // Thay thế với URL API của bạn
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var jsonRes = jsonDecode(response.body);
        print("Parsed JSON: $jsonRes");

        if (jsonRes['success'] == null || jsonRes['success'].isEmpty) {
          print("No devices found for the specified line.");
        } else {
          // Lấy tên thiết bị từ API và cập nhật tiêu đề
          setState(() {
            chartTitle =
                jsonRes['success'][0]['stat']; // Lấy tên thiết bị từ stat
            tempData = extractTemperatureData(jsonRes['success']);
          });
        }
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e, stackTrace) {
      print("Exception: $e");
      print(stackTrace);
    }
  }

  // Hàm trích xuất dữ liệu nhiệt độ từ dữ liệu API
  List<TemperatureData> extractTemperatureData(List<dynamic> deviceDataList) {
    List<TemperatureData> tempData = [];

    for (var deviceData in deviceDataList) {
      print("Processing device: ${deviceData['stat']}");

      if (deviceData['ctrl'] == null || deviceData['ctrl'].isEmpty) {
        print("No temperature data available for ${deviceData['stat']}");
        continue;
      }

      DateTime time =
          DateTime.now(); // Giả sử thời gian thực, thay thế nếu có thời gian thực.

      String commonTime = deviceData['ctrl'][0]['time'].toString();
      DateTime sensorTime = time.add(
        Duration(minutes: int.tryParse(commonTime) ?? 0),
      );

      for (var ctrl in deviceData['ctrl']) {
        print("Processing ctrl: ${ctrl['inde']}");

        if (ctrl['temp'] != null && commonTime != null) {
          print("Temperature: ${ctrl['temp']}, Time: $commonTime");

          tempData.add(
            TemperatureData(
              time: sensorTime,
              temperature: double.tryParse(ctrl['temp'].toString()) ?? 0.0,
            ),
          );
        } else {
          print("Missing temperature or time data for ctrl: ${ctrl['inde']}");
        }
      }
    }

    return tempData;
  }

  @override
  void initState() {
    super.initState();
    getDevice(
      "67df1eee847d020add50949f",
    ); // Thay thế với dòng cụ thể bạn muốn lấy dữ liệu
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child:
          tempData.isEmpty
              ? Center(
                child: CircularProgressIndicator(),
              ) // Hiển thị khi chưa có dữ liệu
              : SfCartesianChart(
                title: ChartTitle(
                  text: chartTitle,
                ), // Sử dụng tiêu đề từ thiết bị
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
