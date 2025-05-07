import 'package:flutter/foundation.dart';

class LogService extends ChangeNotifier {
  static final LogService _instance = LogService._internal();
  factory LogService() => _instance;

  LogService._internal();

  final List<String> _logs = [];

  List<String> get logs => List.unmodifiable(_logs);

  void add(String message) {
    final log = "[${DateTime.now().toIso8601String()}] $message";
    _logs.add(log);
    debugPrint(log); // In ra console thật
    notifyListeners(); // Báo cho UI cập nhật
  }

  void clear() {
    _logs.clear();
    notifyListeners();
  }
}
