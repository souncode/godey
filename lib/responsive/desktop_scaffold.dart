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
      backgroundColor: secondaryColor,
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
            child: Container(
              color: const Color.fromARGB(255, 77, 93, 93),
              child: Column(
                children: [
                  SizedBox(child: ErrorDonutChart(errorData: errorList)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
