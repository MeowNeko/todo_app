import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/model/category_model.dart';
import 'package:todo_app/model/task_model.dart';

class DatabaseHelper {
  // static const int  _databaseVersion = 1;
  static const String _databaseName = "Todo.db";
  static const int _databaseVersion = 1;

  //General
  static Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, _) async {
        await db.execute(
          //IF NOT EXISTS (optional addi.)
          'CREATE TABLE Category (id INTEGER PRIMARY KEY, name TEXT NOT NULL)',
        );
        await db.execute(
          //IF NOT EXISTS (optional addi.)
          '''CREATE TABLE Task (
          id INTEGER PRIMARY KEY,
          category_id INTEGER NOT NULL,
          title TEXT NOT NULL,
          detail TEXT NOT NULL,
          is_checked BOOLEAN DEFAULT 0,
          created_datetime TEXT NOT NULL,
          FOREIGN KEY (category_id) REFERENCES Category(id)
        )''',
        ); //BOOLEAN IS NOT SUPPORTED (INTEGER INSTEAD) - https://github.com/tekartik/sqflite/blob/master/sqflite/doc/supported_types.md
      },
      version: _databaseVersion,
    );
  }

  static Future<void> clear() async {
    await databaseFactory
        .deleteDatabase(join(await getDatabasesPath(), _databaseName));
  }

  //Category
  static Future<int> addCategory(CategoryModel categoryModel) async {
    final Database db = await _initDatabase();
    return await db.insert(
      "Category",
      categoryModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> updateCategory(CategoryModel categoryModel) async {
    final Database db = await _initDatabase();
    return await db.update(
      "Category",
      categoryModel.toMap(),
      where: 'id = ?',
      whereArgs: [categoryModel.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> deleteCategory(CategoryModel categoryModel) async {
    final Database db = await _initDatabase();
    return await db.delete(
      "Category",
      where: 'id = ?',
      whereArgs: [categoryModel.id],
    );
  }

  static Future<List<CategoryModel>> getCategories() async {
    final Database db = await _initDatabase();

    final List<Map<String, dynamic>> maps = await db.query('Category');

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(
      maps.length,
      (index) => CategoryModel.fromMap(maps[index]),
    );
  }

  //Task
  static Future<int> addTask(TaskModel taskModel) async {
    final Database db = await _initDatabase();
    return await db.insert(
      "Task",
      taskModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> updateTask(TaskModel taskModel) async {
    final Database db = await _initDatabase();
    return await db.update(
      "Task",
      taskModel.toMap(),
      where: 'id = ?',
      whereArgs: [taskModel.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> deleteTask(TaskModel taskModel) async {
    final Database db = await _initDatabase();
    return await db.delete(
      "Task",
      where: 'id = ?',
      whereArgs: [taskModel.id],
    );
  }

  static Future<int> deleteTaskWhere(CategoryModel categoryModel) async {
    final Database db = await _initDatabase();
    return await db.delete(
      "Task",
      where: 'category_id = ?',
      whereArgs: [categoryModel.id],
    );
  }

  static Future<List<TaskModel>> getTasks() async {
    final Database db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('Task');

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(
        maps.length, (index) => TaskModel.fromMap(maps[index]));
  }
}
