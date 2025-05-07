import 'package:flutter/material.dart';
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

    // Tự động cuộn xuống cuối
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
        title: const Text("Debug Console"),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => _logService.clear(),
          ),
        ],
      ),
      backgroundColor: Colors.black,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _logService.add("User manually added a log"),
        child: const Icon(Icons.add),
      ),
    );
  }
}
