import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'app_data.db');
    print('Database Path: $dbPath'); // Log the database path
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_code TEXT,
        user_display_name TEXT,
        email TEXT,
        user_employee_code TEXT,
        company_code TEXT
      )
    ''');
  }

  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('user_data', user);
  }
}
