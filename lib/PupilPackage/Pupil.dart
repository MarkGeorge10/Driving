import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'API.dart';
import 'PupilDetailed.dart';

class Pupils extends StatefulWidget {
  @override
  _PupilsState createState() => _PupilsState();
}

class _PupilsState extends State<Pupils> {
  API api = new API();

  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.get("idPref");
    print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: FutureBuilder(
      future: getID(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
              future: api.fetchPupil(
                  "https://drivinginstructorsdiary.com/app/api/viewPupilApi/active?instructor_id=${snapshot.data}"),
              builder: (context, snap) {
                if (snap.hasData) {
                  return ListView.builder(
                      itemCount: snap.data.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) => PupilDetailed(
                                      firstName: snap.data[index]["first_name"],
                                      lastName: snap.data[index]["last_name"],
                                      email: snap.data[index]["email"],
                                      address: snap.data[index]["address"],
                                      phone: snap.data[index]["mobile"],
                                      instructorName: snap.data[index]
                                          ["instructor_name"],
                                      createdAt: snap.data[index]["created_at"],
                                      houseNumbe: snap.data[index]["house_no"],
                                      postalCode: snap.data[index]["postcode"],
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
                                  Text(
                                    snap.data[index]["first_name"] +
                                        " " +
                                        snap.data[index]["last_name"],
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 60,
                                  ),
                                  Text(snap.data[index]["address"]),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 60,
                                  ),
                                  Text(snap.data[index]["mobile"]),
                                ],
                              ),

                              /* trailing: IconButton(
                                      icon: Icon(Icons.update),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdatePupil(snap.data[index]
                                                        ["id"])));
                                      }),*/
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
