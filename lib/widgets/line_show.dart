import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:godey/config.dart';
import 'package:godey/const/constant.dart';
import 'package:godey/services/log_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

class LineListWidget extends StatefulWidget {
  final void Function(String) onLineTap;
  final void Function(String) onLineNameTap;

  const LineListWidget({
    super.key,
    required this.onLineTap,
    required this.onLineNameTap,
  });

  @override
  State<LineListWidget> createState() => LineListWidgetState();
}

Future<List<Map<String, dynamic>>> fetchLines() async {
  try {
    var response = await http.post(Uri.parse(getlinecfg));

    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      LogService().add("Fetch line success");
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
      LogService().add("Error: ${response.statusCode}");
      LogService().add("Error: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    LogService().add("Exception: $e");
    LogService().add("Exception: $e");
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
            return Slidable(
              key: const ValueKey(0),

              startActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) async {
                      if (!context.mounted) return;

                      final success = await renameLineDialog(
                        context,
                        line['id'],
                      );
                      if (success) {
                        refreshLines();
                      } else {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to rename line'),
                          ),
                        );
                      }
                    },
                    backgroundColor: Color.fromARGB(255, 26, 183, 99),
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                ],
              ),

              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) async {
                      if (!context.mounted) return;

                      final success = await deleteLine(line['id']);
                      if (success) {
                        refreshLines();
                      } else {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to delete line'),
                          ),
                        );
                      }
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Container(
                color: backgroundColor,
                child: ListTile(
                  hoverColor: Colors.white,
                  leading: const Icon(Icons.monitor_heart),
                  trailing: Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: secondaryColor,
                          child: const Icon(Icons.arrow_left),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    line['name'].toString().toUpperCase(),
                    style: const TextStyle(
                      color: textDarkColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    widget.onLineTap(line['id']);
                    widget.onLineNameTap(line['name']);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
