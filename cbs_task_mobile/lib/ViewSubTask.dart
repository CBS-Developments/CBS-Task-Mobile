
import 'dart:convert';
import 'package:cbs_task/SubTaskComments.dart';
import 'package:cbs_task/SubTaskDashBoard.dart';
import 'package:cbs_task/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum menuitem {
  item1,
  item2,
  item3,
  item4,
  item5,
  item6,
  item7,
  item8,
  item9,
  item10,
  item11
}

class ViewSubTask extends StatefulWidget {
  const ViewSubTask({Key? key}) : super(key: key);
  @override
  ViewSubTaskState createState() => ViewSubTaskState();
}

class ViewSubTaskState extends State<ViewSubTask> {
  var userName = "";
  var firstName = "";
  var lastName = "";
  var mainTaskId = "";
  var mainTaskTitle = "";
  var taskId = "";
  var taskTitle = "";
  var taskType = "";
  var company = "";
  var sourceFrom = "";
  var assignTo = "";
  var dueDate = "";
  var taskTypeName = "";
  var taskDescription = "";
  var taskCreateById = "";
  var taskCreateBy = "";
  var taskCreateDate = "";
  var taskCreateMonth = "";
  var taskCreatedTimestamp = "";
  var completeBy = "";
  var completeByDate = "";
  var taskStatus = "";
  var taskStatusName = "";
 // var selectedtime = "";
  String selectedTime = "";

  late DateTime _selectedDate;
  final TextEditingController _textEditingController = TextEditingController();


  @override
  void initState() {
    super.initState();
    retrieverData();
  }

  void retrieverData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = (prefs.getString('user_name') ?? '');
      firstName = (prefs.getString('first_name') ?? '').toUpperCase();
      lastName = (prefs.getString('last_name') ?? '').toUpperCase();
      mainTaskId = (prefs.getString('main_task_id') ?? '');
      mainTaskTitle = (prefs.getString('main_task_title') ?? '');
      taskId = (prefs.getString('task_id') ?? '');
      taskTitle = (prefs.getString('task_title') ?? '');
      taskType = (prefs.getString('task_type') ?? '');
      taskDescription = (prefs.getString('task_description') ?? '');
      company = (prefs.getString('company') ?? '');
      sourceFrom = (prefs.getString('source_from') ?? '');
      assignTo = (prefs.getString('assign_to') ?? '');
      dueDate = (prefs.getString('due_date') ?? '');
      taskTypeName = (prefs.getString('task_type_name') ?? '');
      taskCreateById = (prefs.getString('task_create_by_id') ?? '');
      taskCreateBy = (prefs.getString('task_create_by') ?? '');
      taskCreateDate = (prefs.getString('task_create_date') ?? '');
      taskCreatedTimestamp = (prefs.getString('task_created_timestamp') ?? '');
      taskStatus = (prefs.getString('task_status') ?? '');
      taskStatusName = (prefs.getString('task_status_name') ?? '');
      completeBy = (prefs.getString('complete_by') ?? '');
      completeByDate = (prefs.getString('complete_by_date') ?? '');
    });
  }

  Future<bool> updateTaskProgress(var taskId, var taskStatus,
      var taskStatusName, var userName, var name) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int taskTimeStamp = timestamp;
    var timeSt = taskTimeStamp;

    var dt = DateTime.fromMillisecondsSinceEpoch(taskTimeStamp);

    var stringDate = DateFormat('MM/dd/yyyy, hh:mm a').format(dt);
    late String url;

    if (taskStatus == "1") {
      url = "http://dev.connect.cbs.lk/markInProgress.php";
    } else if (taskStatus == "2") {
      url = "http://dev.connect.cbs.lk/markComplete.php";
    }
    var data = {
      "task_id": "$taskId",
      "task_status": "$taskStatus",
      "task_status_name": "$taskStatusName",
      "action_taken_by_id": "$userName",
      "action_taken_by": "$name",
      "action_taken_date": stringDate,
      "action_taken_timestamp": "$timeSt",
    };

    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (res.statusCode.toString() == "200") {
      if (jsonDecode(res.body) == "true") {
        if (taskStatus == '1') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('task_status', '1');
          prefs.setString('task_status_name', 'In Progress');
          retrieverData();
          if (!mounted) return true;
          snackBar(context, "Done", Colors.green);
        } else if (taskStatus == '2') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('task_status', '2');
          prefs.setString('task_status_name', 'Completed');
          retrieverData();
          if (!mounted) return true;
          snackBar(context, "Done", Colors.green);
        }
      }
    } else {
      if (!mounted) return true;
      snackBar(context, "Error", Colors.redAccent);
    }
    return true;
  }
  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.blueGrey,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.blue[500]!,
          ),
          child: child!,
        );
      },
    );

    if (newSelectedDate != null) {
      setState(() {
        _selectedDate = newSelectedDate;
        _textEditingController.text = DateFormat.yMMMd().format(_selectedDate!);
        _textEditingController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: _textEditingController.text.length,
            affinity: TextAffinity.upstream,
          ),
        );
      });
    }
  }

  Future<void> _displayTimeDialog(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        selectedTime = selectedTime;
      });
    }
  }


  Future<bool> taskCompleteByUser(var taskId, var taskStatus,
      var taskStatusName, var userName, var name, var date, var time) async {
    DateTime dt = DateFormat('MMM d, yyyy h:mm a').parse("$date $time");

    var timestamp = (dt.millisecondsSinceEpoch / 1000);
    String url;

    url = "http://dev.connect.cbs.lk/markComplete.php";

    var data = {
      "task_id": "$taskId",
      "task_status": "$taskStatus",
      "task_status_name": "$taskStatusName",
      "action_taken_by_id": "$userName",
      "action_taken_by": "$name",
      "action_taken_date": "$date $time",
      "action_taken_timestamp": "$timestamp",
    };

    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (res.statusCode.toString() == "200") {
      if (taskStatus == '2') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('task_status', '2');
        prefs.setString('task_status_name', 'Completed');
        retrieverData();
        snackBar(context, "Done", Colors.green);
      }
    } else {
      snackBar(context, "Error", Colors.redAccent);
    }
    return true;
  }
  // Future<bool> mainTask(BuildContext context) async {
  //   if (titleController.text.trim().isEmpty) {
  //     setState(() {
  //       titleValidation = true;
  //       snackBar(context, "Task title can't be empty", Colors.redAccent);
  //     });
  //     return false;
  //   } else {
  //     setState(() {
  //       titleValidation = false;
  //     });
  //   }
  //
  //   int timestamp = DateTime.now().millisecondsSinceEpoch;
  //   int taskTimeStamp = timestamp;
  //   var timeSt = taskTimeStamp;
  //   var dt = DateTime.fromMillisecondsSinceEpoch(taskTimeStamp);
  //   var stringDate = DateFormat('MM/dd/yyyy').format(dt);
  //   var stringMonth = DateFormat('MM/yyyy').format(dt);
  //   var taskId = "$userName#MT$taskTimeStamp";
  //   var url = "http://dev.connect.cbs.lk/mainTask.php";
  //   var data = {
  //     "task_id": taskId,
  //     "task_title": titleController.text,
  //     "task_type": "$taskType",
  //     "task_type_name": taskTypeString,
  //     "due_date": createTaskDueDateController.text,
  //     "task_create_by_id": userName,
  //     "task_create_by": "$firstName $lastName",
  //     "task_create_date": stringDate,
  //     "task_create_month": stringMonth,
  //     "task_created_timestamp": '$timeSt',
  //     "task_status": "0",
  //     "task_status_name": "Pending",
  //     "task_reopen_by": "",
  //     "task_reopen_by_id": "",
  //     "task_reopen_date": "",
  //     "task_reopen_timestamp": "0",
  //     "task_finished_by": "",
  //     "task_finished_by_id": "",
  //     "task_finished_by_date": "",
  //     "task_finished_by_timestamp": "0",
  //     "task_edit_by": "",
  //     "task_edit_by_id": "",
  //     "task_edit_by_date": "",
  //     "task_edit_by_timestamp": "0",
  //     "task_delete_by": "",
  //     "task_delete_by_id": "",
  //     "task_delete_by_date": "",
  //     "task_delete_by_timestamp": "0",
  //     "source_from": dropdownvalue1,
  //     "assign_to": assignToController.text,
  //     "company": dropdownvalue3,
  //     "document_number": documentNumberController.text,
  //     "action_taken_by_id": "",
  //     "action_taken_by": "",
  //     "action_taken_date": "",
  //     "action_taken_timestamp": "0"
  //   };
  //
  //   http.Response res = await http.post(
  //     url,
  //     body: data,
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/x-www-form-urlencoded",
  //     },
  //     encoding: Encoding.getByName("utf-8"),
  //   );
  //
  //   if (res.statusCode.toString() == "200") {
  //     if (jsonDecode(res.body) == "true") {
  //       if (!mounted) return true;
  //       createTask(context, taskId);
  //       return true;
  //     } else {
  //       if (!mounted) return false;
  //       snackBar(context, "Error", Colors.red);
  //     }
  //   } else {
  //     if (!mounted) return false;
  //     snackBar(context, "Error", Colors.redAccent);
  //   }
  //   return true;
  // }
  //
  // Future<bool> createTask(BuildContext context, var mainTaskId) async {
  //   if (titleController.text.trim().isEmpty) {
  //     setState(() {
  //       titleValidation = true;
  //       snackBar(context, "Task title can't be empty", Colors.redAccent);
  //     });
  //     return false;
  //   } else {
  //     setState(() {
  //       titleValidation = false;
  //     });
  //   }
  //
  //   if (subTitleController.text.trim().isEmpty) {
  //     setState(() {
  //       subTaskTitleValidation = true;
  //       snackBar(context, "Sub task title can't be empty", Colors.redAccent);
  //     });
  //     return false;
  //   } else {
  //     setState(() {
  //       subTaskTitleValidation = false;
  //     });
  //   }
  //
  //   int timestamp = DateTime.now().millisecondsSinceEpoch;
  //   int taskTimeStamp = timestamp;
  //   var timeSt = taskTimeStamp;
  //   var dt = DateTime.fromMillisecondsSinceEpoch(taskTimeStamp);
  //   var stringDate = DateFormat('MM/dd/yyyy').format(dt);
  //   var stringMonth = DateFormat('MM/yyyy').format(dt);
  //   var taskId = "$userName#ST$taskTimeStamp";
  //   var url = "http://dev.connect.cbs.lk/createTask.php";
  //
  //   var data = {
  //     "task_id": taskId,
  //     "main_task_id": "$mainTaskId",
  //     "task_title": subTitleController.text,
  //     "task_type": "$taskType",
  //     "task_type_name": taskTypeString,
  //     "due_date": createTaskDueDateController.text,
  //     "task_description": descriptionController.text,
  //     "task_create_by_id": userName,
  //     "task_create_by": "$firstName $lastName",
  //     "task_create_date": stringDate,
  //     "task_create_month": stringMonth,
  //     "task_created_timestamp": '$timeSt',
  //     "task_status": "0",
  //     "task_status_name": "Pending",
  //     "action_taken_by_id": "",
  //     "action_taken_by": "",
  //     "action_taken_date": "",
  //     "action_taken_timestamp": "0",
  //     "task_reopen_by": "",
  //     "task_reopen_by_id": "",
  //     "task_reopen_date": "",
  //     "task_reopen_timestamp": "0",
  //     "task_finished_by": "",
  //     "task_finished_by_id": "",
  //     "task_finished_by_date": "",
  //     "task_finished_by_timestamp": "0",
  //     "task_edit_by": "",
  //     "task_edit_by_id": "",
  //     "task_edit_by_date": "",
  //     "task_edit_by_timestamp": "0",
  //     "task_delete_by": "",
  //     "task_delete_by_id": "",
  //     "task_delete_by_date": "",
  //     "task_delete_by_timestamp": "0",
  //     "source_from": dropdownvalue1,
  //     "assign_to": assignToController.text,
  //     "company": dropdownvalue3
  //   };
  //
  //   http.Response res = await http.post(
  //     url,
  //     body: data,
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/x-www-form-urlencoded",
  //     },
  //     encoding: Encoding.getByName("utf-8"),
  //   );
  //
  //   if (res.statusCode.toString() == "200") {
  //     if (jsonDecode(res.body) == "true") {
  //       if (!mounted) return true;
  //       snackBar(context, "Done", Colors.green);
  //       return true;
  //     } else {
  //       if (!mounted) return false;
  //       snackBar(context, "Error", Colors.red);
  //     }
  //   } else {
  //     if (!mounted) return false;
  //     snackBar(context, "Error", Colors.redAccent);
  //   }
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    double textFontSmall = (sizeHeight * 0.020) * (sizeWidth * 0.0020);
    double textFontNormal = (sizeHeight * 0.025) * (sizeWidth * 0.002);
    double textFontLarge = (sizeHeight * 0.025) * (sizeWidth * 0.0025);

    double textFontButton = (sizeHeight * 0.022) * (sizeWidth * 0.0030);
    double buttonRadius = (sizeHeight * 0.010) * (sizeWidth * 0.0008);

    double paddingButton = (sizeHeight * 0.012) * (sizeWidth * 0.0012);
    double iconSize = (sizeHeight * 0.028) * (sizeWidth * 0.0028);
    double padding = (sizeHeight * 0.002) * (sizeWidth * 0.0002);
    double smallIconSize = (sizeHeight * 0.0041) * (sizeWidth * 0.0041);

    int time = int.parse(taskCreatedTimestamp);

    DateTime a = DateTime.fromMillisecondsSinceEpoch((time));
    DateTime b = DateTime.now();

    Duration difference = b.difference(a);

    int days = difference.inDays % 365 % 30;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context); // Go back to the previous screen
        return true; // Allow the back action
      },

      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            automaticallyImplyLeading: false,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$firstName $lastName",
                  style: const TextStyle(color: Colors.white, fontSize: 15.0),
                ),
                const Text(
                  "VIEW TASK",
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ],
            ),

            actions: [
              IconButton(
                icon: const Icon(
                  Icons.comment,
                ),
                color: Colors.white,
                tooltip: 'Comment',
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const SubTaskComments();
                      },
                    ),
                  );
                },
              ),
            ],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                // if (intentFrom == 'main_dashboard') {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) {
                //         return const MainDashBoard();
                //       },
                //     ),
                //   );
                // } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const SubTaskDashBoard();
                      },
                    ),
                  );
                // }
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 2,
                ),

                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      mainTaskTitle,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: textFontLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      taskTitle,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: textFontNormal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      taskDescription,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: textFontNormal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                SizedBox(
                  height: sizeHeight,
                  width: sizeWidth,
                  child: Column(
                    children: [
                      if (taskType == '1')
                        Padding(
                            padding: EdgeInsets.all(paddingButton),
                          child: Align(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      const Color(0xffFF0000)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              buttonRadius),
                                          side: const BorderSide(
                                              color:
                                              Color(0xffFF0000))))),
                              onPressed: () => null,
                              child: Text(
                                taskTypeName,
                                style: TextStyle(
                                    fontSize: textFontButton,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),),
                      if (taskType == '2')
                        Padding(
                            padding: EdgeInsets.all(paddingButton),
                            child:  Align(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      const Color(0xff800000)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              buttonRadius),
                                          side: const BorderSide(
                                              color: Color(0xff800000))))),
                              onPressed: () => null,
                              child: Text(taskTypeName,
                                  style: TextStyle(
                                      fontSize: textFontButton,
                                      fontWeight: FontWeight.bold))),
                        ),),
                      if (taskType == '3')
                        Padding(
                            padding: EdgeInsets.all(paddingButton),
                            child: Align(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      const Color(0xffFFFF00)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              buttonRadius),
                                          side: const BorderSide(
                                              color: Color(0xffFFFF00))))),
                              onPressed: () => null,
                              child: Text(taskTypeName,
                                  style: TextStyle(
                                      fontSize: textFontButton,
                                      fontWeight: FontWeight.bold))),
                        ),),
                      if (taskType == '4')
                        Padding(
                            padding: EdgeInsets.all(paddingButton),
                            child: Align(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      const Color(0xff808000)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              buttonRadius),
                                          side: const BorderSide(
                                              color: Color(0xff808000))))),
                              onPressed: () => null,
                              child: Text(taskTypeName,
                                  style: TextStyle(
                                      fontSize: textFontButton,
                                      fontWeight: FontWeight.bold))),
                        ),),
                      if (taskType == '5')
                        Padding(
                            padding: EdgeInsets.all(paddingButton),
                            child:  Align(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      const Color(0xff00FFFF)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              buttonRadius),
                                          side: const BorderSide(
                                              color: Color(0xff00FFFF))))),
                              onPressed: () => null,
                              child: Text(taskTypeName,
                                  style: TextStyle(
                                      fontSize: textFontButton,
                                      fontWeight: FontWeight.bold))),
                        ),),
                      if (taskType == '6')
                        Padding(
                            padding: EdgeInsets.all(paddingButton),
                            child: Align(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      const Color(0xff008080)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              buttonRadius),
                                          side: const BorderSide(
                                              color: Color(0xff008080))))),
                              onPressed: () => null,
                              child: Text(taskTypeName,
                                  style: TextStyle(
                                      fontSize: textFontButton,
                                      fontWeight: FontWeight.bold))),
                        ),),
                      if (taskType == '7')
                        Padding(
                            padding: EdgeInsets.all(paddingButton),
                            child: Align(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      const Color(0xffFF00FF)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              buttonRadius),
                                          side: const BorderSide(
                                              color: Color(0xffFF00FF))))),
                              onPressed: () => null,
                              child: Text(taskTypeName,
                                  style: TextStyle(
                                      fontSize: textFontButton,
                                      fontWeight: FontWeight.bold))),
                        ),),
                      if (taskType == '8')
                        Padding(
                            padding: EdgeInsets.all(paddingButton),
                            child: Align(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      const Color(0xff800080)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              buttonRadius),
                                          side: const BorderSide(
                                              color: Color(0xff800080))))),
                              onPressed: () => null,
                              child: Text(taskTypeName,
                                  style: TextStyle(
                                      fontSize: textFontButton,
                                      fontWeight: FontWeight.bold))),
                        ),),
                      if (taskType == '9')
                        Padding(
                            padding: EdgeInsets.all(paddingButton),
                            child: Align(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      const Color.fromARGB(255, 190, 114, 0)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              buttonRadius),
                                          side: const BorderSide(color: Color.fromARGB(255, 190, 114, 0))))),
                              onPressed: () => null,
                              child: Text(taskTypeName,
                                  style: TextStyle(
                                      fontSize: textFontButton,
                                      fontWeight: FontWeight.bold))),
                        ),),
                      if (taskType == '10')
                        Padding(
                            padding: EdgeInsets.all(paddingButton),
                            child:   Align(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      const Color.fromARGB(255, 0, 3, 190)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              buttonRadius),
                                          side: const BorderSide(color: Color.fromARGB(255, 0, 3, 190))))),
                              onPressed: () => null,
                              child: Text(taskTypeName,
                                  style: TextStyle(
                                      fontSize: textFontButton,
                                      fontWeight: FontWeight.bold))),
                        ),),
                      if (taskType == '11')
                        Padding(
                            padding: EdgeInsets.all(paddingButton),
                            child:  Align(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      const Color.fromARGB(255, 14, 168, 0)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              buttonRadius),
                                          side: const BorderSide(color: Color.fromARGB(255, 14, 168, 0))))),
                              onPressed: () => null,
                              child: Text(taskTypeName,
                                  style: TextStyle(
                                      fontSize: textFontButton,
                                      fontWeight: FontWeight.bold))),
                        ),),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: paddingButton),
                          child: Align(
                        alignment: Alignment.topLeft,
                        child: SelectableText(
                          "TASK ID : $taskId",
                          style: TextStyle(
                            fontSize: textFontNormal,
                          ),
                        ),
                      ),),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: paddingButton),
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'This task create by:',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),

                      Padding(
                        padding: EdgeInsets.only(left: paddingButton),
                          child:   Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          taskCreateBy,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),
                      const SizedBox(
                        height:  5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: paddingButton),
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Company name:',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),
                      Padding(
                        padding: EdgeInsets.only(left: paddingButton),
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          company,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: paddingButton),
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'This source from:',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),
                      Padding(
                        padding: EdgeInsets.only(left: paddingButton),
                          child:  Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          sourceFrom,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: paddingButton),
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'This task assign to:',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),
                      Padding(
                        padding: EdgeInsets.only(left: paddingButton),
                          child:   Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          assignTo,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: paddingButton),
                          child:  Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Task due date:',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),
                      Padding(
                        padding: EdgeInsets.only(left: paddingButton),
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          dueDate,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: paddingButton),
                          child:  Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Task status:',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),
                      if (taskStatus == "0")
                        Padding(
                          padding: EdgeInsets.only(left: paddingButton),
                            child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            taskStatusName,
                            style: TextStyle(
                                color: const Color.fromARGB(255, 167, 94, 0),
                                fontSize: textFontNormal,
                                fontWeight: FontWeight.bold),
                          ),
                        ),),
                      if (taskStatus == "1")
                        Padding(
                          padding: EdgeInsets.only(left: paddingButton),
                            child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            taskStatusName,
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 90, 224),
                                fontSize: textFontNormal,
                                fontWeight: FontWeight.bold),
                          ),
                        ),),
                      if (taskStatus == "2")
                        Padding(
                          padding: EdgeInsets.only(left: paddingButton),
                            child:  Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            taskStatusName,
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 165, 8),
                                fontSize: textFontNormal,
                                fontWeight: FontWeight.bold),
                          ),
                        ),),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: paddingButton),
                          child:   Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Task create date:',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),
                      Padding(
                        padding: EdgeInsets.only(left: paddingButton),
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          taskCreateDate,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),
                      Padding(
                        padding: EdgeInsets.only(left: paddingButton),
                          child:  Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "$days day(s) $hours hour(s) $minutes minute(s) $seconds second(s) ago.",
                          style: TextStyle(
                              fontSize: textFontSmall,
                              fontWeight: FontWeight.bold),
                        ),
                      ),),
                      const SizedBox(
                        height: 20,
                      ),
                      if (taskStatus == "0")
                        Padding(
                          padding: EdgeInsets.only(left: paddingButton),
                            child: Align(
                          alignment: Alignment.centerLeft,
                          child: Tooltip(
                            message: "Mark In Progress",
                            child: InkWell(
                              onTap: () {
                                updateTaskProgress(
                                    taskId,
                                    "1",
                                    "In Progress",
                                    userName,
                                    "$firstName $lastName");
                              },
                              child: Text(
                                "Mark In Progress",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: textFontNormal,
                                    fontWeight: FontWeight.bold),
                             ),
                            ),
                          ),
                         ),
                       ),
                      if (taskStatus == "1")
                        Padding(
                          padding: EdgeInsets.only(left: paddingButton),
                            child: Align(
                          alignment: Alignment.centerLeft,
                          child: Tooltip(
                            message: "Mark Complete",
                            child: InkWell(
                              onTap: () {
                                updateTaskProgress(
                                    taskId,
                                    "2",
                                    "Completed",
                                    userName,
                                    "$firstName $lastName");
                              },
                              child: Text(
                                "Mark Complete Now",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: textFontNormal,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),),
                      if (taskStatusName == "Completed")
                        Padding(
                          padding: EdgeInsets.only(left: paddingButton),
                            child: Align(
                          alignment: Alignment.centerLeft,
                          child: Tooltip(
                            message: "Mark Complete",
                            child: Text(
                              "",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: textFontNormal,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),),

                      Padding(
                        padding: EdgeInsets.only(left: paddingButton),
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Task complete by:',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),
                      Padding(
                        padding: EdgeInsets.only(left: paddingButton),
                          child:  Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          completeBy,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: paddingButton),
                          child:   Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Task complete date:',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),
                      Padding(
                          padding: EdgeInsets.only(left: paddingButton),
                          child:   Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          completeByDate,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: textFontNormal),
                        ),
                      ),),
                      const SizedBox(
                        height: 5,
                      ),
                      if (taskStatus == "0" || taskStatus == "1")
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(paddingButton),
                                  child: TextField(
                                 focusNode:AlwaysDisabledFocusNode(),
                                  controller:_textEditingController,
                                                              onTap: () {
                                                               _selectDate(context);
                                                              },
                                                              decoration:
                                                              InputDecoration(
                                                                hintText: 'Select Date',
                                                                suffixIcon: IconButton(
                                                                  onPressed: () {
                                                                    _selectDate(
                                                                        context);
                                                                  },
                                                                  icon: Icon(
                                                                    Icons.date_range,
                                                                    color: Colors.blue,
                                                                    size: iconSize,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(paddingButton),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        children:  <Widget>[

                                                                                  Text(
                                                                                    selectedTime ?? '',
                                                                                    style: TextStyle(
                                                                                        fontSize:
                                                                                        textFontNormal),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                  IconButton(
                                                                                    icon: Icon(
                                                                                      Icons.watch_later,
                                                                                      size: iconSize,
                                                                                    ),
                                                                                    color: Colors.blue,
                                                                                    onPressed: () async {
                                                                                      _displayTimeDialog(context);
                                                                                    },
                                                                                  ),
                                                        ],),
                                ),
                              ),
                            ),
                          ],
                        ),
                      //   Row(
                      //   children: [
                      //     Expanded(
                      //       flex: 1,
                      //       child:  Center(
                      //         child: Padding(
                      //           padding: EdgeInsets.all(paddingButton),
                      //           child: MaterialButton(
                      //             color: Colors.blue,
                      //             onPressed: () {
                      //           //    mainTask(context);
                      //             },
                      //             child: Text('CLEAR',
                      //                 style: TextStyle(
                      //                     fontSize:
                      //                     sizeHeight * 0.015,
                      //                     fontWeight:
                      //                     FontWeight.w500,
                      //                     color: Colors.white)),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       flex: 1,
                      //       child: Center(
                      //         child: Padding(
                      //           padding: EdgeInsets.all(paddingButton),
                      //           child: MaterialButton(
                      //             color: Colors.blue,
                      //             onPressed: () {
                      //               taskCompleteByUser(
                      //                   taskId,
                      //                   '2',
                      //                   'Complete',
                      //                   userName,
                      //                   '$firstName $lastName',
                      //                   _textEditingController
                      //                       .text,
                      //                   selectedTime);
                      //             },
                      //             child: Text('COMPLETE TASK',
                      //                 style: TextStyle(
                      //                     fontSize:
                      //                     sizeHeight * 0.015,
                      //                     fontWeight:
                      //                     FontWeight.w500,
                      //                     color: Colors.white)),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      if (taskStatus == "2")
                        Row(
                          children: const [
                            Expanded(
                              flex: 1,
                              child: Center(

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(

                              ),
                            ),
                          ],
                        ),
                      if (taskStatus == "0" || taskStatus == "1")

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child:  Center(
                              child: Padding(
                                padding: EdgeInsets.all(paddingButton),
                                child: MaterialButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    //    mainTask(context);
                                  },
                                  child: Text('CLEAR',
                                      style: TextStyle(
                                          fontSize:
                                          sizeHeight * 0.015,
                                          fontWeight:
                                          FontWeight.w500,
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(paddingButton),
                                child: MaterialButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    taskCompleteByUser(
                                        taskId,
                                        '2',
                                        'Complete',
                                        userName,
                                        '$firstName $lastName',
                                        _textEditingController
                                            .text,
                                        selectedTime);
                                  },
                                  child: Text('COMPLETE TASK',
                                      style: TextStyle(
                                          fontSize:
                                          sizeHeight * 0.015,
                                          fontWeight:
                                          FontWeight.w500,
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (taskStatus == "2")
                        Row(
                          children: const [
                            Expanded(
                              flex: 1,
                              child: Center(

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(

                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(left: paddingButton),
                  child: const Align(
                    alignment: Alignment.bottomLeft,
                    // child: TextField(
                    //   textInputAction: TextInputAction.next,
                    //   keyboardType: TextInputType.multiline,
                    //   maxLines: null,
                    //   controller: subTitleController,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: 'Sub Task Title',
                    //     hintText: 'Sub Task Title',
                    //     // Here is key idea
                    //   ),
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.bold, fontSize: textFontLarge),
                    // ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(left: paddingButton),
                  child: const Align(
                    alignment: Alignment.bottomLeft,
                    // child: TextField(
                    //   textInputAction: TextInputAction.done,
                    //   keyboardType: TextInputType.multiline,
                    //   maxLines: null,
                    //   controller: descriptionController,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: 'Description',
                    //     hintText: 'Description',
                    //   ),
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.bold, fontSize: textFontLarge),
                    // ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),

                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(paddingButton),

                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(paddingButton),

                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: const Center(
                            child: Align(
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: const Center(

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(padding),

                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: const Center(
                    child: Align(
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       flex: 1,
                //       child: Padding(
                //         padding: EdgeInsets.all(padding),
                //         child: MaterialButton(
                //           color: Colors.blue,
                //           onPressed: () {
                //             // titleController.text = "";
                //             // descriptionController.text = "";
                //             // subTitleController.text = "";
                //             // assignToController.text = "";
                //             // documentNumberController.text = "";
                //             // createTaskDueDateController.text = "";
                //             // assignTo.clear();
                //           },
                //           child: Text('CLEAR',
                //               style: TextStyle(
                //                   fontSize: sizeHeight * 0.015,
                //                   fontWeight: FontWeight.w500,
                //                   color: Colors.white)),
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       flex: 1,
                //       child: Padding(
                //         padding: EdgeInsets.all(padding),
                //         child: MaterialButton(
                //           color: Colors.blue,
                //           onPressed: () {
                //         //    mainTask(context);
                //           },
                //           child: Text('SUBMIT',
                //               style: TextStyle(
                //                   fontSize: sizeHeight * 0.015,
                //                   fontWeight: FontWeight.w500,
                //                   color: Colors.white)),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(
                  height: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
