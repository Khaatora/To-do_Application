import 'package:flutter/material.dart';

class TasksListProvider extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();

  void changeCurrentDate(DateTime selectedDate) {
    this.selectedDate = selectedDate;
    print(selectedDate);
    notifyListeners();
  }
}
