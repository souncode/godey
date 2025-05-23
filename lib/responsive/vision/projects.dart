import 'package:flutter/material.dart';
import 'package:godey/responsive/vision/project_new.dart';


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
        Expanded(child: Container(color: Colors.blue, child: Upload())),
      ],
    );
  }
}
