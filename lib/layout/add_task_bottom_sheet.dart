import 'package:flutter/material.dart';
import 'package:todo_own/models/task.dart';
import 'package:todo_own/shared/components/component.dart';
import 'package:todo_own/shared/network/local/firebase_utils.dart';
import 'package:todo_own/shared/styles/colors.dart';

class AddTaskBottomSheet extends StatefulWidget {
  AddTaskBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("Add New Task",
                        style: Theme.of(context).textTheme.subtitle1)),
                //text form fields must be inside forms, they allow validation
                TextFormField(
                    autofocus: false,
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
                InkWell(
                  onTap: () {
                    showPicker(context);
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
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () {
                    showPicker(context);
                  },
                  child: Text(
                      "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}",
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(
                          Size(MediaQuery.of(context).size.width * 0.9, 0)),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        TaskData taskData = TaskData(
                            title: titleController.text,
                            description: descriptionController.text,
                            date: DateUtils.dateOnly(selectedDate)
                                .microsecondsSinceEpoch);
                        showLoading(context, "Adding task, Please wait", false);
                        addTaskToDatabase(taskData).then(
                          (value) {
                            hideLoading(context);
                            showMessage(
                                context, "Task Added Successfully", "Ok", () {
                              popNavigator(context);
                            });
                          },
                        ).catchError((error) {
                          print(error);
                        });
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

  void showPicker(BuildContext context) async {
    DateTime? chosenDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (chosenDate == null) return;
    selectedDate = chosenDate;
    setState(() {});
  }
}
