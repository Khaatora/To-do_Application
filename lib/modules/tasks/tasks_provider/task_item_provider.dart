import 'package:flutter/material.dart';
import 'package:todo_own/shared/network/local/firebase_utils.dart';

class TaskItemProvider extends ChangeNotifier {
  void onStatusChanged(String taskId, bool taskStatus) {
    getTasksCollection().doc(taskId).update({"isDone": taskStatus}).onError(
        (error, stackTrace) => print(error));
    notifyListeners();
  }
}
