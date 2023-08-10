import 'dart:convert';

import 'package:cbs_task/MainDashBoard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'task.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _State();
}

AssetImage assetsImage = const AssetImage('assets/login_logo_small.jpg');
var image = Image(image: assetsImage, fit: BoxFit.fill);

class _State extends State<LoginPage> {
  late SharedPreferences sharedPreferences;
  bool phoneNumberValidation = false;

  double sizeHeight = 0.0;
  double sizeWidth = 0.0;
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sizeHeight = MediaQuery.of(context).size.height;
    sizeWidth = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: sizeHeight,
            width: sizeWidth,
            color: Colors.white10,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: sizeHeight,
                    width: sizeWidth,
                    color: const Color(0xFFf4ece1),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    height: sizeHeight,
                    width: sizeWidth,
                    color: const Color(0xFFf4ece1),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: image,
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    height: sizeHeight,
                    width: sizeWidth,
                    color: const Color(0xFFf4ece1),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: phoneNumberController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'MOBILE NUMBER',
                                hintText: '7X-XXX-XXXX',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.smartphone_sharp,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              onSubmitted: (value) {
                                login(context);
                              },
                            ),
                          ),
                          Container(
                            height: 50,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ElevatedButton(
                              child: const Text('LOG-IN'),
                              onPressed: () {
                     login(context);
                              },
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
        ),
      ),
    );
  }
  Future<bool> login(BuildContext context) async {
    if (phoneNumberController.text.trim().isEmpty) {
      setState(() {
        phoneNumberValidation = true;
        snackBar(context, "Phone number can't be empty", Colors.redAccent);
      });
      return false;
    } else {
      setState(() {
        phoneNumberValidation = false;
      });
    }

    if (phoneNumberController.text.trim().length < 3) {
      setState(() {
        phoneNumberValidation = true;
        snackBar(context, "Invalid number. Number must be above 3 characters",
            Colors.yellow);
      });
      return false;
    } else {
      setState(() {
        phoneNumberValidation = false;
      });
    }

    var url = "http://dev.connect.cbs.lk/login.php";
    var data = {
      "phone": phoneNumberController.text,
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
      Map<String, dynamic> result = jsonDecode(res.body);
        // ignore: avoid_print
        print(result);
      bool status = result['status'];
      if (status) {
        if (result['activate'] == '1') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('login_state', '1');
          prefs.setString('user_name', result['user_name']);
          prefs.setString('first_name', result['first_name']);
          prefs.setString('last_name', result['last_name']);
          prefs.setString('phone', result['phone']);
          prefs.setString('user_role', result['user_role']);
          prefs.setString('activate', result['activate']);

          if (!mounted) return true;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainDashBoard()),
          );

        } else {
          if (!mounted) return false;
          snackBar(context, "Permission denied", Colors.yellow);
        }
      } else {
        if (!mounted) return false;
        snackBar(context, result['message'], Colors.redAccent);
      }
    } else {
      if (!mounted) return false;
      snackBar(context, "Error", Colors.redAccent);
    }
    return true;
  }
}
