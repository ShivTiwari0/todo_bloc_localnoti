import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shivansh_quantum_it/data/model/task_model.dart';
import 'package:sqflite/sqflite.dart';


class DbHelper {
  DbHelper._();
  static final DbHelper getInstance = DbHelper._();

  static final String TABLE_TASK = "task";
  static final String ID = "id";
  static final String TITLE = "title";
  static final String DESCRIPTION = "description";
  static final String PRIORITY = "priority";
  static final String DUEDATE = "dueDate";
  static final String REMINDER = "reminder";
  static final String ISCOMPLETED = "isCompleted";

  Database? myDb;

  // Singleton for database access
  Future<Database> getDb() async {
    myDb??= await openDb();
    log("DataBase Opened");
    return myDb!; 
  }

  // Creating/opening the database
  Future<Database> openDb() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "taskDB.db");

    return await openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute('''
          CREATE TABLE $TABLE_TASK (
            $ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $TITLE TEXT,
            $DESCRIPTION TEXT,
            $PRIORITY INTEGER,
            $DUEDATE TEXT,
            $REMINDER TEXT,
            $ISCOMPLETED INTEGER
          )
      '''); log("DataBase  Created");

    });
  }

  // Inserting a task
  Future<int> insertTask(TaskModel task) async {
    Database db = await getDb();
    return await db.insert(
      TABLE_TASK,
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
  }

  // Retrieving all tasks
  Future<List<TaskModel>> getTasks() async {
    Database db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query(TABLE_TASK);

    return List.generate(maps.length, (i) {
      return TaskModel.fromJson(maps[i]);
    });
  }

  // Updating a task
Future<int> updateTask(TaskModel task) async {
  try {
    Database db = await getDb();
    final result = await db.update(
      TABLE_TASK,
      task.toJson(),
      where: '$ID = ?',
      whereArgs: [task.id],
    );
    if (result == 0) {
      log("Update failed, no task updated");
    } else {
      log("Task updated successfully");
    }
    return result;
  } catch (e) {
    log("Error updating task: $e");
    rethrow;
  }
}


  // Deleting a task
  Future<void> deleteTask(int id) async {
    Database db = await getDb();
    await db.delete(
      TABLE_TASK,
      where: '$ID = ?',
      whereArgs: [id],
    );
  }

  // Retrieving a task by ID
  Future<TaskModel?> getTaskById(int id) async {
    Database db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      TABLE_TASK,
      where: '$ID = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TaskModel.fromJson(maps.first);
    }
    return null;
  }
}
