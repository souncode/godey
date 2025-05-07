import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:godey/const/constant.dart';

import 'package:godey/widgets/all_chart.dart';
import 'package:godey/widgets/debug_console_screen.dart';
import 'package:godey/widgets/donut_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/log_service.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

final List<ErrorData> errorList = [
  ErrorData('1', 30),
  ErrorData('2', 3),
  ErrorData('3', 2),
  ErrorData('4', 4),
  ErrorData('5', 1),
];

class _DesktopScaffoldState extends State<DesktopScaffold> {
  String currentLine = "";
  String currentLineName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Row(
          children: [
            SvgPicture.asset(
              'lib/assets/images/sown_logo.svg',
              width: 50,
              height: 50,
              color: Colors.white,
            ),
            SizedBox(width: 100),
            const Text(
              'Desktop scaffold',
              style: TextStyle(
                color: Colors.cyanAccent,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: backgroundColor,
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: myDesktopDrawer(
                  context,
                  onLineSelected: (lineId) {
                    setState(() {
                      currentLine = lineId;

                      LogService().add("Đã kết nối MQTT");
                    });
                  },
                  onLineNameSelected: (lineName) {
                    setState(() {
                      currentLineName = lineName;
                    });
                  },
                ),
              ),
            ),

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
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: cardBackgroundColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Devices",
                            style: TextStyle(color: textWhiteColor),
                          ),
                        ),
                      ),
                      Padding(
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
                            LineIDController = TextEditingController();
                            statController = TextEditingController();
                            typeController = TextEditingController();
                            print("Current line : " + currentLine);
                            if (currentLine == "") {
                              registerDeviceErrDialog(context);
                            } else {
                              registerDeviceDialog(
                                context,
                                LineIDController,
                                statController,
                                typeController,
                                currentLine,
                              );
                            }
                          },
                          child: Icon(Icons.add_chart),
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
                              onPressed: () {},
                              child: Text("ID : " + currentLine),
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
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.8,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child:
                            const DebugConsoleScreen(), // hoặc build nội dung trực tiếp
                      ),
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
