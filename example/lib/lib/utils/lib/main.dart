import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Settings',
      themeMode: Hive.box('settings').get('darkMode', defaultValue: false)?ThemeMode.dark:ThemeMode.light,
      home: Scaffold(
        body: ValueListenableBuilder<Box>(
          valueListenable: Hive.box('settings').listenable(),
          builder: (context, box, widget) {
            return Center(
              child: Switch(
                value: box.get('darkMode', defaultValue: false),
                onChanged: (val) {
                  box.put('darkMode', val);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}