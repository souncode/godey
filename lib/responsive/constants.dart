import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:godey/widgets/line_show.dart';
import 'package:http/http.dart' as http;
import 'package:godey/config.dart';

final GlobalKey<LineListWidgetState> _listKey =
    GlobalKey<LineListWidgetState>();

var myDefaultBackground = Colors.grey[300];
var myAppBar = AppBar(
  iconTheme: IconThemeData(color: Colors.white),
  backgroundColor: Colors.grey[900],
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

Widget myDrawer(BuildContext context) {
  return Drawer(
    width: 250,
    backgroundColor: Colors.grey[300],
    child: Column(
      children: [
        const DrawerHeader(child: Icon(Icons.heart_broken)),
        Expanded(child: LineListWidget(key: _listKey)),
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
