import 'dart:convert';
import 'package:cbs_task/MainDashBoard.dart';
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

class EditMainTask extends StatefulWidget {
  const EditMainTask({Key key}) : super(key: key);
  @override
  EditMainTaskState createState() => EditMainTaskState();
}

class EditMainTaskState extends State<EditMainTask> {
  String userName;
  String firstName;
  String lastName;
  String mainTaskId;
  String taskTitle;
  String taskType;
  String taskTypeName;
  String taskCreateBy;
  String company;
  String sourceFrom;
  String assign_to;
  String dueDate;
  String taskStatusName;
  String taskStatus;
  String taskCreateDate;
  String documentNumber;
  String taskCreatedTimestamp;

  bool titleValidation = false;

  int taskTypePosition = 1;
  String taskTypeString = "Top Urgent";
  menuitem mitem = menuitem.item1;
  List<String> assignTo = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController assignToController = TextEditingController();
  TextEditingController documentNumberController = TextEditingController();
  TextEditingController editDueDateController = TextEditingController();

  textListenerDueDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('due_date', editDueDateController.text);
    retrieverData(6);
  }

  @override
  void dispose() {
    super.dispose();
    editDueDateController.dispose();
  }

  @override
  void initState() {
    super.initState();
    retrieverData(0);
    editDueDateController.addListener(textListenerDueDate);
  }

  void retrieverData(int type) async {
    final prefs = await SharedPreferences.getInstance();
    if (type == 0) {
      setState(() {
        mainTaskId = (prefs.getString('main_task_id') ?? '');
        taskTitle = (prefs.getString('task_title') ?? '');
        taskType = (prefs.getString('task_type') ?? '');
        taskTypeName = (prefs.getString('task_type_name') ?? '');
        taskCreateBy = (prefs.getString('task_create_by') ?? '');
        dueDate = (prefs.getString('due_date') ?? '');
        taskCreateDate = (prefs.getString('task_create_date') ?? '');
        taskCreatedTimestamp =
            (prefs.getString('task_created_timestamp') ?? '');
        taskStatusName = (prefs.getString('task_status_name') ?? '');
        taskStatus = (prefs.getString('task_status') ?? '');
        company = (prefs.getString('company') ?? '');
        sourceFrom = (prefs.getString('source_from') ?? '');
        assign_to = (prefs.getString('assign_to') ?? '');
        userName = (prefs.getString('user_name') ?? '');
        firstName = (prefs.getString('first_name') ?? '').toUpperCase();
        lastName = (prefs.getString('last_name') ?? '').toUpperCase();
        documentNumber = (prefs.getString('document_number') ?? '');
      });

      titleController.text = taskTitle;
      editDueDateController.text = dueDate;
      assignToController.text = assign_to;
      documentNumberController.text = documentNumber;

      if (taskType == '1') {
        taskTypePosition = 1;
        taskTypeString = "Top Urgent";
        mitem = menuitem.item1;
      } else if (taskType == '2') {
        taskTypePosition = 2;
        taskTypeString = "Urgent 24Hr";
        mitem = menuitem.item2;
      } else if (taskType == '3') {
        taskTypePosition = 3;
        taskTypeString = "Error";
        mitem = menuitem.item3;
      } else if (taskType == '4') {
        taskTypePosition = 4;
        taskTypeString = "Remind";
        mitem = menuitem.item4;
      } else if (taskType == '5') {
        taskTypePosition = 5;
        taskTypeString = "Do it again";
        mitem = menuitem.item5;
      } else if (taskType == '6') {
        taskTypePosition = 6;
        taskTypeString = "Correction";
        mitem = menuitem.item6;
      } else if (taskType == '7') {
        taskTypePosition = 7;
        taskTypeString = "Disappointed";
        mitem = menuitem.item7;
      } else if (taskType == '8') {
        taskTypePosition = 8;
        taskTypeString = "V.Disappointed";
        mitem = menuitem.item8;
      } else if (taskType == '9') {
        taskTypePosition = 9;
        taskTypeString = "Regular";
        mitem = menuitem.item9;
      } else if (taskType == '10') {
        taskTypePosition = 10;
        taskTypeString = "Medium";
        mitem = menuitem.item10;
      } else if (taskType == '11') {
        taskTypePosition = 11;
        taskTypeString = "Low";
        mitem = menuitem.item11;
      }
    } else if (type == 2) {
      setState(() {
        taskType = (prefs.getString('task_type') ?? '');
        taskTypeName = (prefs.getString('task_type_name') ?? '');
      });
      if (taskType == '1') {
        taskTypePosition = 1;
        taskTypeString = "Top Urgent";
        mitem = menuitem.item1;
      } else if (taskType == '2') {
        taskTypePosition = 2;
        taskTypeString = "Urgent 24Hr";
        mitem = menuitem.item2;
      } else if (taskType == '3') {
        taskTypePosition = 3;
        taskTypeString = "Error";
        mitem = menuitem.item3;
      } else if (taskType == '4') {
        taskTypePosition = 4;
        taskTypeString = "Remind";
        mitem = menuitem.item4;
      } else if (taskType == '5') {
        taskTypePosition = 5;
        taskTypeString = "Do it again";
        mitem = menuitem.item5;
      } else if (taskType == '6') {
        taskTypePosition = 6;
        taskTypeString = "Correction";
        mitem = menuitem.item6;
      } else if (taskType == '7') {
        taskTypePosition = 7;
        taskTypeString = "Disappointed";
        mitem = menuitem.item7;
      } else if (taskType == '8') {
        taskTypePosition = 8;
        taskTypeString = "V.Disappointed";
        mitem = menuitem.item8;
      } else if (taskType == '9') {
        taskTypePosition = 9;
        taskTypeString = "Regular";
        mitem = menuitem.item9;
      } else if (taskType == '10') {
        taskTypePosition = 10;
        taskTypeString = "Medium";
        mitem = menuitem.item10;
      } else if (taskType == '11') {
        taskTypePosition = 11;
        taskTypeString = "Low";
        mitem = menuitem.item11;
      }
    } else if (type == 3) {
      setState(() {
        sourceFrom = (prefs.getString('source_from') ?? '');
      });
    } else if (type == 4) {
      setState(() {
        assign_to = (prefs.getString('assign_to') ?? '');
      });
    } else if (type == 5) {
      setState(() {
        company = (prefs.getString('company') ?? '');
      });
    } else if (type == 6) {
      setState(() {
        dueDate = (prefs.getString('due_date') ?? '');
      });
    }
  }

  Future<bool> updateTask(
      BuildContext context,
      String taskId,
      String sourceFrom,
      String assignTo,
      String company,
      String dueDate,
      String documentNumber) async {
    if (titleController.text.trim().isEmpty) {
      setState(() {
        titleValidation = true;
        snackBar(context, "Task title can't be empty", Colors.redAccent);
      });
      return false;
    } else {
      setState(() {
        titleValidation = false;
      });
    }

    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int taskTimeStamp = timestamp;
    var timeSt = taskTimeStamp;
    var dt = DateTime.fromMillisecondsSinceEpoch(taskTimeStamp);

    var stringDate = DateFormat('MM/dd/yyyy').format(dt);
    var url = "http://dev.connect.cbs.lk/updateMainTask.php";
    var data = {
      "task_id": taskId,
      "task_title": titleController.text,
      "task_type": taskType,
      "task_type_name": taskTypeString,
      "due_date": dueDate,
      "task_edit_by": "$firstName $lastName",
      "task_edit_by_id": userName,
      "task_edit_by_date": stringDate,
      "task_edit_by_timestamp": "$timeSt",
      "source_from": sourceFrom,
      "assign_to": assignTo,
      "company": company,
      "document_number": documentNumber
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('task_title', titleController.text);
        prefs.setString('document_number', documentNumber);

        retrieverData(0);
        if (!mounted) return true;
        snackBar(context, "Updated", Colors.green);

        return true;
      } else {
        if (!mounted) return false;
        snackBar(context, "Error", Colors.red);
      }
    } else {
      if (!mounted) return false;
      snackBar(context, "Error", Colors.redAccent);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    double textFontNormal = (sizeHeight * 0.020) * (sizeWidth * 0.0015);
    double textFontLarge = (sizeHeight * 0.020) * (sizeWidth * 0.001);
    double paddingButton = (sizeHeight * 0.004) * (sizeWidth * 0.0008);
    double iconSize = (sizeHeight * 0.008) * (sizeWidth * 0.008);
    double paddingCard = (sizeHeight * 0.0005) * (sizeWidth * 0.0004);
    double padding = (sizeHeight * 0.012) * (sizeWidth * 0.0012);
    double textFontNormal2 = (sizeHeight * 0.022) * (sizeWidth * 0.0022);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return WillPopScope(
      onWillPop: () {
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const SubTaskDashBoard();
            },
          ),
        );
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
                  "EDIT MAIN TASK",
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 2,
                ),
                if (taskType == '1')
                  Container(
                    color: const Color(0xffFF0000),
                    width: sizeWidth,
                    height: sizeHeight * 0.05,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        taskTypeName,
                        style: TextStyle(
                            fontSize: textFontNormal, color: Colors.white),
                      ),
                    ),
                  ),
                if (taskType == '2')
                  Container(
                    color: const Color(0xff800000),
                    width: sizeWidth,
                    height: sizeHeight * 0.05,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        taskTypeName,
                        style: TextStyle(
                            fontSize: textFontNormal2, color: Colors.white),
                      ),
                    ),
                  ),
                if (taskType == '3')
                  Container(
                    color: const Color(0xffFFFF00),
                    width: sizeWidth,
                    height: sizeHeight * 0.05,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        taskTypeName,
                        style: TextStyle(
                            fontSize: textFontNormal2, color: Colors.white),
                      ),
                    ),
                  ),
                if (taskType == '4')
                  Container(
                    color: const Color(0xff808000),
                    width: sizeWidth,
                    height: sizeHeight * 0.05,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        taskTypeName,
                        style: TextStyle(
                            fontSize: textFontNormal2, color: Colors.white),
                      ),
                    ),
                  ),
                if (taskType == '5')
                  Container(
                    color: const Color(0xff00FFFF),
                    width: sizeWidth,
                    height: sizeHeight * 0.05,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        taskTypeName,
                        style: TextStyle(
                            fontSize: textFontNormal2, color: Colors.white),
                      ),
                    ),
                  ),
                if (taskType == '6')
                  Container(
                    color: const Color(0xff008080),
                    width: sizeWidth,
                    height: sizeHeight * 0.05,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        taskTypeName,
                        style: TextStyle(
                            fontSize: textFontNormal2, color: Colors.white),
                      ),
                    ),
                  ),
                if (taskType == '7')
                  Container(
                    color: const Color(0xffFF00FF),
                    width: sizeWidth,
                    height: sizeHeight * 0.05,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        taskTypeName,
                        style: TextStyle(
                            fontSize: textFontNormal2, color: Colors.white),
                      ),
                    ),
                  ),
                if (taskType == '8')
                  Container(
                    color: const Color(0xff800080),
                    width: sizeWidth,
                    height: sizeHeight * 0.05,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        taskTypeName,
                        style: TextStyle(
                            fontSize: textFontNormal2, color: Colors.white),
                      ),
                    ),
                  ),
                if (taskType == '9')
                  Container(
                    color: const Color.fromARGB(255, 190, 114, 0),
                    width: sizeWidth,
                    height: sizeHeight * 0.05,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        taskTypeName,
                        style: TextStyle(
                            fontSize: textFontNormal2, color: Colors.white),
                      ),
                    ),
                  ),
                if (taskType == '10')
                  Container(
                    color: const Color.fromARGB(255, 0, 3, 190),
                    width: sizeWidth,
                    height: sizeHeight * 0.05,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        taskTypeName,
                        style: TextStyle(
                            fontSize: textFontNormal2, color: Colors.white),
                      ),
                    ),
                  ),
                if (taskType == '11')
                  Container(
                    color: const Color.fromARGB(255, 14, 168, 0),
                    width: sizeWidth,
                    height: sizeHeight * 0.05,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        taskTypeName,
                        style: TextStyle(
                            fontSize: textFontNormal2, color: Colors.white),
                      ),
                    ),
                  ),
                SizedBox(
                  height: sizeHeight * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SelectableText(
                      "TASK ID : $mainTaskId",
                      style: TextStyle(
                        fontSize: textFontNormal2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'This task create by:',
                      style: TextStyle(
                          color: Colors.black, fontSize: textFontNormal2),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      taskCreateBy,
                      style: TextStyle(
                          color: Colors.black, fontSize: textFontNormal2),
                    ),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Company name:',
                      style: TextStyle(
                          color: Colors.black, fontSize: textFontNormal2),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      company,
                      style: TextStyle(
                          color: Colors.black, fontSize: textFontNormal2),
                    ),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'This source from:',
                      style: TextStyle(
                          color: Colors.black, fontSize: textFontNormal2),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      sourceFrom,
                      style: TextStyle(
                          color: Colors.black, fontSize: textFontNormal2),
                    ),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'This task assign to:',
                      style: TextStyle(
                          color: Colors.black, fontSize: textFontNormal2),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      assign_to,
                      style: TextStyle(
                          color: Colors.black, fontSize: textFontNormal2),
                    ),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Task due date:',
                      style: TextStyle(
                          color: Colors.black, fontSize: textFontNormal2),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      dueDate,
                      style: TextStyle(
                          color: Colors.black, fontSize: textFontNormal2),
                    ),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Task status:',
                      style: TextStyle(
                          color: Colors.black, fontSize: textFontNormal2),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      taskStatusName,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: textFontNormal2,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Document Number:',
                      style: TextStyle(
                          color: Colors.black, fontSize: textFontNormal2),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      documentNumber,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: textFontNormal2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Task create date:',
                      style: TextStyle(
                          color: Colors.black, fontSize: textFontNormal2),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      taskCreateDate,
                      style: TextStyle(
                          color: Colors.black, fontSize: textFontNormal2),
                    ),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Task Title',
                      hintText: 'Task Title',
                      // Here is key idea
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: textFontNormal2),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.01,
                ),
                ListTile(
                  title: Text(
                    'Top Urgent',
                    style: TextStyle(fontSize: textFontNormal2),
                  ),
                  trailing: Radio<menuitem>(
                    activeColor: const Color(0xffff0000),
                    value: menuitem.item1,
                    groupValue: mitem,
                    onChanged: (menuitem value) {
                      setState(() {
                        mitem = value;
                        taskTypePosition = 1;
                        taskTypeString = "Top Urgent";
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'Urgent with in 24 hour',
                    style: TextStyle(fontSize: textFontNormal2),
                  ),
                  minLeadingWidth: 1,
                  trailing: Radio<menuitem>(
                    value: menuitem.item2,
                    activeColor: const Color(0xff800000),
                    groupValue: mitem,
                    onChanged: (menuitem value) {
                      setState(() {
                        mitem = value;
                        taskTypePosition = 2;
                        taskTypeString = "Urgent 24Hr";
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'Error',
                    style: TextStyle(fontSize: textFontNormal2),
                  ),
                  trailing: Radio<menuitem>(
                    activeColor: const Color(0xffFFFF00),
                    value: menuitem.item3,
                    groupValue: mitem,
                    onChanged: (menuitem value) {
                      setState(() {
                        mitem = value;
                        taskTypePosition = 3;
                        taskTypeString = "Error";
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'Remind',
                    style: TextStyle(fontSize: textFontNormal2),
                  ),
                  trailing: Radio<menuitem>(
                    activeColor: const Color(0xff808000),
                    value: menuitem.item4,
                    groupValue: mitem,
                    onChanged: (menuitem value) {
                      setState(() {
                        mitem = value;
                        taskTypePosition = 4;
                        taskTypeString = "Remind";
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'Do it again',
                    style: TextStyle(fontSize: textFontNormal2),
                  ),
                  trailing: Radio<menuitem>(
                    activeColor: const Color(0xff00FFFF),
                    value: menuitem.item5,
                    groupValue: mitem,
                    onChanged: (menuitem value) {
                      setState(() {
                        mitem = value;
                        taskTypePosition = 5;
                        taskTypeString = "Do it again";
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'Correction',
                    style: TextStyle(fontSize: textFontNormal2),
                  ),
                  trailing: Radio<menuitem>(
                    activeColor: const Color(0xff008080),
                    value: menuitem.item6,
                    groupValue: mitem,
                    onChanged: (menuitem value) {
                      setState(() {
                        mitem = value;
                        taskTypePosition = 6;
                        taskTypeString = "Correction";
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'Disappointed',
                    style: TextStyle(fontSize: textFontNormal2),
                  ),
                  trailing: Radio<menuitem>(
                    activeColor: const Color(0xffFF00FF),
                    value: menuitem.item7,
                    groupValue: mitem,
                    onChanged: (menuitem value) {
                      setState(() {
                        mitem = value;
                        taskTypePosition = 7;
                        taskTypeString = "Disappointed";
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'Very Disappointed',
                    style: TextStyle(fontSize: textFontNormal2),
                  ),
                  trailing: Radio<menuitem>(
                    activeColor: const Color(0xff800080),
                    value: menuitem.item8,
                    groupValue: mitem,
                    onChanged: (menuitem value) {
                      setState(() {
                        mitem = value;
                        taskTypePosition = 8;
                        taskTypeString = "V.Disappointed";
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'Regular',
                    style: TextStyle(fontSize: textFontNormal2),
                  ),
                  trailing: Radio<menuitem>(
                    activeColor: const Color.fromARGB(255, 190, 114, 0),
                    value: menuitem.item9,
                    groupValue: mitem,
                    onChanged: (menuitem value) {
                      setState(() {
                        mitem = value;
                        taskTypePosition = 9;
                        taskTypeString = "Regular";
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'Medium',
                    style: TextStyle(fontSize: textFontNormal2),
                  ),
                  trailing: Radio<menuitem>(
                    activeColor: const Color.fromARGB(255, 0, 3, 190),
                    value: menuitem.item10,
                    groupValue: mitem,
                    onChanged: (menuitem value) {
                      setState(() {
                        mitem = value;
                        taskTypePosition = 10;
                        taskTypeString = "Medium";
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'Low',
                    style: TextStyle(fontSize: textFontNormal2),
                  ),
                  trailing: Radio<menuitem>(
                    activeColor: const Color.fromARGB(255, 14, 168, 0),
                    value: menuitem.item11,
                    groupValue: mitem,
                    onChanged: (menuitem value) {
                      setState(() {
                        mitem = value;
                        taskTypePosition = 11;
                        taskTypeString = "Low";
                      });
                    },
                  ),
                ),
                 SizedBox(
                  height: sizeHeight * 0.02,
                ),
                Row(
                  children: [
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
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownvalue1 = newValue;
                                });
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
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownvalue2 = newValue;
                                  assignTo.add(dropdownvalue2);
                                  assignToController.text = assignTo.toString();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                 SizedBox(
                  height: sizeHeight*0.01,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: Center(
                            child: Align(
                              alignment: Alignment.center,
                              child: TextField(
                                focusNode: AlwaysDisabledFocusNode(),
                                controller: assignToController,
                                onTap: () {},
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: 'Assign To',
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      assignToController.text = "";
                                      assignTo.clear();
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                      size: iconSize,
                                    ),
                                  ),
                                ),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: textFontNormal2),
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
                          padding: EdgeInsets.all(padding),
                          child: Center(
                            child: Align(
                              alignment: Alignment.center,
                              child: TextField(
                                focusNode: AlwaysDisabledFocusNode(),
                                  controller:  editDueDateController,
                                onTap: () {
                                  selectDate(context,
                                      editDueDateController);
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: 'Due Date',
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      selectDate(context,
                                          editDueDateController);
                                    },
                                    icon: Icon(
                                      Icons.date_range,
                                      color: Colors.deepPurple,
                                      size: iconSize,
                                    ),
                                  ),
                                ),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: textFontNormal2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: sizeHeight*0.01,
                ),
                Center(
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
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownvalue3 = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: sizeHeight*0.01,
                ),
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Center(
                    child: Align(
                      alignment: Alignment.center,
                      child: TextField(
                        controller: documentNumberController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Document Number',
                        ),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: textFontNormal2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(padding),
                        child: MaterialButton(
                          color: Colors.deepPurple,
                          onPressed: () {
                            titleController.text = "";
                            descriptionController.text = "";
                            // subTitleController.text = "";
                            assignToController.text = "";
                            documentNumberController.text = "";
                            editDueDateController
                                .text = "";
                            assignTo.clear();
                          },
                          child: Text('CLEAR',
                              style: TextStyle(
                                  fontSize: sizeHeight * 0.015,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(padding),
                        child: MaterialButton(
                          color: Colors.deepPurple,
                          onPressed: () {
                            updateTask(
                                context,
                                mainTaskId,
                                sourceFrom,
                                assign_to,
                                company,
                                editDueDateController.text,
                                documentNumberController
                                    .text);
                          },
                          child: Text('UPDATE',
                              style: TextStyle(
                                  fontSize: sizeHeight * 0.015,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
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
