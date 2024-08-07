import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'tasks.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id TEXT PRIMARY KEY, title TEXT, description TEXT, dueDate TEXT, isCompleted INTEGER)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertTask(Task task) async {
    final db = await DBHelper.database();
    await db.insert(
      'tasks',
      {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'dueDate': task.dueDate.toIso8601String(),
        'isCompleted': task.isCompleted ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateTask(Task task) async {
    final db = await DBHelper.database();
    await db.update(
      'tasks',
      {
        'title': task.title,
        'description': task.description,
        'dueDate': task.dueDate.toIso8601String(),
        'isCompleted': task.isCompleted ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<void> deleteTask(String id) async {
    final db = await DBHelper.database();
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Task>> fetchTasks() async {
    final db = await DBHelper.database();
    final taskList = await db.query('tasks');

    return taskList.map((task) {
      return Task(
        id: task['id'] as String,
        title: task['title'] as String,
        description: task['description'] as String,
        dueDate: DateTime.parse(task['dueDate'] as String),
        isCompleted: (task['isCompleted'] as int) == 1,
      );
    }).toList();
  }
}
