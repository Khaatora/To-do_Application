import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_own/models/task.dart';
import 'package:todo_own/shared/network/local/firebase_utils.dart';

showLoading(BuildContext context, String message, bool isBarrierDissmisible) {
  showDialog(
    context: context,
    barrierDismissible: isBarrierDissmisible,
    builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              width: 5,
            ),
            Flexible(
                child: Text(
              message,
              textAlign: TextAlign.center,
            ))
          ],
        ),
      ),
    ),
  );
}

hideLoading(BuildContext context) {
  popNavigator(context);
}

void showMessage(BuildContext context, String message, String posBtnText,
    VoidCallback posAction,
    {String? negBtn, VoidCallback? negAction}) {
  showDialog(
    context: context,
    builder: (context) {
      List<Widget> Actions = [
        TextButton(onPressed: posAction, child: Text(posBtnText))
      ];
      if (negBtn != null)
        Actions.add(TextButton(onPressed: negAction, child: Text(negBtn)));
      return AlertDialog(
        title: FittedBox(fit: BoxFit.fitHeight, child: Text(message)),
        actions: Actions,
      );
    },
  );
}

void popNavigator(context) {
  Navigator.pop(context);
}

Stream<QuerySnapshot<TaskData>> getTasksFromFirestore(DateTime dateTime) {
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
