import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:godey/config.dart';
import 'package:godey/services/log_service.dart';
import 'package:godey/widgets/line_show.dart';
import 'package:http/http.dart' as http;
late TextEditingController lineNameController;
late TextEditingController registerController;
final GlobalKey<LineListWidgetState> _listKey =
    GlobalKey<LineListWidgetState>();

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
