import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateBlocked extends StatefulWidget {
  @override
  _CreateBlockedState createState() => _CreateBlockedState();
}

class _CreateBlockedState extends State<CreateBlocked> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _dateController = new TextEditingController();
  TextEditingController _durationDaysController = new TextEditingController();
  TextEditingController _reasonController = new TextEditingController();
  TextEditingController _startController = new TextEditingController();

  Future<void> createBlocked(String url, {Map body}) async {
    print("mark");
    print(url);

    try {
      return http.post(url, body: body).then((http.Response response) async {
        final String responseBody = response.body;
        String jsondecode = json.decode(responseBody)["result"];
        print(jsondecode);
        _showDialog(jsondecode);
      });
    } catch (ex) {
      _showDialog("Something happened errored");
    }
    _showDialog("Something happened errored");
    return null;
  }

  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dat = prefs.get("idPref");

    return dat;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Blocked"),
      ),
      body: FutureBuilder(
          future: getID(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 40,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            labelText: "Date",
                            hintText: "1/2/2019",
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          controller: _dateController,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Date field should not be empty";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 40,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Duration Days",
                            hintText: "Duration Days",
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          controller: _durationDaysController,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Duration Days field should not be empty";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 40,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Reason",
                            hintText: "Reason",
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          controller: _reasonController,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Reason field should not be empty";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 40,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "start",
                            hintText: "start",
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          controller: _startController,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "start field should not be empty";
                            }
                            return null;
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: FlatButton(
                            onPressed: () {
                              // TODO: implement validate function

                              validateForm(
                                  "https://drivinginstructorsdiary.com/app/api/createBlockedApi?instructor_id=" +
                                      "${snapshot.data}");
                            },
                            child: Text(
                              "Create Blocked",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            shape: StadiumBorder(),
                            color: Colors.green,
                            splashColor: Colors.indigo,
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width / 8,
                                15,
                                MediaQuery.of(context).size.width / 8,
                                15),
                          ),
                        )
                      ],
                    )),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Future<void> validateForm(String url) async {
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      await createBlocked(url, body: {
        "date": _dateController.text,
        "durationDays": _durationDaysController.text,
        "reason": _reasonController.text,
        "available": "false",
        "start": _startController.text,
      });
      formState.reset();
    }
  }
}
