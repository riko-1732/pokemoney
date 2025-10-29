import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'src/database/database_helper.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.deleteDatabaseFile(); // ← 一度DBを削除
  runApp(const MyApp());
}
