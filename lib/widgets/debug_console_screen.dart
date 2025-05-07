import 'package:flutter/material.dart';
import 'package:godey/const/constant.dart';
import '../services/log_service.dart';

class DebugConsoleScreen extends StatefulWidget {
  const DebugConsoleScreen({super.key});

  @override
  State<DebugConsoleScreen> createState() => _DebugConsoleScreenState();
}

class _DebugConsoleScreenState extends State<DebugConsoleScreen> {
  final ScrollController _scrollController = ScrollController();
  final LogService _logService = LogService();

  @override
  void initState() {
    super.initState();
    _logService.addListener(_onLogUpdated);
  }

  void _onLogUpdated() {
    if (mounted) setState(() {});
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _logService.removeListener(_onLogUpdated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logs = _logService.logs;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Row(
          children: [
            Icon(Icons.bug_report_sharp, color: Colors.redAccent),
            SizedBox(width: 20),
            Text(
              "Debug Console",
              style: TextStyle(
                color: Colors.lightGreenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.amberAccent),
            onPressed: () => _logService.clear(),
          ),
        ],
      ),
      backgroundColor: secondaryColor,
      body: ListView.builder(
        controller: _scrollController,
        itemCount: logs.length,
        itemBuilder: (context, index) {
          return Text(
            logs[index],
            style: const TextStyle(color: Colors.greenAccent, fontSize: 14),
          );
        },
      ),
    );
  }
}
