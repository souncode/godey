import 'package:flutter/material.dart';
import 'package:godey/responsive/constants.dart';
import 'package:godey/util/my_box.dart';
import 'package:godey/util/my_tile.dart';
class MobileScaffold extends StatefulWidget {
  const MobileScaffold({super.key});

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar,
      backgroundColor: Colors.grey[300],
      drawer: myDrawer,
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: SizedBox(width: double.infinity,
            child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (context,index){
              return MyBox();
                }
              ),
            ),
          ),
          Expanded(child: ListView.builder(itemBuilder: (context, index){
            return MyTile();
          }))          
        ],
      ),
    );
  }
}