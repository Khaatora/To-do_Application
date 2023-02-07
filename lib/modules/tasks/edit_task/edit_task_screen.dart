import 'package:flutter/material.dart';
import 'package:todo_own/models/task.dart';
import 'package:todo_own/shared/components/component.dart';
import 'package:todo_own/shared/network/local/firebase_utils.dart';
import 'package:todo_own/shared/styles/colors.dart';

class EditTaskScreen extends StatefulWidget {
  static const String routeName = "Edit_Task_Screen";
  TaskData task;

  EditTaskScreen(this.task);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late String taskTime;
  late TimeOfDay taskTimeOfDay;

  @override
  void initState() {
    taskTime = widget.task.time!.substring(0, widget.task.time!.length - 3);
    titleController.text = widget.task.title!;
    descriptionController.text = widget.task.description!;
    super.initState();
  }

  @override
  Widget build(BuildContext mainContext) {
    var mediaQuery = MediaQuery.of(mainContext);
    taskTimeOfDay = TimeOfDay(
        hour: int.parse(taskTime.split(":")[0]),
        minute: int.parse(taskTime.split(":")[1]));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: mediaQuery.size.width * 0.05,
              vertical: mediaQuery.size.height * 0.02),
          decoration: BoxDecoration(
            color: colorWhite,
            border: Border.all(color: colorLightBlue, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.05,
                vertical: mediaQuery.size.height * 0.02),
            child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Edit Task",
                          style: Theme.of(mainContext).textTheme.subtitle1),
                      const SizedBox(
                        height: 15,
                      ),
                      //text form fields must be inside forms, they allow validation
                      TextFormField(
                          controller: titleController,
                          validator: (value) {
                            if (value!.isEmpty) return "please enter new title";
                          },
                          decoration: const InputDecoration(
                            label: Text("Title"),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: colorLightBlue, width: 3)),
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          controller: descriptionController,
                          validator: (value) {
                            if (value!.isEmpty)
                              return "please enter description";
                          },
                          decoration: const InputDecoration(
                            label: Text("Description"),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: colorLightBlue, width: 3)),
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
                                  showDPicker(mainContext, widget.task.date!);
                                },
                                child: Text(
                                  "Select Date",
                                  textAlign: TextAlign.left,
                                  style: Theme.of(mainContext)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(color: colorGrey),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDPicker(mainContext, widget.task.date!);
                                },
                                child: Text(
                                    "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}",
                                    style: Theme.of(mainContext)
                                        .textTheme
                                        .subtitle1,
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
                                  showTPicker(mainContext, widget.task.time!);
                                },
                                child: Text(
                                  "Select Time",
                                  textAlign: TextAlign.left,
                                  style: Theme.of(mainContext)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(color: colorGrey),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showTPicker(mainContext, widget.task.time!);
                                },
                                child: Text(selectedTime.format(mainContext),
                                    style: Theme.of(mainContext)
                                        .textTheme
                                        .subtitle1,
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
                            fixedSize: MaterialStatePropertyAll(Size(
                                MediaQuery.of(mainContext).size.width * 0.9,
                                0)),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              unFocusKeyboardFromScope();
                              TaskData taskData = TaskData(
                                  id: widget.task.id,
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  date: DateUtils.dateOnly(selectedDate)
                                      .microsecondsSinceEpoch,
                                  time: selectedTime.format(mainContext),
                                  isDone: widget.task.isDone);
                              showMessage(
                                mainContext,
                                "Are you sure you want to continue?",
                                "Yes",
                                () {
                                  popNavigator(mainContext);
                                  showLoading(mainContext,
                                      "Saving Changes, Please wait", false);
                                  updateTaskInFirestore(taskData);
                                  hideLoading(mainContext);
                                  showMessage(mainContext,
                                      "Task Edited Successfully", "Ok", () {
                                    popNavigator(context);
                                    popNavigator(context);
                                  });
                                },
                                negBtn: "cancel",
                                negAction: () => popNavigator(mainContext),
                              );
                            }
                          },
                          child: Text(
                            "Save Changes",
                            textAlign: TextAlign.center,
                            style: Theme.of(mainContext)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: colorWhite),
                          )),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  //showDatePicker
  void showDPicker(BuildContext context, int date) async {
    unFocusKeyboardFromScope();
    DateTime? chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.fromMicrosecondsSinceEpoch(date),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (chosenDate == null) return;

    setState(() {
      selectedDate = chosenDate;
    });
  }

  //showTimePicker
  void showTPicker(BuildContext context, String time) async {
    unFocusKeyboardFromScope();
    TimeOfDay? chosenTime =
        await showTimePicker(context: context, initialTime: taskTimeOfDay);
    if (chosenTime == null) return;
    setState(() {
      selectedTime = chosenTime;
    });
  }

  void unFocusKeyboardFromScope() {
    FocusScope.of(context).unfocus();
  }
}
