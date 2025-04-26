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
      backgroundColor: const Color.fromARGB(255, 233, 216, 216),
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          'Desktop scaffold',
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Row(
        children: [
          // Drawer bên trái
          myDrawer(
            context,
            onLineSelected: (lineId) {
              setState(() {
                currentLine = lineId;
              });
            },
          ),

          // Biểu đồ chính giữa
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (currentLine.isNotEmpty)
                    AllCharts(lineId: currentLine)
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
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 242, 250, 250),
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
            ),
          ),
        ],
      ),
    );
  }
}
