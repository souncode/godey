import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:godey/widgets/line_show.dart';
import 'package:http/http.dart' as http;
import 'package:godey/config.dart';

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
late TextEditingController registerController;

late TextEditingController LineIDController;
late TextEditingController statController;
late TextEditingController typeController;
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

void addDevice(String line, String stat, String type, String time) async {
  try {
    print("On select line :" + line);
    var regBody = {"line": line, "stat": stat, "type": type, "time": time};
    var response = await http.post(
      Uri.parse(registrationdv),
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
  required Function(String) onLineNameSelected,
}) {
  return Drawer(
    backgroundColor: cardBackgroundColor,
    child: Container(
      child: Column(
        children: [
          const DrawerHeader(child: Icon(Icons.heart_broken)),
          Expanded(
            child: LineListWidget(key: _listKey, onLineTap: onLineSelected,onLineNameTap: onLineNameSelected),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Add Line"),
            onTap: () {
              registerController = TextEditingController();
              registerLineDialog(context);
              Navigator.pop(context, true);
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
          child: LineListWidget(key: _listKey, onLineTap: onLineSelected,onLineNameTap: onLineNameSelected),
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
              Navigator.pop(context, true);
            },
          ),
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
              Navigator.pop(context, true);
            },
            child: Text('Register'),
          ),
        ],
      ),
);

Future registerDeviceDialog(
  context,
  LineIDConttroller,
  statController,
  typeController,
  String LineNow,
) => showDialog(
  context: context,
  builder:
      (context) => AlertDialog(
        title: Column(
          children: [
            Text('Add Device', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          children: [
            TextField(
              controller: LineIDController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Line ID",

                hintText: LineNow,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: statController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Station",
                hintText: 'Enter Station',
              ),
            ),
            SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: selectedDeviceType,
              items:
                  deviceTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                selectedDeviceType = newValue;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Device Type",
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3), // bỏ bo tròn
                    ),
                    backgroundColor: cardBackgroundColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    print("Press :" + (selectedDeviceType ?? ''));
                    addDevice(
                      LineNow,
                      statController.text,
                      (selectedDeviceType ?? ''),
                      DateTime.now().toString(),
                    );
                    Navigator.pop(context, true);
                  },
                  child: Text('Add'),
                ),
              ),
              SizedBox(width: 20),

              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3), // bỏ bo tròn
                    ),
                    backgroundColor: cardBackgroundColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        ],
      ),
);

Future registerDeviceErrDialog(context) => showDialog(
  context: context,
  builder:
      (context) => AlertDialog(
        title: Column(
          children: [
            Text('Error', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text("Please select Line"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('Return'),
          ),
        ],
      ),
);


