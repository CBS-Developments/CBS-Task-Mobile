import 'dart:async';
import 'dart:convert';
import 'package:cbs_task/CreateSubTask.dart';
import 'package:cbs_task/EditMainTask.dart';
import 'package:cbs_task/MainDashBoard.dart';
import 'package:cbs_task/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskLog extends StatefulWidget {
  const TaskLog({ Key? key}) : super(key: key);

  @override
  TaskLogState createState() => TaskLogState();
}

class TaskLogState extends State<TaskLog> {
  late Timer timer;
  late String userName;
  late String firstName;
  late String lastName;
  late String userRole;
  List<MainTask> searchResultAsMainTaskList = [];
  List<MainTask> mainTaskList = [];
  List<taskLog> taskLogList = [];
  TextEditingController taskListController = TextEditingController();
  late List jsonResponse;
  var s_year;
  var s_month ;

  Future<List?> getTaskLogList() async {

    final now = DateTime.now();
     s_year = DateFormat('yyyy').format(now);
     s_month = DateFormat('MM').format(now);

    var data = {
      "log_create_by_year": "$s_year",
      "log_create_by_month":"$s_month"
    };

    const url = "http://dev.connect.cbs.lk/taskLogListByMonth.php";
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
      if (jsonDecode(res.body) != "Error") {
        jsonResponse = json.decode(res.body);
        if (jsonResponse != null) {
          return jsonResponse.map((sec) => taskLog.fromJson(sec)).toList();
        }
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load jobs from API');
    }
    return jsonResponse;
  }

  rowDataAsTaskLog(List<taskLog> taskLog, BuildContext context, int index,
      double height, double width) {
    double textFontSmall = (height * 0.0055) * (width * 0.0055);

    int time = int.parse(taskLog[index - 1].logCreateByTimestamp);

    DateTime a = DateTime.fromMillisecondsSinceEpoch((time));
    DateTime b = DateTime.now();

    Duration difference = b.difference(a);

    int days = difference.inDays % 365 % 30;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    if (difference.inMinutes <= 15) {
      return Container(
        height: (height * 0.06),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        taskLog[index - 1].logSummary,
                        style: TextStyle(
                            fontSize: textFontSmall,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
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
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SelectableText(
                        taskLog[index - 1].taskId,
                        style: TextStyle(
                            fontSize: textFontSmall,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "$minutes minute(s) $seconds second(s).",
                        style: TextStyle(
                            fontSize: textFontSmall,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (difference.inMinutes >= 16 && difference.inMinutes < 1440) {
      return Container(
        height: (height * 0.05),
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(255, 245, 244, 181),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Container(
                    child: Flexible(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          taskLog[index - 1].logSummary,
                          style: TextStyle(
                              fontSize: textFontSmall,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
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
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SelectableText(
                        taskLog[index - 1].taskId,
                        style: TextStyle(
                            fontSize: textFontSmall,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "$hours hour(s) $minutes minute(s) $seconds second(s).",
                        //taskLog[index - 1].logCreateByDate,
                        style: TextStyle(
                            fontSize: textFontSmall,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: (height * 0.05),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Container(
                    child: Flexible(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          taskLog[index - 1].logSummary,
                          style: TextStyle(fontSize: textFontSmall),
                        ),
                      ),
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
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SelectableText(
                        taskLog[index - 1].taskId,
                        style: TextStyle(
                            fontSize: textFontSmall,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        taskLog[index - 1].logCreateByDate,
                        style: TextStyle(
                            fontSize: textFontSmall,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        getTaskLogList();
      });
    });
    super.initState();
    retrieverData();
    getTaskLogList();
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
    double paddingButton = (sizeHeight * 0.0002) * (sizeWidth * 0.0002);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const MainDashBoard(); // Navigates to MainDashBoard and replaces the current screen
            },
          ),
        );
        return false; // Prevents the default back action
      },

      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "CBS TASK",
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
                Text(
                  "TASK LOG",
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                )
              ],
            ),
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
                flex: 6,
                child: Container(
                  color: Colors.purple,
                  height: sizeHeight,
                  width: sizeWidth,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: paddingButton, vertical: paddingButton),
                    color: Colors.white,
                    height: sizeHeight,
                    width: sizeWidth,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        FutureBuilder<List<taskLog>>(
                          // future: getTaskLogList(context),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<taskLog>? data = snapshot.data;

                              data?.sort((a, b) => b.logCreateByTimestamp
                                  .compareTo(a.logCreateByTimestamp));
                              return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data?.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: rowDataAsTaskLog(
                                        data!,
                                        context,
                                        (index + 1),
                                        sizeHeight,
                                        sizeWidth,
                                      ),
                                    );
                                  });
                            } else if (snapshot.hasError) {
                              return const Text("-Empty-");
                            }
                            return const Text("Loading...");
                          },
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
