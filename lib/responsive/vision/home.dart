import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:godey/const/constant.dart';
import 'package:godey/responsive/desktop_scaffold.dart';

class VisionPage extends StatefulWidget {
  const VisionPage({super.key});

  @override
  State<VisionPage> createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage> {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DesktopScaffold()),
                  );
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
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 140, 156, 163),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
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
      body: Container(
        child: Row(
          children: [
            Container(
              width: 50,
              color: const Color.fromARGB(255, 67, 172, 7),
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Icon(Icons.label),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container(color: Colors.amber, child: Column())),
            Expanded(
              child: Container(
                color: const Color.fromARGB(255, 46, 43, 33),
                child: Column(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
