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
        lessonItem = json.decode(responseBody)["results"];
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
          title: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: TextField(
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: "Search..",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                suffixIcon: Icon(
                  Icons.filter_list,
                  color: Colors.black,
                ),
                hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
              maxLines: 1,
              controller: _searchControl,
            ),
          ),
        ),
        body: FutureBuilder(
            future: fetchLessons(
                "https://drivinginstructorsdiary.com/app/api/getLessonTypeApi?pageLimit=100"),
            builder: (context, snap) {
              if (snap.hasData) {
                return ListView.builder(
                    itemCount: snap.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 10.0,
                        child: ListTile(
                          leading: Container(
                            child: Icon(
                              Icons.drive_eta,
                              color: Colors.green,
                              size: 50.0,
                            ),
                          ),
                          title: Text(snap.data[index]["text"]),
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
