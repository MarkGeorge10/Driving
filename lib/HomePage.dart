import 'package:driving_instructor/PupilPackage/Pupil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DairyPackage/Calender page.dart';
import 'LessonsPage.dart';
import 'Message/MessagesPage.dart';
import 'ProgressReport.dart';
import 'RegistrationForm/LoginPage.dart';
import 'TransactionPackage/TransactionPage.dart';

class HomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  PageController _pageController;
  int _page = 0;

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        ModalRoute.withName('/Categories'));
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  // ignore: non_constant_identifier_names, missing_return

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          MessagePage(),
          CalenderPage(),
          Pupils(),
          LessonsPage(),
          TransactionPage(),
          ReportPage()
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 7),
            IconButton(
              icon: Icon(
                Icons.message,
                size: 24.0,
              ),
              color: _page == 0 ? Colors.white : Colors.white,
              onPressed: () => _pageController.jumpToPage(0),
            ),
            IconButton(
              icon: Icon(
                Icons.calendar_today,
                size: 24.0,
              ),
              color: _page == 1 ? Colors.white : Colors.white,
              onPressed: () => _pageController.jumpToPage(1),
            ),
            IconButton(
              icon: Icon(
                Icons.account_box,
                size: 24.0,
              ),
              color: _page == 2 ? Colors.white : Colors.white,
              onPressed: () => _pageController.jumpToPage(2),
            ),
            IconButton(
              icon: Icon(
                Icons.drive_eta,
                size: 24.0,
              ),
              color: _page == 3 ? Colors.white : Colors.white,
              onPressed: () => _pageController.jumpToPage(3),
            ),
            IconButton(
              icon: Icon(
                Icons.call_to_action,
                size: 24.0,
              ),
              color: _page == 4 ? Colors.white : Colors.white,
              onPressed: () => _pageController.jumpToPage(4),
            ),
            IconButton(
              icon: Icon(
                Icons.assessment,
                size: 24.0,
              ),
              color: _page == 5 ? Colors.white : Colors.white,
              onPressed: () => _pageController.jumpToPage(5),
            ),
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                size: 24.0,
              ),
              color: _page == 6 ? Colors.white : Colors.white,
              onPressed: () {
                logout();
              },
            ),
            SizedBox(width: 7),
          ],
        ),
        color: Theme.of(context).primaryColor,
        shape: CircularNotchedRectangle(),
      ),
    );
  }
}
