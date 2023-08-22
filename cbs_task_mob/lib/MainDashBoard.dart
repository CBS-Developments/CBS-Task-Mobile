import 'dart:convert';

import 'package:cbs_task/CreateMainTask.dart';
import 'package:cbs_task/CreateSubTask.dart';
import 'package:cbs_task/EditMainTask.dart';
import 'package:cbs_task/Login.dart';
import 'package:cbs_task/SubTaskDashBoard.dart';
import 'package:cbs_task/TaskLog.dart';
import 'package:cbs_task/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDashBoard extends StatefulWidget {
  const MainDashBoard({Key key}) : super(key: key);

  @override
  MainDashBoardState createState() => MainDashBoardState();
}

class MainDashBoardState extends State<MainDashBoard> {
  String userName;
  String firstName;
  String lastName;
  String userRole;
  List<MainTask> searchResultAsMainTaskList = [];
  List<MainTask> mainTaskList = [];
  TextEditingController taskListController = TextEditingController();

  onSearchTextChangedUser(String text) async {
    searchResultAsMainTaskList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    for (var taskList in mainTaskList) {
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
          taskList.taskStatusName.contains(text) ||
          taskList.taskStatusName.toLowerCase().contains(text) ||
          taskList.taskStatusName.toUpperCase().contains(text)) {
        searchResultAsMainTaskList.add(taskList);
      }
    }

    setState(() {});
  }

  Future<void> getTaskList() async {
    mainTaskList.clear();
    var data = {};

    const url = "http://dev.connect.cbs.lk/mainTaskList.php";
    http.Response res = await http.post(
      url,
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (res.statusCode == 200) {
      final responseJson = json.decode(res.body);
      setState(() {
        for (Map details in responseJson) {
          mainTaskList.add(MainTask.fromJson(details));
        }
      });
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  showAlertDialogForDeleteTask(BuildContext context, List<MainTask> task,
      int position, double textSmall, double textNormal, double textLarge) {
    // set up the button
    Widget okButton = MaterialButton(
      child: Text(
        "OK",
        style: TextStyle(
          color: Colors.black,
          fontSize: textNormal,
        ),
      ),
      onPressed: () {
        removeMainTask(task[position - 1].taskId, "99", "Remove");
      },
    );

    Widget cancelButton = MaterialButton(
      child: Text(
        "CANCEL",
        style: TextStyle(
          color: Colors.black,
          fontSize: textNormal,
        ),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Column(
        children: [
          IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            color: Colors.red,
            onPressed: () async {},
          ),
          Text(
            task[position - 1].taskTitle,
            style: TextStyle(
                color: Colors.black,
                fontSize: textLarge,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text(
        "Are you sure you want to delete this task?",
        style: TextStyle(
          color: Colors.black,
          fontSize: textNormal,
        ),
      ),
      actions: [
        okButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> removeMainTask(
      var taskId, var taskStatus, var taskStatusName) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int taskTimeStamp = timestamp;
    var timeSt = taskTimeStamp;
    var dt = DateTime.fromMillisecondsSinceEpoch(taskTimeStamp);
    var stringDate = DateFormat('MM/dd/yyyy, hh:mm a').format(dt);
    String url;
    url = "http://dev.connect.cbs.lk/removeMainTask.php";

    var data = {
      "task_id": "$taskId",
      "task_status": "$taskStatus",
      "task_status_name": "$taskStatusName",
      "action_taken_by_id": userName,
      "action_taken_by": "$firstName $lastName",
      "action_taken_date": stringDate,
      "action_taken_timestamp": "$timeSt",
    };

    http.Response res = await http.post(
      url,
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (res.statusCode.toString() == "200") {
      if (jsonDecode(res.body) == "true") {
        if (!mounted) return true;
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          mainTaskList.clear();
          getTaskList();
        });
      }
    } else {
      if (!mounted) return false;
      snackBar(context, "Error", Colors.redAccent);
    }
    return true;
  }

  rowDataAsTask(List<MainTask> task, BuildContext context, int index,
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
      height: (height * 0.11),
      width: MediaQuery.of(context).size.width,
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
                  color: Color(0xff808000),
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
                      // Expanded(
                      //   flex: 1,
                      //   child: SizedBox(
                      //     height: MediaQuery.of(context).size.height,
                      //     width: MediaQuery.of(context).size.width,
                      //     child: Row(
                      //       children: [
                      //         // Expanded(
                      //         //   flex: 5,
                      //         //   child: Container(
                      //         //     height: MediaQuery.of(context).size.height,
                      //         //     width: MediaQuery.of(context).size.width,
                      //         //     color: Colors.white,
                      //         //     child: Align(
                      //         //       alignment: Alignment.centerLeft,
                      //         //       child: SelectableText(
                      //         //         task[index - 1].taskId,
                      //         //         style: TextStyle(
                      //         //             fontSize: textFontNormal,
                      //         //             fontWeight: FontWeight.bold),
                      //         //       ),
                      //         //     ),
                      //         //   ),
                      //         // ),
                      //         // Expanded(
                      //         //   flex: 3,
                      //         //   child: Container(
                      //         //     height: MediaQuery.of(context).size.height,
                      //         //     width: MediaQuery.of(context).size.width,
                      //         //     color: Colors.white,
                      //         //     child: Align(
                      //         //       alignment: Alignment.centerRight,
                      //         //       child: SelectableText(
                      //         //         task[index - 1].taskStatusName,
                      //         //         style: TextStyle(
                      //         //             fontSize: textFontNormal,
                      //         //             fontWeight: FontWeight.bold),
                      //         //       ),
                      //         //     ),
                      //         //   ),
                      //         // ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        flex: 1,
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
                                    prefs.setString('main_task_id',
                                        task[index - 1].taskId);
                                    prefs.setString('main_task_title',
                                        task[index - 1].taskTitle);
                                    prefs.setString('task_type',
                                        task[index - 1].taskType);
                                    prefs.setString('main_task_type_name',
                                        task[index - 1].taskTypeName);
                                    prefs.setString('main_task_create_by',
                                        task[index - 1].taskCreateBy);
                                    prefs.setString('main_task_create_date',
                                        task[index - 1].taskCreateDate);
                                    prefs.setString(
                                        'main_task_created_timestamp',
                                        task[index - 1].taskCreatedTimestamp);
                                    prefs.setString('main_task_status',
                                        task[index - 1].taskStatus);
                                    prefs.setString('main_task_status_name',
                                        task[index - 1].taskStatusName);
                                    prefs.setString('main_task_due_date',
                                        task[index - 1].dueDate);
                                    prefs.setString('main_task_assign_to',
                                        task[index - 1].assignTo);
                                    prefs.setString('main_task_source_from',
                                        task[index - 1].sourceFrom);
                                    prefs.setString('main_task_company',
                                        task[index - 1].company);
                                    prefs.setString(
                                        'main_task_document_number',
                                        task[index - 1].documentNumber);
                                    prefs.setString('main_task_finished_by',
                                        task[index - 1].taskFinishedBy);
                                    prefs.setString(
                                        'main_task_finished_by_date',
                                        task[index - 1].taskFinishedByDate);
                                    if (!mounted) return;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SubTaskDashBoard()),
                                    );
                                  },
                                  onLongPress: () {
                                    if (userRole == '1') {
                                      showAlertDialogForDeleteTask(
                                          context,
                                          task,
                                          index,
                                          textFontSmall,
                                          textFontNormal,
                                          textFontLarge);
                                    } else {
                                      snackBar(context, 'Permission denied',
                                          Colors.yellow);
                                    }
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
                      Expanded(
                        flex: 1,
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
    getTaskList();
  }

  void retrieverData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = (prefs.getString('user_name') ?? '');
      userRole = (prefs.getString('user_role') ?? '');
      firstName = (prefs.getString('first_name') ?? '').toUpperCase();
      lastName = (prefs.getString('last_name') ?? '').toUpperCase();
    });
  }

  Future<void> showMyDialog(MainTask task, var title, var titleId, var assignTo,
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
                'Create Sub Task',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('main_task_id', task.taskId);
                prefs.setString('main_task_title', task.taskTitle);
                prefs.setString('intent_from', "main_dashboard");
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateSubTask()),
                );
              },
            ),
            TextButton(
              child: const Text(
                'Edit Main Task',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('main_task_id', task.taskId);
                prefs.setString('task_title', task.taskTitle);
                prefs.setString('task_type', task.taskType);
                prefs.setString('task_type_name', task.taskTypeName);
                prefs.setString('task_create_by', task.taskCreateBy);
                prefs.setString('task_create_date', task.taskCreateDate);
                prefs.setString(
                    'task_created_timestamp', task.taskCreatedTimestamp);
                prefs.setString('task_status', task.taskStatus);
                prefs.setString('task_status_name', task.taskStatusName);
                prefs.setString('due_date', task.dueDate);
                prefs.setString('assign_to', task.assignTo);
                prefs.setString('source_from', task.sourceFrom);
                prefs.setString('company', task.company);
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditMainTask()),
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
    double textFontLarge = (sizeHeight * 0.020) * (sizeWidth * 0.001);
    double paddingButton = (sizeHeight * 0.004) * (sizeWidth * 0.0008);
    double padding = (sizeHeight * 0.020) * (sizeWidth * 0.0020);
    double iconSize = (sizeHeight * 0.007) * (sizeWidth * 0.007);
    double textFontNormal2 = (sizeHeight * 0.022) * (sizeWidth * 0.0022);

    double paddingCard = (sizeHeight * 0.0005) * (sizeWidth * 0.0004);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm Exit"),
                content: const Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  MaterialButton(
                    child: const Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  MaterialButton(
                    child: const Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.deepPurple,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
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
                  "MAIN TASK DASHBOARD",
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                )
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.circle,
                ),
                color: Colors.green,
                tooltip: 'Completed Task',
                onPressed: () async {
                },
              ),

              IconButton(
                icon: const Icon(
                  Icons.apps_outlined,
                ),
                color: Colors.white,
                tooltip: 'Log',
                onPressed: () async {
                  saveRefrance("login_state", null);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const TaskLog();
                    }),
                  );
                },
              ),

              IconButton(
                icon: const Icon(
                  Icons.logout,
                ),
                color: Colors.white,
                tooltip: 'Log-Out',
                onPressed: () async {
                  saveRefrance("login_state", null);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const LoginPage();
                    }),
                  );
                },
              ),
            ],
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
                child: Container(
                  color: Colors.purple,
                  child: Padding(
                    padding: EdgeInsets.all(paddingButton),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                             margin: const EdgeInsets.only(left: 0.5, right: 0.25, top: 0.5,bottom: 0.5),
                            color: Colors.white,
                            child: Center(
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
                                  onChanged: (String value) {
                                    setState(() {
                                      taskListController.text = "";
                                      dropdownvalue = value;
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
                          child: Container(
                            color: Colors.white,
                             margin: const EdgeInsets.only(left: 0.25, right: 0.25, top: 0.5,bottom: 0.5),
                            child: Center(
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
                                  onChanged: (String value) {
                                    setState(() {
                                      taskListController.text = "";
                                      dropdownvalue1 = value;
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
                          child: Container(
                            color: Colors.white,
                            margin: const EdgeInsets.only(left: 0.25, right: 0.5, top: 0.5,bottom: 0.5),
                            child: Center(
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
                                  onChanged: (String value) {
                                    setState(() {
                                      taskListController.text = "";
                                      dropdownvalue2 = value;
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
                child: Container(
                  height: sizeHeight,
                  width: sizeWidth,
                  color: Colors.purple,
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(left: 1.0, right: 1.0, top: 0.0,bottom: 1.0),
                    child: Padding(
                      padding: EdgeInsets.all(padding),
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
                          onChanged: (String value) {
                            setState(() {
                              taskListController.text = "";
                              dropdownvalue3 = value;
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
              ),
              Expanded(
                flex: 15,
                child: Container(
                //  height: MediaQuery.of(context).size.height,
               //   width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: searchResultAsMainTaskList.isNotEmpty ||
                          taskListController.text.isNotEmpty
                      ? ListView.builder(
                          itemCount: searchResultAsMainTaskList.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              title: rowDataAsTask(
                                searchResultAsMainTaskList,
                                context,
                                (i + 1),
                                sizeHeight,
                                sizeWidth,
                              ),
                              // dense: true,
                              // visualDensity: const VisualDensity(vertical: -1),
                              //  ),
                              //  margin: const EdgeInsets.all(0.0),
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: mainTaskList.length,
                          itemBuilder: (context, index) {
                            mainTaskList.sort((a, b) => b
                                .taskCreatedTimestamp
                                .compareTo(a.taskCreatedTimestamp));
                            return ListTile(
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(0.1),
                              // ),
                              title: rowDataAsTask(
                                mainTaskList,
                                context,
                                (index + 1),
                                sizeHeight,
                                sizeWidth,
                              ),
                              //),
                              //   margin: const EdgeInsets.all(0.0),
                              //   dense: true,
                              //   visualDensity: const VisualDensity(vertical: -1),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateMainTask()),
              );
            },
            backgroundColor: Colors.deepPurple,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
