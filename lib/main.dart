import 'package:flutter/material.dart';
import 'package:godey/responsive/vision/vision_home.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VisionHomePage(projectId: "", index: 1),
      // home: SplashScreen(),
    );
  }
}
