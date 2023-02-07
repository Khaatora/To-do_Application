import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_own/models/task.dart';
import 'package:todo_own/shared/network/local/firebase_utils.dart';
import 'package:todo_own/shared/styles/colors.dart';

import 'task_item.dart';

class TasksListTab extends StatefulWidget {
  @override
  State<TasksListTab> createState() => _TasksListTabState();
}

class _TasksListTabState extends State<TasksListTab> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          CalendarTimeline(
            initialDate: selectedDate,
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            onDateSelected: (selectedDate) {
              this.selectedDate = selectedDate;
              setState(() {});
            },
            leftMargin: 20,
            monthColor: colorGrey,
            dayColor: colorLightBlue,
            activeDayColor: Colors.white,
            activeBackgroundDayColor: colorLightBlue,
            dotsColor: Colors.white,
            selectableDayPredicate: (date) => true,
            locale: 'ar_EG',
          ),
          StreamBuilder<QuerySnapshot<TaskData>>(
            stream: getSelectedDateTasksFromFirestore(selectedDate),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                    child: Center(
                  child: CircularProgressIndicator(),
                ));
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something Went Wrong"),
                );
              }
              var tasks = snapshot.data?.docs.map((doc) => doc.data()).toList();
              if (tasks?.isEmpty ?? true) {
                return const Expanded(
                    child: Center(
                        child: Text(
                  "No tasks are added for this day",
                  textAlign: TextAlign.center,
                )));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: tasks?.length,
                  itemBuilder: (context, index) {
                    return TaskItem(tasks![index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
