import 'package:cbs_task/Login.dart';
import 'package:cbs_task/MainDashBoard.dart';
import 'package:cbs_task/Scanner.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(LandingPage(prefs: prefs));
}

class LandingPage extends StatelessWidget {
  final SharedPreferences prefs;
  const LandingPage({Key key, this.prefs}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _decideMainPage(),
    );
  }

  _decideMainPage() {
    if (prefs.getString('login_state') != null) {
      return const MainDashBoard();
    } else {
      return const LoginPage();
    }
  }


}
