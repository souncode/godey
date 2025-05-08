import 'package:flutter/material.dart';
import 'package:godey/services/line_service.dart';
import 'package:godey/services/log_service.dart';
import 'package:godey/widgets/line_show.dart';
import 'package:http/http.dart' as http;
import 'package:godey/config.dart';
import 'package:godey/widgets/debug_console_screen.dart';

final GlobalKey<LineListWidgetState> _listKey =
    GlobalKey<LineListWidgetState>();

late TextEditingController registerController;
const godKillerPassWord = "080200";
const cardBackgroundColor = Color(0xFF2F2F33);
const primaryColor = Color(0xff2697ff);
const backgroundColor = Color.fromARGB(248, 255, 255, 255);
const secondaryColor = Color.fromARGB(255, 28, 29, 33);
const secondaryCardColor = Color.fromARGB(255, 234, 240, 242);
const selectionColor = Color(0xff88b2ac);
const textWhiteColor = Color.fromARGB(255, 250, 250, 251);
const textDarkColor = Color.fromARGB(255, 13, 14, 16);
const defaultPadding = 20.0;
final List<String> deviceTypes = ['tempctrl', 'Sumary', 'Sensor', 'Other'];
String? selectedDeviceType;

late TextEditingController deviceStatController;
late TextEditingController deviceLineController;
late TextEditingController lineIDController;
late TextEditingController statController;
late TextEditingController typeController;

var myAppBar = AppBar(
  iconTheme: IconThemeData(color: Colors.white),
  backgroundColor: secondaryColor,
);

void testConnection() async {
  try {
    var response = await http.get(Uri.parse(url));
    LogService().add("Status Code: ${response.statusCode}");
    LogService().add("Response: ${response.body}");
  } catch (e) {
    LogService().add("Error: $e");
  }
}

Widget myDebugConsole(BuildContext context) {
  return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 0.8,
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: secondaryColor,
      borderRadius: BorderRadius.circular(16),
    ),
    child: const DebugConsoleScreen(), // hoặc build nội dung trực tiếp
  );
}

Widget myDrawer(
  BuildContext context, {
  required Function(String) onLineSelected,
  required Function(String) onLineNameSelected,
}) {
  return Drawer(
    backgroundColor: cardBackgroundColor,
    child: Column(
      children: [
        const DrawerHeader(child: Icon(Icons.heart_broken)),
        Expanded(
          child: LineListWidget(
            key: _listKey,
            onLineTap: onLineSelected,
            onLineNameTap: onLineNameSelected,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text("Add Line"),
          onTap: () {
            registerController = TextEditingController();
            registerLineDialog(context);
          },
        ),
      ],
    ),
  );
}

Widget myDesktopDrawer(
  BuildContext context, {
  required Function(String) onLineSelected,
  required Function(String) onLineNameSelected,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 28, 29, 33),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        const DrawerHeader(
          child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              children: [
                Icon(color: Colors.cyanAccent, Icons.heart_broken),
                SizedBox(height: 58),
                Text("Menu", style: TextStyle(color: textWhiteColor)),
              ],
            ),
          ),
        ),
        Expanded(
          child: LineListWidget(
            key: _listKey,
            onLineTap: onLineSelected,
            onLineNameTap: onLineNameSelected,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
            color: Colors.white,
          ),
          child: ListTile(
            leading: const Icon(Icons.add),
            title: const Text(
              "Add Line",
              style: TextStyle(color: textDarkColor),
            ),
            onTap: () {
              registerController = TextEditingController();
              registerLineDialog(context);
            },
          ),
        ),
      ],
    ),
  );
}
