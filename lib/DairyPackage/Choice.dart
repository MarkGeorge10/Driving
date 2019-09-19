import 'package:flutter/material.dart';

class Choice extends StatefulWidget {
  @override
  _ChoiceState createState() => _ChoiceState();
}

class _ChoiceState extends State<Choice> {
  var items = [
    {
      "name": "Create Test",
      "Navigator": "/CreateTest",
      "icon": Icons.view_agenda
    },
    {
      "name": "Create Holiday",
      "Navigator": "/CreateHoliday",
      "icon": Icons.card_travel
    },
    {
      "name": "Create Lesson",
      "Navigator": "/CreateLesson",
      "icons": Icons.library_books
    },
    {
      "name": "Create Blocked",
      "Navigator": "/CreateBlocked",
      "icon": Icons.block
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Types"),
      ),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, items[index]["Navigator"]);
              },
              child: Column(
                children: <Widget>[
                  ListTile(
                    // leading: Icon(items[index]["icons"]),
                    title: Center(
                      child: Text(items[index]["name"]),
                    ),
                  ),
                  Divider(
                    color: Colors.green,
                  )
                ],
              ),
            );
          }),
    );
  }
}
