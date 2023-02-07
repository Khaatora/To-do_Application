import 'package:flutter/material.dart';
import 'package:todo_own/models/task.dart';
import 'package:todo_own/shared/components/component.dart';
import 'package:todo_own/shared/network/local/firebase_utils.dart';
import 'package:todo_own/shared/styles/colors.dart';

class AddTaskBottomSheet extends StatefulWidget {

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: mediaQuery.size.width * 0.05,
          vertical: mediaQuery.size.height * 0.02),
      child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Add New Task",
                    style: Theme.of(context).textTheme.subtitle1),
                const SizedBox(
                  height: 15,
                ),
                //text form fields must be inside forms, they allow validation
                TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value!.isEmpty) return "please enter title";
                    },
                    decoration: const InputDecoration(
                      label: Text("Title"),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: colorLightBlue, width: 3)),
                    )),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: descriptionController,
                    validator: (value) {
                      if (value!.isEmpty) return "please enter desc";
                    },
                    decoration: const InputDecoration(
                      label: Text("Description"),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: colorLightBlue, width: 3)),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            showDPicker(context);
                          },
                          child: Text(
                            "Select Date",
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: colorGrey),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDPicker(context);
                          },
                          child: Text(
                              "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}",
                              style: Theme.of(context).textTheme.subtitle1,
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            showTPicker(context);
                          },
                          child: Text(
                            "Select Time",
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: colorGrey),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showTPicker(context);
                          },
                          child: Text(selectedTime.format(context),
                              style: Theme.of(context).textTheme.subtitle1,
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(
                          Size(MediaQuery.of(context).size.width * 0.9, 0)),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        unFocusKeyboardFromScope();
                        TaskData taskData = TaskData(
                            title: titleController.text,
                            description: descriptionController.text,
                            date: DateUtils.dateOnly(selectedDate)
                                .microsecondsSinceEpoch,
                            time: TimeOfDay.fromDateTime(selectedDate)
                                .format(context));
                        showMessage(
                          context,
                          "Are you sure you want to continue?",
                          "Yes",
                          () {
                            popNavigator(context);
                            showLoading(
                                context, "Adding task, Please wait", false);
                            addTaskToDatabase(taskData);
                            hideLoading(context);
                            showMessage(
                                context, "Task Added Successfully", "Ok", () {
                              popNavigator(context);
                            });
                          },
                          negBtn: "cancel",
                          negAction: () => popNavigator(context),
                        );
                      }
                    },
                    child: Text(
                      "Add Task",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: colorWhite),
                    )),
              ],
            ),
          )),
    );
  }

  //showDatePicker
  void showDPicker(BuildContext context) async {
    unFocusKeyboardFromScope();
    DateTime? chosenDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (chosenDate == null) return;

    setState(() {
      selectedDate = chosenDate;
    });
  }

  //showTimePicker
  void showTPicker(BuildContext context) async {
    unFocusKeyboardFromScope();
    TimeOfDay? chosenTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (chosenTime == null) return;
    setState(() {
      selectedTime = chosenTime;
    });
  }

  void unFocusKeyboardFromScope() {
    FocusScope.of(context).unfocus();
  }
}
