import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
    print(body);

    try {
      return http.post(url, body: body).then((http.Response response) async {
        final String responseBody = response.body;
        String jsondecode = json.decode(responseBody)['message'];
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

  final dateFormat = DateFormat("dd/MM/yyyy");
  final timeFormat = DateFormat("h:mm");
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
                        DateTimeField(
                          format: dateFormat,
                          controller: _dateController,
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                          },
                          decoration: InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          /* onChanged: (dt) => setState(() {
                            date = "$dt";
                            print(dt);
                          }),*/
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 40,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Duration in hrs",
                            hintText: "Duration in hrs",
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
                        DateTimeField(
                          controller: _startController,
                          format: timeFormat,
                          onShowPicker: (context, currentValue) async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.convert(time);
                          },
                          decoration: InputDecoration(
                              labelText: 'Start',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
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
        "date": _dateController.text.substring(0, 9),
        "duration": _durationDaysController.text,
        "reason": _reasonController.text,
        "available": "false",
        "start": _startController.text,
      });
      formState.reset();
    }
  }
}
