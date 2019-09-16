import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddMessage extends StatefulWidget {
  @override
  _AddMessageState createState() => _AddMessageState();
}

class _AddMessageState extends State<AddMessage> {
  TextEditingController _receiverIdController = new TextEditingController();

  TextEditingController _subjectController = new TextEditingController();
  TextEditingController _messageController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> createMsg(String url, {Map body}) async {
    print("mark");
    print(body);

    try {
      return http.post(url, body: body).then((http.Response response) async {
        final String responseBody = response.body;
        String jsondecode = json.decode(responseBody)["result"];
        print(json.decode(responseBody));
        _showDialog(jsondecode);
      });
    } catch (ex) {
      _showDialog("Something happened errored");
    }
    _showDialog("Something happened errored");
    return null;
  }

  void _showDialog(String str) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          //title: new Text("Alert Dialog title"),
          content: new Text(str),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Add New Message"),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.send,
                    ),
                    onPressed: () {
                      validateForm(
                          "https://drivinginstructorsdiary.com/app/api/insertMessageApi?instructor_id=" +
                              "${snapshot.data}");
                    })
              ],
            ),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _receiverIdController,
                      decoration: InputDecoration(
                        hintText: "Receiver ID",
                        hintStyle: TextStyle(fontSize: 18),
                      ),
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Receiver Id can't be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    TextFormField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        labelText: "Subject",
                        hintText: "Subject",
                        hintStyle: TextStyle(fontSize: 18),
                      ),
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Receiver Id can't be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
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
                  ],
                ),
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

  Future<void> validateForm(String url) async {
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      await createMsg(url, body: {
        "recipient": _receiverIdController.text,
        "subject": _subjectController.text,
        "message": _messageController.text,
      });

      formState.reset();
    }
  }
}
