import 'package:flutter/material.dart';
import 'package:godey/const/constant.dart';
import 'package:godey/responsive/constants.dart';
import 'package:godey/widgets/all_chart.dart';
import 'package:godey/widgets/donut_chart.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text(
          'Desktop scaffold',
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.w900,
          ),
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
                padding: const EdgeInsets.all(30.0),
                child: myDesktopDrawer(
                  context,
                  onLineSelected: (lineId) {
                    setState(() {
                      currentLine = lineId;
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
                            Text("ADMIN", style: TextStyle()),
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
                                hintStyle: TextStyle(color: textColor),
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
                                    child: Icon(Icons.search, color: textColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                                  Text("Devices"),
                                  SizedBox(height: 20),
                                  AllCharts(lineId: currentLine),
                                ],
                              )
                              : const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  "Chọn một line để hiển thị biểu đồ",
                                  style: TextStyle(
                                    color: Colors.white,
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Text(
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                "Total part",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5),

                    Row(children: [Text("Unit"), Icon(Icons.arrow_drop_down)]),
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
                              backgroundColor: cardBackgroundColor,
                              foregroundColor: primaryColor,
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
                              foregroundColor: primaryColor,
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
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 215, 210, 210),
                            offset: const Offset(5.0, 5.0),
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          SizedBox(
                            child: ErrorDonutChart(errorData: errorList),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
