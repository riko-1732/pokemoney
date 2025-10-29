import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'income_database.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE income(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        category INTEGER,
        amount INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE payment(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        category INTEGER,
        amount INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 古いバージョンから新しいバージョンにアップデートする場合の処理
    if (oldVersion < 2) {
      // バージョン2でpaymentテーブルを追加
      await db.execute('''
      CREATE TABLE payment(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        category INTEGER,
        amount INTEGER
      )
    ''');
      // 注意: IncomePageのテーブル名を変更した場合は、ここも修正が必要です。
      // 例: 旧テーブル名がexpenseで、paymentに変更した場合など。
    }
  }

  static Future<void> deleteDatabaseFile() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'income_database.db');

    await deleteDatabase(path); // データベースファイルを削除

    _database = null;
  }

  // データの挿入
  Future<int> insertIncome(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('income', row);
  }

  Future<int> insertPayment(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('payment', row);
  }

  Future<int> queryTotalIncome() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT SUM(amount) AS total FROM income',
    );

    final total = result.first['total'] as int?;
    return total ?? 0;
  }

  Future<int> queryTotalExpense() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT SUM(amount) AS total FROM payment',
    );

    final total = result.first['total'] as int?;
    return total ?? 0;
  }
}
