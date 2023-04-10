import 'dart:async';
import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import '../../../models/task.dart';
import 'exceptions/sqflite_exceptions.dart';

class SqfliteUtils {
  Database? _db;

  List<TaskData> _tasks = [];

  static final SqfliteUtils _shared = SqfliteUtils._sharedInstance();

  SqfliteUtils._sharedInstance() {
    _tasksStreamController = StreamController<List<TaskData>>.broadcast(
      onListen: () {
        _tasksStreamController.sink.add(_tasks);
      },
    );
  }

  factory SqfliteUtils() => _shared;

  late final StreamController<List<TaskData>> _tasksStreamController;

  Stream<List<TaskData>> get allTasks => _tasksStreamController.stream;

  Future<void> _cacheTasks() async {
    final allTasks = await getAllTasks();
    _tasks = allTasks;
    _tasksStreamController.add(_tasks);
  }

  Future<TaskData> createTask({required TaskData taskData}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    // final results = await db.query(
    //   tasksTable,
    //   limit: 1,
    //   where: 'id = ?',
    //   whereArgs: [taskId],
    // );
    // if(results.isNotEmpty) throw UserAlreadyExists();
    final taskId = await db.insert(tasksTable, taskData.toJsonSqflite());
    taskData.id = taskId.toString();
    _tasks.add(taskData);
    _tasksStreamController.add(_tasks);
    return taskData;
  }

  Future<TaskData> readTask({required String id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      tasksTable,
      limit: 1,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
    if (results.isEmpty) throw TaskDoesNotExist();
    return TaskData.fromJsonSqflite(results.first);
  }

  Future<TaskData> updateTask({required TaskData taskData}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await readTask(id: taskData.id!);
    final changesCount = await db.update(
      tasksTable,
      taskData.toJsonSqflite(),
      where: '$idColumn = ?',
      whereArgs: [taskData.id!],
    );

    if (changesCount == 0) {
      throw CouldNotUpdateTask();
    }
    TaskData updatedTask = await readTask(id: taskData.id!);
    _tasks.removeWhere((task) => task.id == taskData.id!);
    _tasks.add(updatedTask);
    _tasksStreamController.add(_tasks);
    return updatedTask;
  }

  // Future<List<TaskData>> getTasksByDate({required int date}){
  //   final db = _getDatabaseOrThrow();
  //   final results = await db.query(
  //     tasksTable,
  //     limit: 1,
  //     where: '$idColumn = ?',
  //     whereArgs: [id],
  //   );
  //   if (results.isEmpty) throw TaskDoesNotExist();
  //   return TaskData.fromJsonSqflite(results.first);
  // }

  Future<List<TaskData>> getAllTasks() async {
    await _ensureDbIsOpen();
    log("db is open");
    final db = _getDatabaseOrThrow();
    final tasks = await db.query(tasksTable);
    return tasks.map((task) => TaskData.fromJsonSqflite(task)).toList();
  }

  Future<int> deleteAllTasks() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(tasksTable);
    _tasks = [];
    _tasksStreamController.add(_tasks);
    return deletedCount;
  }

  Future<void> deleteTask({required String id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    db.delete(tasksTable, where: '$idColumn = ?', whereArgs: [id]);
    _tasks.removeWhere((task) => task.id == id);
    _tasksStreamController.add(_tasks);
  }

  Database _getDatabaseOrThrow() {
    if (_db == null) {
      throw DatabaseNotOpen();
    }
    return _db!;
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      log("DB is already open");
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      //create table if not exists
      await db.execute(createUserTable);
      await _cacheTasks();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> close() async {
    if (_db == null) {
      throw DatabaseNotOpen();
    }
    await _db!.close();
    _db = null;
  }
}
