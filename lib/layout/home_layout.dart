import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_own/layout/add_task_bottom_sheet.dart';
import 'package:todo_own/layout/home_provider.dart';
import 'package:todo_own/modules/settings/settings.dart';
import 'package:todo_own/modules/tasks/task_list/tasks_list_sqflite.dart';
import 'package:todo_own/shared/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeLayout extends StatelessWidget {
  static const String routeName = "Home Layout";

  @override
  Widget build(BuildContext mainContext) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      builder: (context, child) {
        var homeProvider = Provider.of<HomeProvider>(context);
        return Scaffold(
          extendBody: true,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          appBar: AppBar(
            title: Text(homeProvider.currentIndex == 0
                ? AppLocalizations.of(context)!.tasks
                : AppLocalizations.of(context)!.settings),
          ),
          body: tabs[homeProvider.currentIndex],
          floatingActionButton: FloatingActionButton(
              shape: const StadiumBorder(
                side: BorderSide(
                  color: colorWhite,
                  width: 3,
                ),
              ),
              onPressed: () {
                showAddTaskBottomSheet(context);
              },
              child: const Icon(
                Icons.add,
                color: colorWhite,
              )),
          bottomNavigationBar: BottomAppBar(
            notchMargin: 8,
            shape: const CircularNotchedRectangle(),
            child: BottomNavigationBar(
              currentIndex: homeProvider.currentIndex,
              onTap: (index) => homeProvider.changeCurrentIndex(index),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.list, size: 30), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings,
                      size: 30,
                    ),
                    label: ''),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> tabs = [TasksListTab(), SettingsTab()];

  void showAddTaskBottomSheet(mainContext) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: mainContext,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AddTaskBottomSheet(),
        );
      },
    );
  }
}
