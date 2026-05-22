import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/count_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  
  DatabaseHelper._init();
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('rebar_counts.db');
    return _database!;
  }
  
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }
  
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE counts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        detected_count INTEGER NOT NULL,
        verified_count INTEGER NOT NULL,
        image_path TEXT NOT NULL,
        notes TEXT
      )
    ''');
  }
  
  Future<int> insertCount(Map<String, dynamic> count) async {
    final db = await instance.database;
    return await db.insert('counts', count);
  }
  
  Future<List<CountModel>> getAllCounts() async {
    final db = await instance.database;
    final result = await db.query('counts', orderBy: 'date DESC');
    return result.map((json) => CountModel.fromJson(json)).toList();
  }
  
  Future<List<CountModel>> getCountsByDateRange(DateTime start, DateTime end) async {
    final db = await instance.database;
    final result = await db.query(
      'counts',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );
    return result.map((json) => CountModel.fromJson(json)).toList();
  }
  
  Future<int> deleteCount(int id) async {
    final db = await instance.database;
    return await db.delete('counts', where: 'id = ?', whereArgs: [id]);
  }
  
  Future<void> initDatabase() async {
    await database;
  }
}