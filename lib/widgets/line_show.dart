import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:godey/config.dart';
import 'package:godey/const/constant.dart';
import 'package:http/http.dart' as http;

class LineListWidget extends StatefulWidget {
  final void Function(String) onLineTap;

  const LineListWidget({super.key, required this.onLineTap});

  @override
  State<LineListWidget> createState() => LineListWidgetState();
}

Future<List<Map<String, dynamic>>> fetchLines() async {
  try {
    var response = await http.post(Uri.parse(getlinecfg));

    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      if (decoded['status'] == true && decoded['success'] is List) {
        List<dynamic> data = decoded['success'];
        return data
            .where((line) => line['name'] != null && line['_id'] != null)
            .map<Map<String, dynamic>>(
              (line) => {'id': line['_id'], 'name': line['name']},
            )
            .toList();
      }
      return [];
    } else {
      print("Error: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("Exception: $e");
    return [];
  }
}

class LineListWidgetState extends State<LineListWidget> {
  late Future<List<Map<String, dynamic>>> _futureLines;

  @override
  void initState() {
    super.initState();
    _futureLines = fetchLines();
  }

  void refreshLines() {
    setState(() {
      _futureLines = fetchLines();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureLines,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No lines found.');
        }

        final lines = snapshot.data!;
        return ListView.builder(
          itemCount: lines.length,
          itemBuilder: (context, index) {
            final line = lines[index];
            return ListTile(
              leading: const Icon(Icons.monitor_heart),
              title: Text(
                line['name'].toString().toUpperCase(),
                style: const TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                widget.onLineTap(line['id']); // ✅ Gọi callback
              },
            );
          },
        );
      },
    );
  }
}
