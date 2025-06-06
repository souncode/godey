import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:godey/const/constant.dart';
import 'package:godey/responsive/desktop_scaffold.dart';
import 'package:godey/responsive/vision/projects.dart';

import 'package:godey/responsive/vision/vision_labeling.dart';

class VisionHomePage extends StatefulWidget {
  final String projectId;
  final int index;

  const VisionHomePage({
    super.key,
    required this.projectId,
    required this.index,
  });

  @override
  State<VisionHomePage> createState() => _VisionHomePageState();
}

class _VisionHomePageState extends State<VisionHomePage> {
  int _currentPage = 1;
  String _currentProject = "";
  @override
  void initState() {
    super.initState();
    print("Current Project :" + widget.projectId);
    _currentPage = widget.index;
    _currentProject = widget.projectId;
  }

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
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            SizedBox(width: 41),
            SizedBox(
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DesktopScaffold(),
                      ),
                    );
                  }
                },
                child: const Text(
                  'IOT Dash Board',
                  style: TextStyle(
                    color: textDarkColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            SizedBox(
              height: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 140, 156, 163),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Vision',
                  style: TextStyle(
                    color: textDarkColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          Container(
            width: 50,
            color: const Color.fromARGB(198, 28, 29, 33),
            child: Column(
              children: [
                SizedBox(height: 5),
                SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentPage = 1;
                        });
                      },
                      child: Icon(color: textDarkColor, Icons.folder),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentPage = 2;
                        });
                      },
                      child: Icon(color: textDarkColor, Icons.new_label),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentPage = 3;
                        });
                      },
                      child: Icon(color: textDarkColor, Icons.model_training),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentPage = 4;
                        });
                      },
                      child: Icon(color: textDarkColor, Icons.star),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 50,
            child: Container(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotatedBox(
                    quarterTurns: 3, // Xoay 270 độ = văn bản dọc từ dưới lên
                    child: Text(
                      (_currentPage == 1)
                          ? 'Projects'
                          : (_currentPage == 2)
                          ? 'Labeling'
                          : (_currentPage == 3)
                          ? '3'
                          : '4',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child:
                (_currentPage == 1)
                    ? (Projects())
                    : (_currentPage == 2)
                    ? Labeling(
                      projectId: _currentProject,
                      userId: "6831f177ead28d72e8803dc8",
                    )
                    : Container(),
          ),
        ],
      ),
    );
  }
}
