import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'PupilDetailed.dart';
import 'UpdatePupil.dart';

class Pupils extends StatefulWidget {
  @override
  _PupilsState createState() => _PupilsState();
}

class _PupilsState extends State<Pupils> {
  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.get("idPref");
    print(data);
    return data;
  }

  List<dynamic> pupilItem;

  Future<List<dynamic>> fetchMsg(String url) async {
    //print(body);

    try {
      return http.post(url).then((http.Response response) async {
        final String responseBody = response.body;
        pupilItem = json.decode(responseBody)["data"]["data"];
        print(pupilItem.length);

        return pupilItem;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  final TextEditingController _searchControl = new TextEditingController();
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
          future: getID(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                  future: fetchMsg(
                      "https://drivinginstructorsdiary.com/app/api/viewPupilApi/active?instructor_id=${snapshot.data}"),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      return ListView.builder(
                          itemCount: snap.data.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(new MaterialPageRoute(
                                        builder: (context) => PupilDetailed(
                                              firstName: snap.data[index]
                                                  ["first_name"],
                                              lastName: snap.data[index]
                                                  ["last_name"],
                                              email: snap.data[index]["email"],
                                              address: snap.data[index]
                                                  ["address"],
                                              phone: snap.data[index]["mobile"],
                                              company: snap.data[index]
                                                  ["company"],
                                              instructorName: snap.data[index]
                                                  ["instructor_name"],
                                              createdAt: snap.data[index]
                                                  ["created_at"],
                                              id: snap.data[index]["id"],
                                            )));
                              },
                              child: Card(
                                elevation: 10.0,
                                child: ListTile(
                                  leading: Container(
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 50.0,
                                    ),
                                  ),
                                  title: Text(snap.data[index]["username"]),
                                  subtitle: Text(snap.data[index]["mobile"]),
                                  trailing: IconButton(
                                      icon: Icon(Icons.update),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdatePupil(snap.data[index]
                                                        ["id"])));
                                      }),
                                ),
                              ),
                            );
                          });
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  });
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
