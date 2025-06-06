import 'dart:convert';
import 'package:godey/services/device_service.dart';
import 'package:godey/services/log_service.dart';
import 'package:godey/widgets/hovertooltipbutton.dart';
import 'package:godey/widgets/line_show.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:godey/config.dart';
import 'package:godey/const/constant.dart';
import 'package:godey/responsive/desktop_scaffold.dart';

import 'package:http/http.dart' as http;

import '../widgets/all_chart.dart';
import '../widgets/donut_chart.dart';

class TabletScaffold extends StatefulWidget {
  const TabletScaffold({super.key});

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

var fetchLineresult = fetchLines();
String currentLine = "";
String currentLineName = "";
String lineta = "67df1eee847d020add50949f";
void getDevice(line) async {
  try {
    var regBody = {"line": lineta};

    var response = await http.post(
      Uri.parse(getDevicecfg),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );

    LogService().add("Response Status Code: ${response.statusCode}");
    LogService().add("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      var jsonRes = jsonDecode(response.body);
      LogService().add("Parsed JSON: $jsonRes");

      if (jsonRes['success'].isEmpty) {
        LogService().add("No devices found for the specified stat.");
      } else {
        LogService().add("Devices found: ${jsonRes['success']}");
      }
    } else {
      LogService().add("Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e, stackTrace) {
    LogService().add("Exception: $e");
    LogService().add(stackTrace.toString());
  }
}

void getLine() async {
  try {
    var response = await http.post(
      Uri.parse(getlinecfg),
      headers: {"Content-Type": "application/json"},
    );

    LogService().add("Response Status Code: ${response.statusCode}");
    LogService().add("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      var jsonRes = jsonDecode(response.body);
      LogService().add("Parsed JSON: $jsonRes");

      if (jsonRes['success'].isEmpty) {
        LogService().add("No line found for the specified stat.");
      } else {
        LogService().add("lin found: ${jsonRes['success']}");
      }
    } else {
      LogService().add("Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e, stackTrace) {
    LogService().add("Exception: $e");
    LogService().add(stackTrace.toString());
  }
}

class _TabletScaffoldState extends State<TabletScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myAppBar,
      drawer: myDrawer(
        context,
        onLineSelected: (lineId) {
          setState(() {
            currentLine = lineId;
          });
        },
        onLineNameSelected: (lineName) {
          setState(() {
            currentLineName = lineName;
          });
        },
      ),
      body: Container(
        color: backgroundColor,
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ADMIN",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text("Logged", style: TextStyle(fontSize: 8)),
                                Icon(
                                  Icons.verified,
                                  size: 6,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search",
                                hintStyle: TextStyle(color: textWhiteColor),
                                fillColor: secondaryCardColor,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                suffixIcon: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.search,
                                      color: textWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HoverTooltipButton(
                          label: Text("Status"),
                          tooltip: "Status Bar",
                          onPressed: () {},
                        ),
                      ),

                      (currentLine != "")
                          ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                backgroundColor: cardBackgroundColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                lineIDController = TextEditingController();
                                statController = TextEditingController();
                                typeController = TextEditingController();
                                LogService().add("Current line : $currentLine");
                                registerDeviceDialog(
                                  context,
                                  lineIDController,
                                  statController,
                                  typeController,
                                  currentLine,
                                );
                              },
                              child: Icon(Icons.add_chart),
                            ),
                          )
                          : SizedBox(),

                      (currentLine != "")
                          ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                backgroundColor: cardBackgroundColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {},
                              child: Text("ID :  $currentLine"),
                            ),
                          )
                          : SizedBox(),
                      (currentLine != "")
                          ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                backgroundColor: cardBackgroundColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {},
                              child: Text(currentLineName.toUpperCase()),
                            ),
                          )
                          : SizedBox(),
                      (fetchLineresult != [])
                          ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: HoverTooltipButton(
                              label: Icon(
                                Icons.check,
                                color: Colors.lightGreenAccent,
                              ),
                              tooltip: "Fetch Line",
                              onPressed: () {},
                            ),
                          )
                          : SizedBox(),
                    ],
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child:
                          currentLine.isNotEmpty
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  AllCharts(lineId: currentLine),
                                ],
                              )
                              : const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  "Select a line to show chart",
                                  style: TextStyle(
                                    color: textDarkColor,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                "Total part",
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5),

                      Row(
                        children: [Text("Unit"), Icon(Icons.arrow_drop_down)],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "0802200",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            "pcs",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "P/N :",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            "XXDLK",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                backgroundColor: cardBackgroundColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {},
                              child: Text("Done"),
                            ),
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: textDarkColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              onPressed: () {},
                              child: Text("Reset"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        "Chart",
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: secondaryCardColor,
                        ),

                        child: Column(
                          children: [
                            SizedBox(
                              child: ErrorDonutChart(errorData: errorList),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      TableCalendar(
                        focusedDay: DateTime.now(),
                        firstDay: DateTime.utc(210, 10, 16),
                        lastDay: DateTime.utc(2099, 10, 16),
                      ),
                      myDebugConsole(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//commit 2:32