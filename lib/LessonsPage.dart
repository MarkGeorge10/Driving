import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LessonsPage extends StatefulWidget {
  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  final TextEditingController _searchControl = new TextEditingController();

  List<dynamic> lessonItem;

  Future<List<dynamic>> fetchLessons(String url) async {
    //print(body);

    try {
      return http.post(url).then((http.Response response) async {
        final String responseBody = response.body;
        lessonItem = json.decode(responseBody)["bookings"];
        print(lessonItem.length);

        return lessonItem;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("View Booking"),
        ),
        body: FutureBuilder(
            future: fetchLessons(
                "https://drivinginstructorsdiary.com/app/api/viewBookingApi?instructor_id=1054"),
            builder: (context, snap) {
              if (snap.hasData) {
                return ListView.builder(
                    itemCount: snap.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 10.0,
                        child: ListTile(
                          title: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Type:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(snap.data[index]["type"]),
                                ],
                              ),
                              snap.data[index]["type"] == 'lesson'
                                  ? Row(
                                      children: <Widget>[
                                        Text(
                                          "Pupil Name:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(snap.data[index]["pupil_text"]),
                                      ],
                                    )
                                  : SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              40,
                                    ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Start:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(snap.data[index]["start_datetime"]),
                                ],
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 40,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "End:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(snap.data[index]["end_datetime"]),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Text(
                                "Memo: ",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(snap.data[index]["memo"] == null
                                  ? "No memo added"
                                  : snap.data[index]["memo"]),
                            ],
                          ),
                          //subtitle: Text("Email"),
                        ),
                      );
                    });
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
