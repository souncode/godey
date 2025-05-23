import 'package:flutter/material.dart';
import 'package:godey/const/constant.dart';
import 'package:godey/responsive/vision/project_new.dart';
import 'package:godey/responsive/vision/project_upload.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
                    'Projects',
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
        Expanded(child: Container(color: Colors.blue, child: Upload())),
      ],
    );
  }
}
