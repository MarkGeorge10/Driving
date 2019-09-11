import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RegistrationForm/LoginPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var dashboard = [
    /*{
      "icon": Icons.check_box,
      "footer": "View All Booking",
      "color": Colors.orange,

      "Stat": "17",
      "Stat_Comment": "All Bookings !"
    },*/
    {
      "icon": Icons.calendar_today,
      "footer": "View Diary",
      "navigation": '/CalenderPage',
      "color": Colors.green,
      "Stat": "17",
      "Stat_Comment": "Today's Lessons!"
    },
    {
      "icon": Icons.markunread,
      "footer": "View All Messages",
      "navigation": '/MessagePage',
      "color": Colors.redAccent,
      "Stat": "17",
      "Stat_Comment": "Unread Messages!"
    },
    {
      "icon": Icons.person,
      "footer": "View All Pupils",
      "navigation": '/Pupils',
      "color": Colors.blue,
      "Stat": "17",
      "Stat_Comment": "Pupils !"
    },
    {
      "icon": Icons.directions_car,
      "footer": "View All Lessons ",
      "navigation": '/LessonsPage',
      "color": Colors.orange,
      "Stat": "17",
      "Stat_Comment": "Lessons !"
    }
  ];

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        ModalRoute.withName('/Categories'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
        ),
        drawer: buildDrawer(),
        body: ListView.builder(
            itemCount: dashboard.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, dashboard[index]['navigation']);
                },
                child: Card(
                    elevation: 10.0,
                    color: Colors.white,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      child: GridTile(
                        child: Container(
                          color: dashboard[index]['color'],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Center(
                                    child: Icon(
                                      dashboard[index]['icon'],
                                      color: Colors.white,
                                      size: 80.0,
                                    ),
                                  ),
                                ),
                                flex: 6,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        child: Text(
                                      "",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                    Container(
                                      child: Text(
                                        dashboard[index]['Stat_Comment'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                flex: 6,
                              )
                            ],
                          ),
                        ),
                        footer: Container(
                          height: MediaQuery.of(context).size.height / 20,
                          color: Colors.grey[400],
                          child: Center(
                              child: Text(
                            dashboard[index]["footer"],
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    )),
              );
            }));
  }

  Widget buildDrawer() {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("User Name"),
            accountEmail: Text("Email Address"),
            currentAccountPicture: GestureDetector(),
            decoration: new BoxDecoration(color: Colors.orangeAccent),
          ),

          //body of the drawer
          InkWell(
            onTap: () {
              // Navigator.pushNamed(context, '/Categories');
            },
            child: ListTile(
              title: Text("Home Page"),
              leading: Icon(Icons.home, color: Colors.orangeAccent),
            ),
          ),

          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/MessagePage');
            },
            child: ListTile(
              title: Text("Messages"),
              leading: Icon(Icons.message, color: Colors.orangeAccent),
            ),
          ),

          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/LessonsPage');
            },
            child: ListTile(
              title: Text("Lessons"),
              leading: Icon(
                Icons.directions_car,
                color: Colors.orangeAccent,
              ),
            ),
          ),

          /* ExpansionTile(
            title: Text("Lessons"),
            leading: Icon(
              Icons.directions_car,
              color: Colors.orangeAccent,
            ),
            children: <Widget>[
              InkWell(
                child: ListTile(
                  title: Text("Add Lessons"),
                  leading: Icon(Icons.add, color: Colors.orangeAccent),
                ),
              ),
              InkWell(
                child: ListTile(
                  title: Text("View Lessons"),
                  leading: Icon(Icons.view_agenda, color: Colors.orangeAccent),
                ),
              ),
              InkWell(
                child: ListTile(
                  title: Text("Update Lessons"),
                  leading: Icon(Icons.update, color: Colors.orangeAccent),
                ),
              )
            ],
          ),*/

          InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/Pupils");
            },
            child: ListTile(
              title: new Text("Pupils"),
              leading: Icon(
                Icons.account_box,
                color: Colors.orangeAccent,
              ),
            ),
          ),

          /*new ExpansionTile(
            title: new Text("Pupils"),
            leading: Icon(
              Icons.account_box,
              color: Colors.orangeAccent,
            ),
            children: <Widget>[
              InkWell(
                child: ListTile(
                  title: Text("Add Pupils"),
                  leading: Icon(Icons.add, color: Colors.orangeAccent),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/Pupils");
                },
                child: ListTile(
                  title: Text("View Pupils"),
                  leading: Icon(Icons.view_agenda, color: Colors.orangeAccent),
                ),
              ),
              InkWell(
                child: ListTile(
                  title: Text("Update Pupils"),
                  leading: Icon(Icons.update, color: Colors.orangeAccent),
                ),
              )
            ],
          ),*/

          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/CalenderPage');
            },
            child: ListTile(
              title: Text("Dairy"),
              leading: Icon(Icons.library_books, color: Colors.orangeAccent),
            ),
          ),

          InkWell(
            onTap: () {
              logout();
            },
            child: ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.exit_to_app, color: Colors.orangeAccent),
            ),
          ),
        ],
      ),
    );
  }
}
