import 'dart:convert';

import 'package:cbs_task/MainDashBoard.dart';
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

class CreateMainTask extends StatefulWidget {
  const CreateMainTask({Key key}) : super(key: key);

  @override
  CreateMainTaskState createState() => CreateMainTaskState();
}

class CreateMainTaskState extends State<CreateMainTask> {
  bool titleValidation = false;
  bool subTaskTitleValidation = false;
  bool descriptionValidation = false;
  int taskType = 1;
  String taskTypeString = "Top Urgent";
  // ignore: unused_field
  menuitem _mitem = menuitem.item1;
  String userName;
  String firstName;
  String lastName;
  List<String> assignTo = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController createTaskDueDateController = TextEditingController();
  TextEditingController documentNumberController = TextEditingController();
  TextEditingController assignToController = TextEditingController();

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
    });
  }

  Future<bool> mainTask(BuildContext context) async {
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
    var stringMonth = DateFormat('MM/yyyy').format(dt);
    var taskId = "$userName#MT$taskTimeStamp";
    var url = "http://dev.connect.cbs.lk/mainTask.php";
    var data = {
      "task_id": taskId,
      "task_title": titleController.text,
      "task_type": "$taskType",
      "task_type_name": taskTypeString,
      "due_date": createTaskDueDateController.text,
      "task_create_by_id": userName,
      "task_create_by": "$firstName $lastName",
      "task_create_date": stringDate,
      "task_create_month": stringMonth,
      "task_created_timestamp": '$timeSt',
      "task_status": "0",
      "task_status_name": "Pending",
      "task_reopen_by": "",
      "task_reopen_by_id": "",
      "task_reopen_date": "",
      "task_reopen_timestamp": "0",
      "task_finished_by": "",
      "task_finished_by_id": "",
      "task_finished_by_date": "",
      "task_finished_by_timestamp": "0",
      "task_edit_by": "",
      "task_edit_by_id": "",
      "task_edit_by_date": "",
      "task_edit_by_timestamp": "0",
      "task_delete_by": "",
      "task_delete_by_id": "",
      "task_delete_by_date": "",
      "task_delete_by_timestamp": "0",
      "source_from": dropdownvalue1,
      "assign_to": assignToController.text,
      "company": dropdownvalue3,
      "document_number": documentNumberController.text,
      "action_taken_by_id": "",
      "action_taken_by": "",
      "action_taken_date": "",
      "action_taken_timestamp": "0"
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
        createTask(context, taskId);
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

  Future<bool> createTask(BuildContext context, var mainTaskId) async {
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

    if (subTitleController.text.trim().isEmpty) {
      setState(() {
        subTaskTitleValidation = true;
        snackBar(context, "Sub task title can't be empty", Colors.redAccent);
      });
      return false;
    } else {
      setState(() {
        subTaskTitleValidation = false;
      });
    }

    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int taskTimeStamp = timestamp;
    var timeSt = taskTimeStamp;
    var dt = DateTime.fromMillisecondsSinceEpoch(taskTimeStamp);
    var stringDate = DateFormat('MM/dd/yyyy').format(dt);
    var stringMonth = DateFormat('MM/yyyy').format(dt);
    var taskId = "$userName#ST$taskTimeStamp";
    var url = "http://dev.connect.cbs.lk/createTask.php";

    var data = {
      "task_id": taskId,
      "main_task_id": "$mainTaskId",
      "task_title": subTitleController.text,
      "task_type": "$taskType",
      "task_type_name": taskTypeString,
      "due_date": createTaskDueDateController.text,
      "task_description": descriptionController.text,
      "task_create_by_id": userName,
      "task_create_by": "$firstName $lastName",
      "task_create_date": stringDate,
      "task_create_month": stringMonth,
      "task_created_timestamp": '$timeSt',
      "task_status": "0",
      "task_status_name": "Pending",
      "action_taken_by_id": "",
      "action_taken_by": "",
      "action_taken_date": "",
      "action_taken_timestamp": "0",
      "task_reopen_by": "",
      "task_reopen_by_id": "",
      "task_reopen_date": "",
      "task_reopen_timestamp": "0",
      "task_finished_by": "",
      "task_finished_by_id": "",
      "task_finished_by_date": "",
      "task_finished_by_timestamp": "0",
      "task_edit_by": "",
      "task_edit_by_id": "",
      "task_edit_by_date": "",
      "task_edit_by_timestamp": "0",
      "task_delete_by": "",
      "task_delete_by_id": "",
      "task_delete_by_date": "",
      "task_delete_by_timestamp": "0",
      "source_from": dropdownvalue1,
      "assign_to": assignToController.text,
      "company": dropdownvalue3
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
        snackBar(context, "Done", Colors.green);
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

    double textFontNormal = (sizeHeight * 0.008) * (sizeWidth * 0.008);
    double textFontLarge = (sizeHeight * 0.025) * (sizeWidth * 0.002);
    double paddingButton = (sizeHeight * 0.004) * (sizeWidth * 0.0008);
    double padding = (sizeHeight * 0.012) * (sizeWidth * 0.0012);
    double iconSize = (sizeHeight * 0.008) * (sizeWidth * 0.008);
    double textFontNormal2 = (sizeHeight * 0.022) * (sizeWidth * 0.0022);

    double paddingCard = (sizeHeight * 0.0005) * (sizeWidth * 0.0004);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return AnnotatedRegion<SystemUiOverlayStyle>(
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
                "CREATE MAIN TASK",
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
                      fontWeight: FontWeight.bold, fontSize: textFontLarge),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Padding(
                padding: EdgeInsets.all(padding),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: subTitleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Sub Task Title',
                      hintText: 'Sub Task Title',
                      // Here is key idea
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: textFontLarge),
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Padding(
                padding: EdgeInsets.all(padding),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      hintText: 'Description',
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: textFontLarge),
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              ListTile(
                title: Text(
                  'Top Urgent',
                  style: TextStyle(fontSize: textFontNormal2),
                ),
                trailing: Radio<menuitem>(
                  activeColor: const Color(0xffff0000),
                  value: menuitem.item1,
                  groupValue: _mitem,
                  onChanged: (menuitem value) {
                    setState(() {
                      _mitem = value;
                      taskType = 1;
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
                  groupValue: _mitem,
                  onChanged: (menuitem value) {
                    setState(() {
                      _mitem = value;
                      taskType = 2;
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
                  groupValue: _mitem,
                  onChanged: (menuitem value) {
                    setState(() {
                      _mitem = value;
                      taskType = 3;
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
                  groupValue: _mitem,
                  onChanged: (menuitem value) {
                    setState(() {
                      _mitem = value;
                      taskType = 4;
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
                  groupValue: _mitem,
                  onChanged: (menuitem value) {
                    setState(() {
                      _mitem = value;
                      taskType = 5;
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
                  groupValue: _mitem,
                  onChanged: (menuitem value) {
                    setState(() {
                      _mitem = value;
                      taskType = 6;
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
                  groupValue: _mitem,
                  onChanged: (menuitem value) {
                    setState(() {
                      _mitem = value;
                      taskType = 7;
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
                  groupValue: _mitem,
                  onChanged: (menuitem value) {
                    setState(() {
                      _mitem = value;
                      taskType = 8;
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
                  groupValue: _mitem,
                  onChanged: (menuitem value) {
                    setState(() {
                      _mitem = value;
                      taskType = 9;
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
                  groupValue: _mitem,
                  onChanged: (menuitem value) {
                    setState(() {
                      _mitem = value;
                      taskType = 10;
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
                  groupValue: _mitem,
                  onChanged: (menuitem value) {
                    setState(() {
                      _mitem = value;
                      taskType = 11;
                      taskTypeString = "Low";
                    });
                  },
                ),
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
                                assignTo.add(
                                    dropdownvalue2);
                                assignToController
                                    .text =
                                    assignTo.toString();
                              });
                            },
                          ),
                        ),
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
                        child: Center(
                          child: Align(
                            alignment: Alignment.center,
                            child: TextField(
                              focusNode:
                              AlwaysDisabledFocusNode(),
                              controller:
                              assignToController,
                              onTap: () {

                              },

                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Assign To',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    assignToController
                                        .text = "";
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
                                  fontSize: textFontLarge),
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
                              focusNode:
                               AlwaysDisabledFocusNode(),
                              controller:  createTaskDueDateController,
                              onTap: () {
                                selectDate(context,
                                    createTaskDueDateController);
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Due Date',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    selectDate(context,
                                        createTaskDueDateController);
                                  },
                                  icon: Icon(
                                    Icons.date_range,
                                    color: Colors.blue,
                                    size: iconSize,
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: textFontLarge),
                            ),
                          ),
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
                                color: Colors.black, fontSize: textFontNormal2),
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
              const SizedBox(
                height: 2,
              ),
              Padding(
                padding:
                EdgeInsets.all(padding),
                child: Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: TextField(
                      controller:documentNumberController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:
                        'Document Number',
                      ),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: textFontLarge),
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
                          subTitleController.text = "";
                          assignToController.text = "";
                          documentNumberController.text =
                          "";
                          createTaskDueDateController
                              .text = "";
                          assignTo.clear();
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
                  Expanded(
                    flex: 1,
                    child:  Padding(
                      padding: EdgeInsets.all(padding),
                      child: MaterialButton(
                        color: Colors.deepPurple,
                        onPressed: () {
                          mainTask(context);
                        },
                        child: Text('SUBMIT',
                            style: TextStyle(
                                fontSize:
                                sizeHeight * 0.015,
                                fontWeight:
                                FontWeight.w500,
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
    );
  }
}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}