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
    await db.execute('''
    CREATE TABLE category_allocation(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE,
      amount INTEGER
    )
  ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE payment(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        category INTEGER,
        amount INTEGER
      )
    ''');
    }
  }

  static Future<void> deleteDatabaseFile() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'income_database.db');

    await deleteDatabase(path);

    _database = null;
  }

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

  Future<int> queryTotalPayment() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT SUM(amount) AS total FROM payment',
    );

    final total = result.first['total'] as int?;
    return total ?? 0;
  }

  Future<void> upsertCategoryAllocation(String name, int amount) async {
    final db = await database;
    await db.insert('category_allocation', {
      'name': name,
      'amount': amount,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, int>> getAllCategoryAllocations() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'category_allocation',
    );
    return {
      for (var row in result) row['name'] as String: row['amount'] as int,
    };
  }

  Future<int> queryTotalIncomeByCategory(int categoryId) async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT SUM(amount) AS total FROM income WHERE category = ?',
      [categoryId],
    );

    final total = result.first['total'] as int?;
    return total ?? 0;
  }

  Future<int> queryTotalPaymentByCategory(int categoryId) async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT SUM(amount) AS total FROM payment WHERE category = ?',
      [categoryId],
    );

    final total = result.first['total'] as int?;
    return total ?? 0;
  }

  Future<int> querySavingAllocation() async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query(
      'category_allocation',
      columns: ['amount'],
      where: 'name = ?',
      whereArgs: ['貯金'],
    );

    if (result.isNotEmpty) {
      return result.first['amount'] as int;
    } else {
      return 0;
    }
  }
}
