import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'DetailedMsg.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<dynamic> msgItem;

  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dat = prefs.get("idPref");

    return dat;
  }

  Future<List<dynamic>> fetchMsg(String url) async {
    print(url);

    try {
      return http.post(url).then((http.Response response) async {
        final String responseBody = response.body;
        msgItem = json.decode(responseBody)["data"]["data"];
        print(msgItem.length);

        return msgItem;
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
        title: Text("Message Page"),
      ),
      body: FutureBuilder(
          future: getID(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                  future: fetchMsg(
                      "https://drivinginstructorsdiary.com/app/api/viewMessageApi?instructor_id=" +
                          "${snapshot.data}"),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      return ListView.builder(
                          itemCount: snap.data.length,
                          itemBuilder: (context, position) {
                            //MailContent mailContent = MailGenerator.getMailContent(position);
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => DetailedMsg(
                                            snap.data[position]
                                                ["receiver_sender_name"],
                                            snap.data[position]["subject"],
                                            snap.data[position]["message"])));
                              },
                              child: Column(children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 14.0,
                                      right: 14.0,
                                      top: 5.0,
                                      bottom: 5.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.account_circle,
                                        size: 55.0,
                                        color: Colors.red,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    snap.data[position][
                                                                "receiver_sender_name"] ==
                                                            ""
                                                        ? "Sender Name"
                                                        : msgItem[position][
                                                            "receiver_sender_name"],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black87,
                                                        fontSize: 17.0),
                                                  ),
                                                  Text(
                                                    "",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black54,
                                                        fontSize: 13.5),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        snap.data[position]
                                                            ["subject"],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 15.5),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                              ]),
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
          }),
    );
  }
}
