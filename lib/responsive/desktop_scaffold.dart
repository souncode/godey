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
  String currentLine = ""; // Biến lưu line được chọn

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
            // Drawer bên trái
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

            // Biểu đồ chính giữa
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(children: [
                      Column(
                          children: [
                            Text("ADMIN",style: TextStyle(
                              
                            ),),
                            Row(children: [
                              Text("Logged",style: TextStyle(fontSize: 8),),
                              Icon(Icons.verified,size: 6,color: Colors.blue,)
                            ],),
                 
                          ],
                        ),
                        SizedBox(width: 10,),
                        Expanded(child: SizedBox(height: 50,child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: TextStyle(color: textColor),
                              fillColor: secondaryCardColor,
                              filled: true,
                              border:OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              )
                            ),
                          ),
                        ),))
                    ],
                    ),
                    if (currentLine.isNotEmpty)
                      Column(
                        children: [Row(
                    children: [
                      Text("Devices"),
                    ],
                  ),
                          AllCharts(lineId: currentLine),
                        ],
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Chọn một line để hiển thị biểu đồ",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Biểu đồ lỗi bên phải
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        style: TextStyle(
                        
                        ),
                        "Total"
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: secondaryCardColor,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 215, 210, 210),
                            offset: const Offset(5.0, 5.0), //Offset
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                    
                      child: Column(
                        children: [
                          SizedBox(child: ErrorDonutChart(errorData: errorList)),
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
