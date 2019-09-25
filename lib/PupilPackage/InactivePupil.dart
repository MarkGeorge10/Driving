import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'API.dart';
import 'PupilDetailed.dart';
import 'UpdatePupil.dart';

class InactivePupil extends StatefulWidget {
  @override
  _InactivePupilState createState() => _InactivePupilState();
}

class _InactivePupilState extends State<InactivePupil> {
  API api = new API();

  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.get("idPref");
    print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Inactive Pupil"),
        ),
        body: FutureBuilder(
          future: getID(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                  future: api.fetchPupil(
                      "https://drivinginstructorsdiary.com/app/api/viewPupilApi/inactive?instructor_id=${snapshot.data}"),
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
                                              phone: snap.data[index]["phone"],
                                              instructorName: snap.data[index]
                                                  ["instructor_name"],
                                              createdAt: snap.data[index]
                                                  ["created_at"],
                                              houseNumbe: snap.data[index]
                                                  ["house_no"],
                                              postalCode: snap.data[index]
                                                  ["postcode"],
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
                                  title: Column(
                                    children: <Widget>[
                                      snap.data[index]["first_name"] == null ||
                                              snap.data[index]["first_name"] ==
                                                  "" ||
                                              snap.data[index]["last_name"] ==
                                                  null ||
                                              snap.data[index]["last_name"] ==
                                                  ""
                                          ? Text(" ")
                                          : Text(
                                              snap.data[index]["first_name"] +
                                                  " " +
                                                  snap.data[index]["last_name"],
                                            ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                60,
                                      ),
                                      snap.data[index]["address"] == null ||
                                              snap.data[index]["address"] == ""
                                          ? Text(" ")
                                          : Text(snap.data[index]["address"]),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                60,
                                      ),
                                      snap.data[index]["mobile"] == null ||
                                              snap.data[index]["mobile"] == ""
                                          ? Text(" ")
                                          : Text(snap.data[index]["mobile"]),
                                    ],
                                  ),
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
