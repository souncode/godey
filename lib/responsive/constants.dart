import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:godey/config.dart';

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
    surfaceTintColor: Colors.amber,
    backgroundColor: Colors.grey[300],
    child: Column(
      children: [
        const DrawerHeader(child: Icon(Icons.face)),
        const ListTile(
          leading: Icon(Icons.dashboard),
          title: Text(" D A S H B O A R D"),
        ),
        const ListTile(
          leading: Icon(Icons.remove_red_eye_outlined),
          title: Text(" V I S I O N"),
        ),
        const ListTile(
          leading: Icon(Icons.person_2_outlined),
          title: Text(" A B O U T"),
        ),
        const ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text(" E X I T"),
        ),
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text(" A D D"),
          onTap: () {
            testConnection();
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
            },
            child: Text('Register'),
          ),
        ],
      ),
);
