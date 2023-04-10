import 'package:flutter/material.dart';
import 'package:todo_own/models/task.dart';
import 'package:todo_own/shared/network/local/firebase_utils.dart';

import '../../../shared/network/local/sqflite_utils.dart';

class TaskItemProvider extends ChangeNotifier {
  SqfliteUtils sqfliteUtils = SqfliteUtils();

  void onStatusChanged(String taskId, bool taskStatus) {
    getTasksCollection().doc(taskId).update({"isDone": taskStatus}).onError(
        (error, stackTrace) => print(error));
    notifyListeners();
  }

  void onStatusChangedSqflite(TaskData taskData) {
    taskData.isDone = !taskData.isDone!;
    sqfliteUtils.updateTask(taskData: taskData);
    notifyListeners();
  }
}
