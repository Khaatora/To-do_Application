import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_own/layout/add_task_bottom_sheet.dart';
import 'package:todo_own/layout/home_provider.dart';
import 'package:todo_own/modules/settings/settings.dart';
import 'package:todo_own/modules/tasks/tasks_list.dart';
import 'package:todo_own/shared/styles/colors.dart';

class HomeLayout extends StatelessWidget {
  static const String routeName = "Home Layout";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      builder: (context, child) {
        var homeProvider = Provider.of<HomeProvider>(context);
        return Scaffold(
          extendBody: true,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          appBar: AppBar(
            title: const Text("Route Tasks"),
          ),
          body: tabs[homeProvider.currentIndex],
          floatingActionButton: FloatingActionButton(
              shape: StadiumBorder(
                side: BorderSide(
                  color: colorWhite,
                  width: 3,
                ),
              ),
              onPressed: () {
                showAddTaskBottomSheet(context);
              },
              child: Icon(
                Icons.add,
                color: colorWhite,
              )),
          bottomNavigationBar: BottomAppBar(
            notchMargin: 8,
            shape: CircularNotchedRectangle(),
            child: BottomNavigationBar(
              currentIndex: homeProvider.currentIndex,
              onTap: (index) => homeProvider.changeCurrentIndex(index),
              items: [
                const BottomNavigationBarItem(
                    icon: Icon(Icons.list, size: 30), label: ''),
                const BottomNavigationBarItem(
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

  List<Widget> tabs = [SettingsTab(), TasksListTab()];

  void showAddTaskBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddTaskBottomSheet();
      },
    );
  }
}
