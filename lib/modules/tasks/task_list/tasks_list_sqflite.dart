import 'dart:async';
import 'dart:developer';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_own/models/task.dart';
import 'package:todo_own/modules/settings/settings_provider/settings_provider.dart';
import 'package:todo_own/modules/tasks/task_list/db_open_future_builder_widget.dart';
import 'package:todo_own/shared/network/local/sqflite_utils.dart';
import 'package:todo_own/shared/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'task_item.dart';

class TasksListTab extends StatefulWidget {
  @override
  State<TasksListTab> createState() => _TasksListTabState();
}

class _TasksListTabState extends State<TasksListTab> {
  DateTime selectedDate = DateTime.now();
  SqfliteUtils sqfliteUtils = SqfliteUtils();
  late SettingsProvider provider;
  Stream<List<TaskData>>? allTasks;

  @override
  void initState() {
    allTasks = sqfliteUtils.allTasks;
    super.initState();
  }

  @override
  void dispose() {
    sqfliteUtils.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SettingsProvider>(context);
    return ChangeNotifierProvider(
      create: (context) => provider,
      child: SizedBox(
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
              locale: provider.langCode == "ar" ? "ar_EG" : "en",
            ),
            DbOpenFutureBuilder(
              sqfliteUtils: sqfliteUtils,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    log("future is done");
                    return StreamBuilder<List<TaskData>>(
                      stream: allTasks,
                      //getSelectedDateTasksFromFirestore(selectedDate),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> waiting<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
                            return const Expanded(
                                child: Center(
                              child: CircularProgressIndicator(),
                            ));
                          case ConnectionState.active:
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(AppLocalizations.of(context)!
                                    .somethingWentWrong),
                              );
                            }
                            if (snapshot.hasData) {
                              var tasks = snapshot.data
                                  ?.where((element) =>
                                      element.date ==
                                      DateUtils.dateOnly(selectedDate)
                                          .microsecondsSinceEpoch)
                                  .toList();
                              if (tasks?.isEmpty ?? true) {
                                return Expanded(
                                    child: Center(
                                        child: Text(
                                  AppLocalizations.of(context)!
                                      .emptyListSentence,
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
                            }
                            return const Expanded(
                                child: Center(
                              child: CircularProgressIndicator(),
                            ));
                          case ConnectionState.done:
                            return const Expanded(
                                child: Center(
                              child: Text("Wtf"),
                            ));
                        }
                      },
                    );
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    log("future is waiting");
                    return const Expanded(
                        child: Center(
                      child: CircularProgressIndicator(),
                    ));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
