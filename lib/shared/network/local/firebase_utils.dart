import 'package:cloud_firestore/cloud_firestore.dart';
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
