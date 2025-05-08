
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:godey/config.dart';
import 'package:godey/const/constant.dart';
import 'package:godey/services/log_service.dart';
import 'package:godey/widgets/line_show.dart';
import 'package:http/http.dart' as http;
// ignore: unused_element
late Future<List<Map<String, dynamic>>> _futureLines;
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
