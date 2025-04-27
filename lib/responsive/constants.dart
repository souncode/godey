import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:godey/const/constant.dart';
import 'package:godey/widgets/line_show.dart';
import 'package:http/http.dart' as http;
import 'package:godey/config.dart';

final GlobalKey<LineListWidgetState> _listKey =
    GlobalKey<LineListWidgetState>();

var myAppBar = AppBar(
  iconTheme: IconThemeData(color: Colors.white),
  backgroundColor: secondaryColor,
);

void registerLine(String name) async {
  try {
    var regBody = {"name": name};
    var response = await http.post(
      Uri.parse(registration),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );

    if (response.statusCode == 200) {
      print("Success: ${response.body}");
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e, stackTrace) {
    print("Exception: $e");
    print(stackTrace);
  }
}

late TextEditingController registerController;
void testConnection() async {
  try {
    var response = await http.get(Uri.parse(url));
    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");
  } catch (e) {
    print("Error: $e");
  }
}

Widget myDrawer(
  BuildContext context, {
  required Function(String) onLineSelected,
}) {
  return Drawer(
    width: 250,
    backgroundColor: Color.fromARGB(2255, 28, 29, 33),
    child: Container(
      child: Column(
        children: [
          const DrawerHeader(child: Icon(Icons.heart_broken)),
          Expanded(
            child: LineListWidget(
              key: _listKey,
              onLineTap: onLineSelected, // ✅ THÊM DÒNG NÀY
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
    ),
  );
}

Widget myDesktopDrawer(
  BuildContext context, {
  required Function(String) onLineSelected,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 28, 29, 33),
      borderRadius: BorderRadius.circular(30),
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
                Text("Menu", style: TextStyle(color: textColor)),
              ],
            ),
          ),
        ),
        Expanded(
          child: LineListWidget(
            key: _listKey,
            onLineTap: onLineSelected, // ✅ THÊM DÒNG NÀY
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

Future registerLineDialog(context) => showDialog(
  context: context,
  builder:
      (context) => AlertDialog(
        title: Text('Line Register'),
        content: TextField(
          controller: registerController,
          decoration: InputDecoration(hintText: 'Enter Line'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              registerLine(registerController.text);
              _listKey.currentState?.refreshLines();
            },
            child: Text('Register'),
          ),
        ],
      ),
);
