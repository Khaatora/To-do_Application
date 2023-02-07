import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_own/models/task.dart';

CollectionReference<TaskData> getTasksCollection() =>
    FirebaseFirestore.instance.collection("tasks").withConverter<TaskData>(
        fromFirestore: (snapshot, options) {
          return TaskData.fromJson(snapshot.data()!);
        },
        toFirestore: (taskData, options) => taskData.toJson());

Future<void> addTaskToDatabase(TaskData taskData) {
  var tasksCollection = getTasksCollection();
  var docRef = tasksCollection.doc();
  taskData.id = docRef.id;
  return docRef.set(taskData);
}

Stream<QuerySnapshot<TaskData>> getSelectedDateTasksFromFirestore(
    DateTime dateTime) {
  return getTasksCollection()
      .where('date',
          isEqualTo: DateUtils.dateOnly(dateTime).microsecondsSinceEpoch)
      .snapshots();
}

Future<void> deleteTaskFromFirestore(String? id) {
  return getTasksCollection().doc(id).delete();
}

Future<void> updateTaskInFirestore(TaskData task) {
  return getTasksCollection().doc(task.id).update(task.toJson());
}
