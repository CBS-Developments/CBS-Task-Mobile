import 'dart:convert';

import 'package:cbs_task/SubTaskDashBoard.dart';
import 'package:cbs_task/ViewSubTask.dart';
import 'package:cbs_task/task.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'dart:io';

class SubTaskComments extends StatefulWidget {
  const SubTaskComments({Key key}) : super(key: key);

  @override
  State<SubTaskComments> createState() => _SubTaskCommentsState();
}

class _SubTaskCommentsState extends State<SubTaskComments> {
  String userName;
  String firstName;
  String lastName;
  String userRole;
  String taskId;
  String taskTitle;

  TextEditingController commentEditingController = TextEditingController();

  Future<List<comment>> getCommentList(var taskId) async {
    var data = {
      "task_id": "$taskId",
    };

    const url = "http://dev.connect.cbs.lk/commentListById.php";
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
      if (jsonDecode(res.body) != "Error") {
        List jsonResponse = json.decode(res.body);
        if (jsonResponse != null) {
          return jsonResponse.map((sec) => comment.fromJson(sec)).toList();
        }
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load jobs from API');
    }
    return null;
  }
  Future<bool> createComment(BuildContext context) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int taskTimeStamp = timestamp;
    var timeSt = taskTimeStamp;

    var dt = DateTime.fromMillisecondsSinceEpoch(taskTimeStamp);

    var stringDate = DateFormat('MM/dd/yyyy, hh:mm a').format(dt);

    var url = "http://dev.connect.cbs.lk/createComment.php";
    var data = {
      "comment_id": "$timeSt",
      "task_id": taskId,
      "comment": commentEditingController.text,
      "comment_create_by_id": userName,
      "comment_create_by": "$firstName $lastName",
      "comment_create_date": stringDate,
      "comment_created_timestamp": "$timeSt",
      "comment_status": "1",
      "comment_edit_by": "",
      "comment_edit_by_id": '',
      "comment_edit_by_date": "",
      "comment_edit_by_timestamp": "",
      "comment_delete_by": "",
      "comment_delete_by_id": "",
      "comment_delete_by_date": "",
      "comment_delete_by_timestamp": "",
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
        commentEditingController.text = "";

        setState(() {
          getCommentList(taskId);
        });
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
  Future<List<comment>> getMainTaskCommentList(var taskId) async {
    var data = {
      "task_id": "$taskId",
    };

    const url = "http://dev.connect.cbs.lk/commentListById.php";
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
      if (jsonDecode(res.body) != "Error") {
        List jsonResponse = json.decode(res.body);
        if (jsonResponse != null) {
          return jsonResponse.map((sec) => comment.fromJson(sec)).toList();
        }
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load jobs from API');
    }
    return null;
  }

  Future<void> deleteComment(
      var commentId, var commentStatus, var userName, var name) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int taskTimeStamp = timestamp;
    var timeSt = taskTimeStamp;

    var dt = DateTime.fromMillisecondsSinceEpoch(taskTimeStamp);

    var stringDate = DateFormat('MM/dd/yyyy, hh:mm a').format(dt);
    String url;

    url = "http://dev.connect.cbs.lk/deleteComment.php";
    var data = {
      "comment_id": "$commentId",
      "comment_delete_by": "$userName",
      "comment_delete_by_id": "$name",
      "action_taken_by": "$name",
      "comment_delete_by_date": stringDate,
      "comment_delete_by_timestamp": "$timeSt",
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
        setState(() {
          getCommentList(taskId);
        });
        if (!mounted) return false;
        snackBar(context, "Delete", Colors.redAccent);
      }
    } else {
      if (!mounted) return false;
      snackBar(context, "Error", Colors.redAccent);
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    retrieverData();
  }

  void retrieverData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      taskId = (prefs.getString('task_id') ?? '');
      taskTitle = (prefs.getString('task_title') ?? '');
      userName = (prefs.getString('user_name') ?? '');
      userRole = (prefs.getString('user_role') ?? '');
      firstName = (prefs.getString('first_name') ?? '').toUpperCase();
      lastName = (prefs.getString('last_name') ?? '').toUpperCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    double textFontLarge = (sizeHeight * 0.028) * (sizeWidth * 0.002);
    double paddingButton = (sizeHeight * 0.004) * (sizeWidth * 0.0008);
    double padding = (sizeHeight * 0.012) * (sizeWidth * 0.0012);
    double iconSize = (sizeHeight * 0.008) * (sizeWidth * 0.008);
    double textFontNormal = (sizeHeight * 0.022) * (sizeWidth * 0.0022);
    double textFontSmall = (sizeHeight * 0.006) * (sizeWidth * 0.006);
    double paddingCard = (sizeHeight * 0.0005) * (sizeWidth * 0.0004);
    return WillPopScope(
      onWillPop: () async => null,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                taskTitle,
                style: const TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              const Text(
                "Comments",
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
                    return const ViewSubTask();
                  },
                ),
              );
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 8,
              child: Container(
                color: Colors.white,
                height: sizeHeight,
                width: sizeWidth,
                child: FutureBuilder<List<comment>>(
                    future: getCommentList(taskId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<comment> data = snapshot.data;
                        return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                    title: SelectableText(
                                      data[index].commnt,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: textFontNormal),
                                    ),
                                    subtitle: Text(
                                      "${data[index].commentCreateDate}      ${data[index].commentCreateBy}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: textFontSmall,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        size: iconSize,
                                        color: Colors.red,
                                      ),
                                      // highlightColor: Colors.pink,
                                      onPressed: () {
                                        if (data[index].commentCreateById ==
                                            userName) {
                                          deleteComment(
                                              data[index].commentId,
                                              "0",
                                              userName,
                                              "$firstName $lastName");
                                        } else {
                                          snackBar(
                                              context,
                                              "You can't delete this comment",
                                              Colors.red);
                                        }
                                      },
                                    ),
                                  ));
                            });
                      } else if (snapshot.hasError) {
                        return const Text("-Empty-");
                      }
                      return const Text("Loading...");
                    }),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                  height: sizeHeight,
                  width: sizeWidth,
                  color: Colors.grey[50],
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      controller: commentEditingController,
                      textInputAction: TextInputAction.newline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration.collapsed(
                          hintText: 'Comments..'),
                    ),
                  )),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: sizeHeight,
                width: sizeWidth,
                color: Colors.grey[400],
                child: MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    createComment( context);
                  },
                  child: Text('SEND',
                      style: TextStyle(
                          fontSize: textFontNormal,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
