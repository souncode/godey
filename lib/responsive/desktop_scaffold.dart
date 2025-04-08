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

String currentLine = "";
final List<ErrorData> errorList = [
  ErrorData('1', 30),
  ErrorData('2', 3),
  ErrorData('3', 2),
  ErrorData('4', 4),
  ErrorData('5', 1),
];

class _DesktopScaffoldState extends State<DesktopScaffold> {
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
          myDrawer(context),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [AllCharts(lineId: "67df1eee847d020add50949f")],
              ),
            ),
          ),
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
