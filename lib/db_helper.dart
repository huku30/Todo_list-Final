import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE tasks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          isDone INTEGER
        )
      ''');
    });
  }

  Future<int> insertTask(String title) async {
    final db = await database;
    return await db.insert('tasks', {'title': title, 'isDone': 0});
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db.query('tasks');
  }

  Future<int> updateTask(int id, int isDone) async {
    final db = await database;
    return await db.update(
      'tasks',
      {'isDone': isDone},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTaskTitle(int id, String title) async {
    final db = await database;
    return await db.update(
      'tasks',
      {'title': title},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
