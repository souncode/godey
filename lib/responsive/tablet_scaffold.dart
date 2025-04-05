import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:godey/config.dart';
import 'package:godey/responsive/constants.dart';
import 'package:godey/widgets/chart_card.dart';
import 'package:http/http.dart' as http;

class TabletScaffold extends StatefulWidget {
  const TabletScaffold({super.key});

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

String lineta = "67df1eee847d020add50949f";
void getDevice(line) async {
  try {
    var regBody = {"line": lineta};

    var response = await http.post(
      Uri.parse(getDevicecfg),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      var jsonRes = jsonDecode(response.body);
      print("Parsed JSON: $jsonRes");

      if (jsonRes['success'].isEmpty) {
        print("No devices found for the specified stat.");
      } else {
        print("Devices found: ${jsonRes['success']}");
      }
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e, stackTrace) {
    print("Exception: $e");
    print(stackTrace);
  }
}

void getLine() async {
  try {
    var response = await http.post(
      Uri.parse(getlinecfg),
      headers: {"Content-Type": "application/json"},
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      var jsonRes = jsonDecode(response.body);
      print("Parsed JSON: $jsonRes");

      if (jsonRes['success'].isEmpty) {
        print("No line found for the specified stat.");
      } else {
        print("lin found: ${jsonRes['success']}");
      }
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e, stackTrace) {
    print("Exception: $e");
    print(stackTrace);
  }
}

class _TabletScaffoldState extends State<TabletScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myDefaultBackground,
      appBar: myAppBar,
      drawer: myDrawer(context),
      body: Row(
        children: [
          Column(
            children: <Widget>[
              SizedBox(width: 500.0, height: 300, child: ChartCard()),

              Text('Hello World'),
              FloatingActionButton(
                onPressed: () {
                  getLine();
                },
              ),
              // Thêm các widget khác nếu cần
            ],
          ),
          Column(),
        ],
      ),
    );
  }
}
