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
   
    var regBody = {"stat": "AssemblyOven"};
     
    var response = await http.post(
      Uri.parse(getDevicecfg),
      
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );
   print(response.body);
    var jsonRes = jsonDecode(response.body);
     
    print(jsonRes);

    if (response.statusCode == 200) {
      print("Success: ${response.body}");
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
      body: Column(  // Đây là widget con bạn thêm vào
    children: <Widget>[
      ChartCard(),
      Text('Hello World'),
      FloatingActionButton(onPressed: (){
        getDevice(lineta);
      })
      // Thêm các widget khác nếu cần
    ],
  ),
    );
  }
}