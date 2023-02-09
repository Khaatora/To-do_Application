import 'package:flutter/material.dart';
import 'package:todo_own/models/task.dart';
import 'package:todo_own/shared/components/component.dart';
import 'package:todo_own/shared/network/local/firebase_utils.dart';
import 'package:todo_own/shared/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  late DateTime selectedDate;

  late TimeOfDay selectedTime;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late String taskTime;
  late String period;

  @override
  void initState() {
    taskTime = widget.task.time!.substring(0, widget.task.time!.length - 3);
    period = widget.task.time!
        .substring(widget.task.time!.length - 2, widget.task.time!.length);
    selectedDate = DateTime.fromMicrosecondsSinceEpoch(widget.task.date!);
    selectedTime = TimeOfDay(
        hour: int.parse(taskTime.split(":")[0]) + (period == "PM" ? 12 : 0),
        minute: int.parse(taskTime.split(":")[1]));
    titleController.text = widget.task.title!;
    descriptionController.text = widget.task.description!;
    super.initState();
  }

  @override
  Widget build(BuildContext mainContext) {
    var mediaQuery = MediaQuery.of(mainContext);

    return Scaffold(
      appBar: AppBar(
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
                      Text(AppLocalizations.of(context)!.editTask,
                          style: Theme.of(mainContext).textTheme.subtitle1),
                      const SizedBox(
                        height: 15,
                      ),
                      //text form fields must be inside forms, they allow validation
                      TextFormField(
                          controller: titleController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .pleaseEnterNewTitle;
                            }
                          },
                          decoration: InputDecoration(
                            label: Text(AppLocalizations.of(context)!.title),
                            enabledBorder: const OutlineInputBorder(
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
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .pleaseEnterNewDescription;
                            }
                          },
                          decoration: InputDecoration(
                            label:
                                Text(AppLocalizations.of(context)!.description),
                            enabledBorder: const OutlineInputBorder(
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
                                  AppLocalizations.of(context)!.selectDate,
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
                                  showTPicker(mainContext);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.selectTime,
                                  textAlign: TextAlign.left,
                                  style: Theme.of(mainContext)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(color: colorGrey),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showTPicker(mainContext);
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
                                AppLocalizations.of(context)!.areYouSure,
                                AppLocalizations.of(context)!.yes,
                                () {
                                  popNavigator(mainContext);
                                  showLoading(
                                      mainContext,
                                      AppLocalizations.of(context)!.saveChanges,
                                      false);
                                  updateTaskInFirestore(taskData);
                                  hideLoading(mainContext);
                                  showMessage(
                                      mainContext,
                                      AppLocalizations.of(context)!
                                          .taskEditedSuccessfully,
                                      AppLocalizations.of(context)!.ok, () {
                                    popNavigator(context);
                                    popNavigator(context);
                                  });
                                },
                                negBtn: AppLocalizations.of(context)!.cancel,
                                negAction: () => popNavigator(mainContext),
                              );
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.saveChanges,
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
  void showTPicker(BuildContext context) async {
    unFocusKeyboardFromScope();
    TimeOfDay? chosenTime =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (chosenTime == null) return;
    setState(() {
      selectedTime = chosenTime;
    });
  }

  void unFocusKeyboardFromScope() {
    FocusScope.of(context).unfocus();
  }
}
