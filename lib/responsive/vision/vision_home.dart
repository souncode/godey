import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:godey/const/constant.dart';

import 'package:godey/responsive/vision/vision_labeling.dart';

class VisionHomePage extends StatefulWidget {
  const VisionHomePage({super.key});

  @override
  State<VisionHomePage> createState() => _VisionHomePageState();
}

class _VisionHomePageState extends State<VisionHomePage> {
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
            SizedBox(width: 100),
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
                      onPressed: () {},
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
                      onPressed: () {},
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
                      onPressed: () {},
                      child: Icon(color: textDarkColor, Icons.star),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Labeling()),
        ],
      ),
    );
  }
}
