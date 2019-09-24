import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LessonsPage extends StatefulWidget {
  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dat = prefs.get("idPref");

    return dat;
  }

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
            future: getID(),
            builder: (context, snapshot) {
              return FutureBuilder(
                  future: fetchLessons(
                      "https://drivinginstructorsdiary.com/app/api/viewBookingApi?instructor_id=" +
                          "${snapshot.data}"),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      return ListView.builder(
                          itemCount: snap.data.length,
                          itemBuilder: (context, index) {
                            String startDate = snap.data[index]
                                    ["start_datetime"]
                                .replaceAll(new RegExp(r'-'), '/');

                            String endDate = snap.data[index]["end_datetime"]
                                .replaceAll(new RegExp(r'-'), '/');

                            List<String> startList = startDate.split('/');
                            List<String> endList = endDate.split('/');
                            return Card(
                              elevation: 10.0,
                              child: ListTile(
                                title: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Type:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
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
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(snap.data[index]
                                                  ["pupil_text"]),
                                            ],
                                          )
                                        : SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                40,
                                          ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Start:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(startList[2].substring(0, 2) +
                                                '/' +
                                                startList[1] +
                                                '/' +
                                                startList[0]
                                            //startDate.substring(0, 9),
                                            ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              40,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "End:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(endList[2].substring(0, 2) +
                                            '/' +
                                            endList[1] +
                                            '/' +
                                            endList[0]),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              40,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Row(
                                  children: <Widget>[
                                    Text(
                                      "Memo: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
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
                  });
            }));
  }
}
