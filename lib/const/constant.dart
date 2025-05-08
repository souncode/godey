import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:godey/services/log_service.dart';
import 'package:godey/widgets/line_show.dart';
import 'package:http/http.dart' as http;
import 'package:godey/config.dart';
import 'package:godey/widgets/debug_console_screen.dart';

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
late TextEditingController registerController;
late TextEditingController lineNameController;
late TextEditingController deviceStatController;
late TextEditingController deviceLineController;
late TextEditingController lineIDController;
late TextEditingController statController;
late TextEditingController typeController;
late Future<List<Map<String, dynamic>>> _futureLines;
final GlobalKey<LineListWidgetState> _listKey =
    GlobalKey<LineListWidgetState>();

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

Future<bool> registerLine(String name) async {
  try {
    var regBody = {"name": name};
    var response = await http.post(
      Uri.parse(registration),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        LogService().add(
          "Line registration successful: ${data['message'] ?? response.body}",
        );
        return true;
      } else {
        LogService().add(
          "Line registration failed: ${data['message'] ?? 'Unknown error'}",
        );
        return false;
      }
    } else {
      LogService().add("HTTP error ${response.statusCode}: ${response.body}");
      return false;
    }
  } catch (e, stackTrace) {
    LogService().add("Exception: $e");
    LogService().add("Exception: $e");
    LogService().add("StackTrace: $stackTrace");
    return false;
  }
}

Future<bool> deleteLine(String id) async {
  try {
    final response = await http.post(
      Uri.parse(deleteLinecfg),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        LogService().add("Deleted line with ID $id successfully.");
        return true;
      } else {
        LogService().add(
          "Delete line failed: ${data['message'] ?? 'Unknown error'}",
        );
        return false;
      }
    } else {
      LogService().add("Delete line failed with status ${response.statusCode}");
      return false;
    }
  } catch (e) {
    LogService().add("Exception during delete line: $e");
    return false;
  }
}

Future<bool> editLine(String id, String name) async {
  try {
    final response = await http.post(
      Uri.parse(editLinecfg),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id, "name": name}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        LogService().add("Rename Line with ID $id successfully.");
        return true;
      } else {
        LogService().add(
          "Rename device failed: ${data['message'] ?? 'Unknown error'}",
        );
        return false;
      }
    } else {
      LogService().add("Rename Line failed with status ${response.statusCode}");
      return false;
    }
  } catch (e) {
    LogService().add("Exception during rename line: $e");
    return false;
  }
}

Future<bool> deleteDevice(String id) async {
  try {
    final response = await http.post(
      Uri.parse(deleteDevicecfg),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        LogService().add("Deleted device with ID $id successfully.");
        return true;
      } else {
        LogService().add(
          "Delete device failed: ${data['message'] ?? 'Unknown error'}",
        );
        return false;
      }
    } else {
      LogService().add(
        "Delete device failed with status ${response.statusCode}",
      );
      return false;
    }
  } catch (e) {
    LogService().add("Exception during delete line: $e");
    return false;
  }
}

Future<bool> editDevice(String id, String line, String name) async {
  try {
    final response = await http.post(
      Uri.parse(editDevicecfg),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id, "line": line, "stat": name}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        LogService().add("Update Device with ID $id successfully.");
        return true;
      } else {
        LogService().add(
          "Update device failed: ${data['message'] ?? 'Unknown error'}",
        );
        return false;
      }
    } else {
      LogService().add(
        "Update device failed with status ${response.statusCode}",
      );
      return false;
    }
  } catch (e) {
    LogService().add("Exception during update device: $e");
    return false;
  }
}

Future<bool> addDevice(
  String line,
  String stat,
  String type,
  String time,
) async {
  try {
    Map<String, dynamic> regBody;
    LogService().add("On select line: $line");
    var random = Random();
    if (type == "tempctrl") {
      regBody = {
        "line": line,
        "stat": stat,
        "type": type,
        "time": time,
        "ctrl": [
          {
            "inde": "Test1",
            "temp": random.nextInt(100).toString(),
            "setv": "20",
            "offs": "2",
          },
          {
            "inde": "Test2",
            "temp": random.nextInt(100).toString(),
            "setv": "20",
            "offs": "2",
          },
          {
            "inde": "Test3",
            "temp": random.nextInt(100).toString(),
            "setv": "20",
            "offs": "2",
          },
          {
            "inde": "Test4",
            "temp": random.nextInt(100).toString(),
            "setv": "20",
            "offs": "2",
          },
        ],
      };
    } else {
      regBody = {"line": line, "stat": stat, "type": type, "time": time};
    }

    final response = await http.post(
      Uri.parse(registrationdv),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        LogService().add(
          "Device registration successful: ${data['message'] ?? response.body}",
        );
        return true;
      } else {
        LogService().add(
          "Device registration failed: ${data['message'] ?? 'Unknown error'}",
        );
        return false;
      }
    } else {
      LogService().add("HTTP error ${response.statusCode}: ${response.body}");
      return false;
    }
  } catch (e, stackTrace) {
    LogService().add("Exception: $e");
    LogService().add("Exception: $e");
    LogService().add("StackTrace: $stackTrace");
    return false;
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
              final success = await registerLine(registerController.text);
              if (!context.mounted) return;
              if (success) {
                _listKey.currentState?.refreshLines();
                Navigator.pop(context, true);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Line Added')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to fetch line')),
                );
                Navigator.pop(context, true);
              }
            },
            child: Text('Register'),
          ),
        ],
      ),
);

Future renameLineDialog(context, String id) => showDialog(
  context: context,
  builder: (context) {
    lineNameController = TextEditingController();

    return AlertDialog(
      title: Text('Update Line'),
      content: TextField(
        controller: lineNameController,
        decoration: InputDecoration(hintText: 'Name'),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final success = await editLine(id, lineNameController.text);
            if (!context.mounted) return;
            if (success) {
              _listKey.currentState?.refreshLines();
              Navigator.pop(context, true);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Line Updated')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fail to Update Line')),
              );
              Navigator.pop(context, true);
            }
          },
          child: Text('Update'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text('Close'),
        ),
      ],
    );
  },
);

Future updateDeviceDialog(BuildContext context, String id) {
  final TextEditingController deviceStatController = TextEditingController();
  String? selectedLine;
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Cập nhật thiết bị'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchLines(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Lỗi khi tải Line');
                  } else {
                    final lineData = snapshot.data!;
                    final lineIds =
                        lineData.map((item) => item['id'] as String).toList();
                    final lineNames =
                        lineData.map((item) => item['name'] as String).toList();

                    return DropdownButtonFormField<String>(
                      value: selectedLine,
                      decoration: const InputDecoration(
                        labelText: 'Line',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          lineNames
                              .map(
                                (line) => DropdownMenuItem<String>(
                                  value: line,
                                  child: Text(line),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        final selectedId = lineIds[lineNames.indexOf(value!)];
                        selectedLine = selectedId;
                      },
                    );
                  }
                },
              ),

              const SizedBox(height: 16),
              TextField(
                controller: deviceStatController,
                decoration: const InputDecoration(
                  labelText: 'Station',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (selectedLine == null || deviceStatController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fullfill infomation')),
                );
                return;
              }

              final success = await editDevice(
                id,
                selectedLine!,
                deviceStatController.text,
              );

              if (!context.mounted) return;

              Navigator.pop(context, true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success ? 'Updated' : 'Update fail'),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            },
            child: const Text('Update'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

Future registerDeviceDialog(
  context,
  lineIDConttroller,
  statController,
  typeController,
  String lineNow,
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
              controller: lineIDController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Line ID",
                hintText: lineNow,
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
                      borderRadius: BorderRadius.circular(3),
                    ),
                    backgroundColor: cardBackgroundColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    _futureLines = fetchLines();
                    final success = await addDevice(
                      lineNow,
                      statController.text,
                      (selectedDeviceType ?? ''),
                      DateTime.now().toString(),
                    );

                    if (!context.mounted) return;

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Added device")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Add device fail")),
                      );
                    }

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
                      borderRadius: BorderRadius.circular(3),
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

Future registerDeviceErrDialog(BuildContext context) => showDialog(
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
