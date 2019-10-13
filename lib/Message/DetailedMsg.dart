import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailedMsg extends StatefulWidget {
  String title, subject, body, msgID;
  DetailedMsg(this.title, this.subject, this.body, this.msgID);
  @override
  _DetailedMsgState createState() => _DetailedMsgState();
}

class _DetailedMsgState extends State<DetailedMsg> {
  TextEditingController _messageController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> replyMsg(String url, {Map body}) async {
    print("mark");
    print(body);

    try {
      return http.post(url, body: body).then((http.Response response) async {
        final String responseBody = response.body;
        String jsondecode = json.decode(responseBody)["result"];
        print(json.decode(responseBody));
        AlertDialog(
          content: Text(jsondecode),
        );
      });
    } catch (ex) {
      print("Something happened errored");
    }
    print("Something happened errored");
    return null;
  }

  Future<void> fetchDetailedMsg(String url, {Map body}) async {
    print("mark");
    print(body);

    try {
      return http.post(url, body: body).then((http.Response response) async {
        final String responseBody = response.body;
        String jsondecode = json.decode(responseBody)["result"];
        print(json.decode(responseBody));
        AlertDialog(
          content: Text(jsondecode),
        );
      });
    } catch (ex) {
      print("Something happened errored");
    }
    print("Something happened errored");
    return null;
  }

  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dat = prefs.get("idPref");

    return dat;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getID(),
      builder: (context, snap) {
        if (snap.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.reply),
                  onPressed: () {
                    _showDialog(snap.data);
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 40,
                        left: MediaQuery.of(context).size.width / 8),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Subject: ",
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20.0),
                        ),
                        Text(
                          widget.subject,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            fontSize: 20.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 35,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 40),
                    child: Text(
                      widget.body,

                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _showDialog(String instructorID) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          //title: new Text("Alert Dialog title"),
          content: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _messageController,
                  maxLines: 7,
                  decoration: InputDecoration(
                    labelText: "Message",
                    hintText: "Message",
                    hintStyle: TextStyle(fontSize: 18),
                  ),
                  validator: (input) {
                    if (input.isEmpty) {
                      return "Receiver Id can't be empty";
                    }
                    return null;
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    if (widget.msgID == instructorID) {
                      AlertDialog(
                        content: Text(
                            "Can not be sent because you are sending to yourself"),
                      );
                      Navigator.of(context).pop();
                    } else {
                      validateForm(
                          "https://drivinginstructorsdiary.com/app/api/insertReplyMessageApi/726/" +
                              "${widget.msgID}" +
                              "?instructor_id=" +
                              "$instructorID");
                    }
                  },
                  child: Text("Reply on"),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Done"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> validateForm(String url) async {
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      await replyMsg(url, body: {
        "message": _messageController.text,
      });

      formState.reset();
    }
  }
}
