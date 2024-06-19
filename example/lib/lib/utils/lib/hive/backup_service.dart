import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'task.dart';

class BackupService {
  final Box<Task> _taskBox = Hive.box<Task>('tasks');

  // Export data to JSON
  Future<String> exportData() async {
    final tasks = _taskBox.values.toList();
    final jsonTasks = tasks.map((task) => task.toJson()).toList();
    return jsonEncode(jsonTasks);
  }

  // Import data from JSON
  Future<void> importData(String jsonString) async {
    final jsonTasks = jsonDecode(jsonString) as List;
    final tasks = jsonTasks.map((json) => Task.fromJson(json)).toList();

    // Clear existing tasks and add new ones
    await _taskBox.clear();
    for (var task in tasks) {
      await _taskBox.add(task);
    }
  }

  // Save JSON to a file in the downloads directory
  Future<void> saveBackupToFile() async {
    final jsonString = await exportData();
    final directory = await getExternalStorageDirectory();
    final downloadsDirectory = Directory('${directory!.path}/Download');
    if (!await downloadsDirectory.exists()) {
      await downloadsDirectory.create(recursive: true);
    }
    final filePath = '${downloadsDirectory.path}/backup.json';
    final file = File(filePath);
    await file.writeAsString(jsonString);
  }

  // Load JSON from a file in the downloads directory
  Future<void> loadBackupFromFile() async {
    final directory = await getExternalStorageDirectory();
    final downloadsDirectory = Directory('${directory!.path}/Download');
    final filePath = '${downloadsDirectory.path}/backup.json';
    final file = File(filePath);
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      await importData(jsonString);
    }
  }
}
