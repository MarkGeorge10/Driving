import 'package:driving_instructor/DairyPackage/Calender page.dart';
import 'package:driving_instructor/PupilPackage/Pupil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DairyPackage/Choice.dart';
import 'DairyPackage/CreateBlocked.dart';
import 'DairyPackage/CreateHoliday.dart';
import 'DairyPackage/CreateLesson.dart';
import 'DairyPackage/CreateTest.dart';
import 'HomePage.dart';
import 'LessonsPage.dart';
import 'Message/AddMessage.dart';
import 'Message/MessagesPage.dart';
import 'PupilPackage/InactivePupil.dart';
import 'RegistrationForm/LoginPage.dart';
import 'TransactionPackage/AddTransaction.dart';

void main() => runApp(MyAPP());

class MyAPP extends StatefulWidget {
  @override
  _MyAPPState createState() => _MyAPPState();
}

class _MyAPPState extends State<MyAPP> {
  Future<String> data;
  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dat = prefs.get("emailPref");
    print(dat);
    return dat;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = getEmail();

    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FutureBuilder(
        future: getEmail(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          }
          return LoginPage();
        },
      ),
      routes: {
        '/Pupils': (context) => Pupils(),
        '/MessagePage': (context) => MessagePage(),
        '/LessonsPage': (context) => LessonsPage(),
        '/CalenderPage': (context) => CalenderPage(),
        '/LoginPage': (context) => LoginPage(),
        '/AddTransaction': (context) => AddTransaction(),
        '/AddMessage': (context) => AddMessage(),
        '/Choice': (context) => Choice(),
        '/CreateHoliday': (context) => CreateHoliday(),
        '/CreateBlocked': (context) => CreateBlocked(),
        '/CreateLesson': (context) => CreateLesson(),
        '/CreateTest': (context) => CreateTest(),
        '/ActivePupils': (context) => Pupils(),
        '/InactivePupils': (context) => InactivePupil(),
      },
    );
  }
}
