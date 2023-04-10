import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_own/models/task.dart';
import 'package:todo_own/modules/settings/settings_provider/settings_provider.dart';
import 'package:todo_own/shared/network/local/firebase_utils.dart';
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
  late SqfliteUtils sqfliteUtils;
  late SettingsProvider provider;

  @override
  void initState() {
    sqfliteUtils = SqfliteUtils();
    sqfliteUtils.open();
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
                  return Center(
                    child:
                        Text(AppLocalizations.of(context)!.somethingWentWrong),
                  );
                }
                var tasks =
                    snapshot.data?.docs.map((doc) => doc.data()).toList();
                if (tasks?.isEmpty ?? true) {
                  return Expanded(
                      child: Center(
                          child: Text(
                    AppLocalizations.of(context)!.emptyListSentence,
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
      ),
    );
  }
}
