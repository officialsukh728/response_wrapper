import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sample/business_logics/service/injector.dart';
import 'package:sample/utils/common/app_config.dart';
import 'package:sample/utils/common/app_snackbar.dart';
import 'package:sample/utils/lib/hive/backup_service.dart';
import 'task.dart'; // Import your model class

void main() async {

// /// It initializes the dependency injection using [AppInjector.init] and runs the app.
// Future<void> main() async => await AppInjector.init(
//       appRunner: () => runApp(const MyApp()),
//     );

  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();

  // Create a custom directory for Hive
  final customDirectory = Directory('${appDocumentDirectory.path}/TaskManager');
  if (!await customDirectory.exists()) {
    await customDirectory.create(recursive: true);
  }

  // Initialize Hive with the custom directory
  await Hive.initFlutter(customDirectory.path);

  // Register your Hive adapter
  Hive.registerAdapter(TaskAdapter());
  // Open the tasks box
  await Hive.openBox<Task>('tasks');
  await AppInjector.init(
      appRunner: () => runApp(const MyApp()),
    );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Initialize app configuration
    AppConfig.init(context);

    return MaterialApp(
      title: 'Hive Example',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Task Manager'),
          actions: [
            IconButton(
              icon: Icon(Icons.backup),
              onPressed: () async {
                try {
                  final backupService = BackupService();
                  await backupService.saveBackupToFile();
                  showSnackBar(message: 'Backup saved');
                } catch (e,s) {
                  print(e.toString()+s.toString());
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.restore),
              onPressed: () async {
                try {
                  final backupService = BackupService();
                  await backupService.loadBackupFromFile();
                  showSnackBar(message: 'Data restored ');
                } catch (e,s) {
                  print(e.toString()+s.toString());
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: TaskListWidget()),
            AddTaskForm(),
          ],
        ),
      ),
    );
  }
}

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final taskBox = Hive.box<Task>('tasks');

    return StreamBuilder<BoxEvent>(
        stream: taskBox.watch(),
        builder: (context, box) {
        return ListView.builder(
          itemCount: taskBox.length,
          itemBuilder: (context, index) {
            final task = taskBox.getAt(index)!;
            return ListTile(
              title: Text(task.title),
              leading: Checkbox(
                value: task.completed,
                onChanged: (value) {
                  task.completed = value!;
                  task.save();
                },
              ),
            );
          },
        );
      }
    );
  }
}
class AddTaskForm extends StatefulWidget {
  const AddTaskForm({super.key});

  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter task'),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              if(_controller.text.isEmpty)return;
              final taskBox = Hive.box<Task>('tasks');
              final task = Task(_controller.text);
              taskBox.add(task);
              _controller.clear();
            },
            child: Text('Add Task'),
          ),
        ],
      ),
    );
  }
}
