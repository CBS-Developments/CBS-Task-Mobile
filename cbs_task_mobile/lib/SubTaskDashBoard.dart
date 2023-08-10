
import 'dart:convert';
import 'package:cbs_task/CreateSubTask.dart';
import 'package:cbs_task/EditSubTask.dart';
import 'package:cbs_task/MainDashBoard.dart';
import 'package:cbs_task/MainTaskComments.dart';
import 'package:cbs_task/ViewSubTask.dart';
import 'package:cbs_task/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubTaskDashBoard extends StatefulWidget {
  const SubTaskDashBoard({Key? key}) : super(key: key);

  @override
  SubTaskDashBoardState createState() => SubTaskDashBoardState();
}

class SubTaskDashBoardState extends State<SubTaskDashBoard> {
 late String userRole;
 late String userName;
 late String firstName;
 late String lastName;
 late String mainTaskId;
 late String mainTaskTitle;
 late String taskType;
 late String taskTypeName;
 late String taskCreateBy;
 late String company;
 late String sourceFrom;
 late String assignTo;
 late String dueDate;
 late String taskStatusName;
 late String taskStatus;
 late String taskCreateDate;
 late String taskCreatedTimestamp;
 late String mainTaskFinishedBy;
 late String mainTaskFinishedByDate;

  List<Task> subTaskList = [];
  List<Task> completeSubTaskList = [];
  List<Task> pendingSubTaskList = [];
  List<Task> inprogressSubTaskList = [];
  List<Task> searchResultAsSubTaskList = [];
  TextEditingController taskListController = TextEditingController();

  onSearchTextChangedUser(String text) async {
    searchResultAsSubTaskList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    for (var taskList in subTaskList) {
      if (taskList.taskId.contains(text) ||
          taskList.taskId.toLowerCase().contains(text) ||
          taskList.taskId.toUpperCase().contains(text) ||
          taskList.taskTitle.contains(text) ||
          taskList.taskTitle.toLowerCase().contains(text) ||
          taskList.taskTitle.toUpperCase().contains(text) ||
          taskList.dueDate.contains(text) ||
          taskList.dueDate.toLowerCase().contains(text) ||
          taskList.dueDate.toUpperCase().contains(text) ||
          taskList.taskTypeName.contains(text) ||
          taskList.taskTypeName.toLowerCase().contains(text) ||
          taskList.taskTypeName.toUpperCase().contains(text) ||
          // taskList.taskDescription.contains(text) ||
          // taskList.taskDescription.toLowerCase().contains(text) ||
          // taskList.taskDescription.toUpperCase().contains(text) ||
          taskList.taskCreateBy.contains(text) ||
          taskList.taskCreateBy.toLowerCase().contains(text) ||
          taskList.taskCreateBy.toUpperCase().contains(text) ||
          taskList.taskCreateDate.contains(text) ||
          taskList.taskCreateDate.toLowerCase().contains(text) ||
          taskList.taskCreateDate.toUpperCase().contains(text) ||
          taskList.sourceFrom.contains(text) ||
          taskList.sourceFrom.toLowerCase().contains(text) ||
          taskList.sourceFrom.toUpperCase().contains(text) ||
          taskList.assignTo.contains(text) ||
          taskList.assignTo.toLowerCase().contains(text) ||
          taskList.assignTo.toUpperCase().contains(text) ||
          taskList.company.contains(text) ||
          taskList.company.toLowerCase().contains(text) ||
          taskList.company.toUpperCase().contains(text) ||
          taskList.documentNumber.contains(text) ||
          taskList.documentNumber.toLowerCase().contains(text) ||
          taskList.documentNumber.toUpperCase().contains(text) ||
          taskList.taskStatusName.contains(text) ||
          taskList.taskStatusName.toLowerCase().contains(text) ||
          taskList.taskStatusName.toUpperCase().contains(text)) {
        searchResultAsSubTaskList.add(taskList);
      }
    }

    setState(() {});
  }

  rowDataAsSubTask(List<Task> task, BuildContext context, int index,
      double height, double width) {
    double textFontNormal = (height * 0.02) * (width * 0.002);
    double textFontLarge = (height * 0.024) * (width * 0.0024);
    double textFontSmall = (height * 0.020) * (width * 0.0020);
    double textFontExtraSmall = (height * 0.010) * (width * 0.0005);
    double smallIconSize = (height * 0.0041) * (width * 0.0041);

    double textFontButton = (height * 0.010) * (width * 0.0008);
    double paddingButton = (height * 0.005) * (width * 0.0008);
    double padding = (height * 0.005) * (width * 0.0008);

    int time = int.parse(task[index - 1].taskCreatedTimestamp);

    DateTime a = DateTime.fromMillisecondsSinceEpoch((time));
    DateTime b = DateTime.now();

    Duration difference = b.difference(a);

    int days = difference.inDays % 365 % 30;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    return SizedBox(
      height: (height * 0.12),
      // width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.5),
        ),
        child: Row(
          children: [
            if (task[index - 1].taskType == '1')
              Expanded(
                flex: 1,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xffFF0000),
                ),
              ),
            if (task[index - 1].taskType == '2')
              Expanded(
                flex: 1,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xff800000),
                ),
              ),
            if (task[index - 1].taskType == '3')
              Expanded(
                flex: 1,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xffFFFF00),
                ),
              ),
            if (task[index - 1].taskType == '4')
              Expanded(
                flex: 1,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xff808000),
                ),
              ),
            if (task[index - 1].taskType == '5')
              Expanded(
                flex: 1,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xff00FFFF),
                ),
              ),
            if (task[index - 1].taskType == '6')
              Expanded(
                flex: 1,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xff008080),
                ),
              ),
            if (task[index - 1].taskType == '7')
              Expanded(
                flex: 1,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xffFF00FF),
                ),
              ),
            if (task[index - 1].taskType == '8')
              Expanded(
                flex: 1,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xff800080),
                ),
              ),
            if (task[index - 1].taskType == '9')
              Expanded(
                flex: 1,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromARGB(255, 190, 114, 0),
                ),
              ),
            if (task[index - 1].taskType == '10')
              Expanded(
                flex: 1,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromARGB(255, 0, 3, 190),
                ),
              ),
            if (task[index - 1].taskType == '11')
              Expanded(
                flex: 1,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromARGB(255, 14, 168, 0),
                ),
              ),
            Expanded(
              flex: 50,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: SelectableText(
                                      task[index - 1].taskId,
                                      style: TextStyle(
                                          fontSize: textFontNormal,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: SelectableText(
                                      task[index - 1].taskStatusName,
                                      style: TextStyle(
                                          fontSize: textFontNormal,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 11,
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: GestureDetector(
                                    onTap: () async {
                                      SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                      prefs.setString('main_task_id', mainTaskId);
                                      prefs.setString(
                                          'main_task_title', mainTaskTitle);
                                      prefs.setString(
                                          'task_id', task[index - 1].taskId);
                                      prefs.setString(
                                          'task_title', task[index - 1].taskTitle);
                                      prefs.setString('task_description',
                                          task[index - 1].taskDescription);
                                      prefs.setString(
                                          'company', task[index - 1].company);
                                      prefs.setString(
                                          'source_from', task[index - 1].sourceFrom);
                                      prefs.setString(
                                          'assign_to', task[index - 1].assignTo);
                                      prefs.setString(
                                          'due_date', task[index - 1].dueDate);
                                      prefs.setString('task_create_by_id',
                                          task[index - 1].taskCreateById);
                                      prefs.setString('task_create_by',
                                          task[index - 1].taskCreateBy);
                                      prefs.setString('task_create_date',
                                          task[index - 1].taskCreateDate);
                                      prefs.setString('task_create_date',
                                          task[index - 1].taskCreateDate);
                                      prefs.setString('task_created_timestamp',
                                          task[index - 1].taskCreatedTimestamp);
                                      prefs.setString(
                                          'task_type', task[index - 1].taskType);
                                      prefs.setString('task_type_name',
                                          task[index - 1].taskTypeName);
                                      prefs.setString(
                                          'task_status', task[index - 1].taskStatus);
                                      prefs.setString('task_status_name',
                                          task[index - 1].taskStatusName);
                                      prefs.setString('complete_by',
                                          task[index - 1].taskFinishedBy);
                                      prefs.setString('complete_by_date',
                                          task[index - 1].taskFinishedByDate);
                                      if (!mounted) return;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewSubTask()),
                                      );
                                    },
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        task[index - 1].taskTitle,
                                        style:
                                        TextStyle(fontSize: textFontLarge),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.more_vert,
                                  ),
                                  color: Colors.black,
                                  onPressed: () async {
                                    showMyDialog(
                                        task[index - 1],
                                        task[index - 1].taskTitle,
                                        task[index - 1].taskId,
                                        task[index - 1].assignTo,
                                        textFontSmall,
                                        task[index - 1].taskCreatedTimestamp);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Tooltip(
                                      message: "",
                                      child: Text(
                                        'Due Date : ${task[index - 1].dueDate}',
                                        style: TextStyle(
                                            fontSize: textFontNormal,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Tooltip(
                                      message: task[index - 1].documentNumber,
                                      child: Text('Doc No : ${task[index - 1].documentNumber}',
                                        style:
                                        TextStyle(fontSize: textFontNormal,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Tooltip(
                                      message: task[index - 1].taskCreateDate,
                                      child: Text(
                                        task[index - 1].taskCreateDate,
                                        style:
                                            TextStyle(fontSize: textFontNormal),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    retrieverData();
  }

  void retrieverData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mainTaskId = (prefs.getString('main_task_id') ?? '');
      mainTaskTitle = (prefs.getString('main_task_title') ?? '');
      taskType = (prefs.getString('main_task_type') ?? '');
      taskTypeName = (prefs.getString('main_task_type_name') ?? '');
      taskCreateBy = (prefs.getString('main_task_create_by') ?? '');
      mainTaskFinishedBy = (prefs.getString('main_task_finished_by') ?? '');
      mainTaskFinishedByDate =
          (prefs.getString('main_task_finished_by_date') ?? '');
      dueDate = (prefs.getString('main_task_due_date') ?? '');
      taskCreateDate = (prefs.getString('main_task_create_date') ?? '');
      taskCreatedTimestamp =
          (prefs.getString('main_task_created_timestamp') ?? '');
      taskStatusName = (prefs.getString('main_task_status_name') ?? '');
      taskStatus = (prefs.getString('main_task_status') ?? '');
      company = (prefs.getString('main_task_company') ?? '').toUpperCase();
      sourceFrom =
          (prefs.getString('main_task_source_from') ?? '').toUpperCase();
      assignTo = (prefs.getString('main_task_assign_to') ?? '').toUpperCase();
      userName = (prefs.getString('user_name') ?? '');
      userRole = (prefs.getString('user_role') ?? '');
      firstName = (prefs.getString('first_name') ?? '').toUpperCase();
      lastName = (prefs.getString('last_name') ?? '').toUpperCase();
    });
    await getSubTaskListByMainTaskId(mainTaskId);
  }

  Future<void> getSubTaskListByMainTaskId(var taskId) async {
    subTaskList.clear();
    var data = {
      "main_task_id": "$taskId",
    };

    const url = "http://dev.connect.cbs.lk/subTaskListByMainTaskId.php";
    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (res.statusCode == 200) {
      final responseJson = json.decode(res.body);
      //   print(res.body);
      setState(() {
        for (Map details in responseJson) {
          subTaskList.add(Task.fromJson(details));
        }
      });
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }


  Future<void> showMyDialog(Task task, var title, var titleId, var assignTo,
      double fontSize, var timestamp) async {
    int time = int.parse(timestamp);

    DateTime a = DateTime.fromMillisecondsSinceEpoch((time));
    DateTime b = DateTime.now();

    Duration difference = b.difference(a);

    int days = difference.inDays % 365 % 30;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'This Task Assign To: $assignTo',
                  style: TextStyle(color: Colors.black, fontSize: fontSize),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "$days day(s) $hours hour(s) $minutes minute(s) $seconds second(s).",
                  style: TextStyle(
                      fontSize: fontSize, fontWeight: FontWeight.bold),
                ),
                //   Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Edit Task',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () async {
             //   Navigator.of(context).pop();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('sub_task_id', task.taskId);
                prefs.setString('sub_task_title', task.taskTitle);
                prefs.setString('intent_from', "subtask_dashboard");
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditSubTask()),
                );
              },
            ),

            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    double textFontNormal = (sizeHeight * 0.008) * (sizeWidth * 0.008);
    double textFontLarge = (sizeHeight * 0.028) * (sizeWidth * 0.002);
    double paddingButton = (sizeHeight * 0.004) * (sizeWidth * 0.0008);
    double padding = (sizeHeight * 0.012) * (sizeWidth * 0.0012);
    double iconSize = (sizeHeight * 0.008) * (sizeWidth * 0.008);
    double textFontNormal2 = (sizeHeight * 0.022) * (sizeWidth * 0.0022);

    double paddingCard = (sizeHeight * 0.0005) * (sizeWidth * 0.0004);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return WillPopScope(
      onWillPop: () {
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const MainDashBoard();
            },
          ),
        );
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
                  mainTaskTitle,
                  style: const TextStyle(color: Colors.white, fontSize: 15.0),
                ),
                const Text(
                  "SUB TASK DASHBOARD",
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                )
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
                        return const MainTaskComments();
                      },
                    ),
                  );
                },
              ),
            ],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const MainDashBoard();
                    },
                  ),
                );
              },
            ),
          ),
          body: Column(
            children: [

              Expanded(
                flex: 3,
                child: Container(
                  height: sizeHeight,
                  width: sizeWidth,
                  color: Colors.grey[400],
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Card(
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.search,
                            size: iconSize,
                          ),
                          title: TextField(
                            controller: taskListController,
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                            ),
                            onChanged: onSearchTextChangedUser,
                            style: TextStyle(fontSize: textFontNormal),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.cancel,
                              size: iconSize,
                            ),
                            onPressed: () {
                              taskListController.clear();
                              onSearchTextChangedUser('');
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: sizeHeight,
                  width: sizeWidth,
                  child: Padding(
                    padding: EdgeInsets.all(paddingButton),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(paddingButton),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: dropdownvalue,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: iconSize,
                                  ),
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: textFontNormal2),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      taskListController.text = "";
                                      dropdownvalue = value!;
                                      if (dropdownvalue != "-All-") {
                                        taskListController.text =
                                            dropdownvalue.toString();
                                      } else {
                                        taskListController.text = "";
                                      }
                                    });
                                    if (dropdownvalue != "-All-") {
                                      onSearchTextChangedUser(dropdownvalue);
                                    } else {
                                      onSearchTextChangedUser('');
                                    }
                                  },
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
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: dropdownvalue1,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: iconSize,
                                  ),
                                  items: items1.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: textFontNormal2),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      taskListController.text = "";
                                      dropdownvalue1 = value!;
                                      if (dropdownvalue1 != "-All-") {
                                        taskListController.text =
                                            dropdownvalue1.toString();
                                      } else {
                                        taskListController.text = "";
                                      }
                                    });
                                    if (dropdownvalue1 != "-All-") {
                                      onSearchTextChangedUser(dropdownvalue1);
                                    } else {
                                      onSearchTextChangedUser('');
                                    }
                                  },
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
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: dropdownvalue2,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: iconSize,
                                  ),
                                  items: items2.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: textFontNormal2),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      taskListController.text = "";
                                      dropdownvalue2 = value!;
                                      if (dropdownvalue2 != "-All-") {
                                        taskListController.text =
                                            dropdownvalue2.toString();
                                      } else {
                                        taskListController.text = "";
                                      }
                                    });
                                    if (dropdownvalue2 != "-All-") {
                                      onSearchTextChangedUser(dropdownvalue2);
                                    } else {
                                      onSearchTextChangedUser('');
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: sizeHeight,
                  width: sizeWidth,
                  child: Padding(
                    padding: EdgeInsets.all(paddingButton),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(paddingButton),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: dropdownvalue3,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: iconSize,
                                  ),
                                  items: items3.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: textFontNormal2),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      taskListController.text = "";
                                      dropdownvalue3 = value!;
                                      if (dropdownvalue3 != "-All-") {
                                        taskListController.text =
                                            dropdownvalue3.toString();
                                      } else {
                                        taskListController.text = "";
                                      }
                                    });
                                    if (dropdownvalue3 != "-All-") {
                                      onSearchTextChangedUser(dropdownvalue2);
                                    } else {
                                      onSearchTextChangedUser('');
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 15,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: searchResultAsSubTaskList.isNotEmpty ||
                          taskListController.text.isNotEmpty
                      ? ListView.builder(
                          itemCount: searchResultAsSubTaskList.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              title: rowDataAsSubTask(
                                searchResultAsSubTaskList,
                                context,
                                (i + 1),
                                sizeHeight,
                                sizeWidth,
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: subTaskList.length,
                          itemBuilder: (context, index) {
                            subTaskList.sort((a, b) => b
                                .taskCreatedTimestamp
                                .compareTo(a.taskCreatedTimestamp));
                            return ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.1),
                              ),
                              title: rowDataAsSubTask(
                                subTaskList,
                                context,
                                (index + 1),
                                sizeHeight,
                                sizeWidth,
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              SharedPreferences
              prefs =
              await SharedPreferences
                  .getInstance();
              prefs.setString(
                  'main_task_id',
                  mainTaskId);
              prefs.setString(
                  'main_task_title',
                  mainTaskTitle);
              prefs.setString(
                  'intent_from',
                  "sub_dashboard");

              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateSubTask()),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
