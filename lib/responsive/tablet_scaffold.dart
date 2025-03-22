import 'package:flutter/material.dart';
import 'package:godey/responsive/constants.dart';
import 'package:godey/widgets/chart_card.dart';
class TabletScaffold extends StatefulWidget {
  const TabletScaffold({super.key});

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
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
      // Thêm các widget khác nếu cần
    ],
  ),
    );
  }
}