import 'package:flutter/material.dart';

class MainPupil extends StatefulWidget {
  @override
  _MainPupilState createState() => _MainPupilState();
}

class _MainPupilState extends State<MainPupil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/ActivePupils');
                  },
                  child: ListTile(
                    // leading: Icon(items[index]["icons"]),
                    leading: Icon(
                      Icons.brightness_1,
                      color: Colors.green,
                    ),
                    title: Center(
                      child: Text("Active Pupil"),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.green,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/InactivePupils');
                  },
                  child: ListTile(
                    // leading: Icon(items[index]["icons"]),
                    leading: Icon(
                      Icons.brightness_1,
                      color: Colors.grey,
                    ),
                    title: Center(
                      child: Text("Inactive Pupil"),
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
