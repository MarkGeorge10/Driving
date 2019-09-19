import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateTest extends StatefulWidget {
  @override
  _CreateTestState createState() => _CreateTestState();
}

class _CreateTestState extends State<CreateTest> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _dateController = new TextEditingController();
  TextEditingController _pupilIDController = new TextEditingController();
  TextEditingController _durationDaysController = new TextEditingController();
  TextEditingController _pupilPostCodeController = new TextEditingController();
  TextEditingController _pupilAddressController = new TextEditingController();
  TextEditingController _doPostCodeController = new TextEditingController();
  TextEditingController _memoController = new TextEditingController();
  TextEditingController _startController = new TextEditingController();
  TextEditingController _testCenterController = new TextEditingController();
  TextEditingController _testTimeHourController = new TextEditingController();
  TextEditingController _testTimeMinController = new TextEditingController();

  List status = ["pending", "Delivered", "Cancelled"];

  List<DropdownMenuItem<String>> _dropDownMenuStatusItems;
  String _stat;
  @override
  void initState() {
    _dropDownMenuStatusItems = getDropDownStatusMenuItems();

    _stat = _dropDownMenuStatusItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownStatusMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in status) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }

    return items;
  }

  void changedDropDownStatusItem(String selectedCity) {
    print("Selected city $selectedCity, we are going to refresh the UI");
    setState(() {
      _stat = selectedCity;
    });
  }

  Future<void> createLesson(String url, {Map body}) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Test"),
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
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Pupil ID",
                            hintText: "Pupil ID",
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          controller: _pupilIDController,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Pupil ID field should not be empty";
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
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Pupil Post Code",
                            hintText: "Pupil Post Code",
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          controller: _pupilPostCodeController,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Pupil Post Code field should not be empty";
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
                            labelText: "Do Post Code",
                            hintText: "Do Post Code",
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          controller: _doPostCodeController,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Do Post Code field should not be empty";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 40,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Pupil Address",
                            hintText: "Pupil Address",
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          controller: _pupilAddressController,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Pupil Address field should not be empty";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 40,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Memo",
                            hintText: "Memo",
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          controller: _memoController,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Memo field should not be empty";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 40,
                        ),
                        ListTile(
                          title: Text(
                            "Status",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: new DropdownButton(
                            value: _stat,
                            items: _dropDownMenuStatusItems,
                            onChanged: changedDropDownStatusItem,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 40,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Test Center",
                            hintText: "Test Center",
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          controller: _testCenterController,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Test Center field should not be empty";
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
                            labelText: "Test Time Hour",
                            hintText: "Test Time Hour",
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          controller: _testTimeHourController,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Test Time Hour field should not be empty";
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
                            labelText: "Test Time Min",
                            hintText: "Test Time Min",
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          controller: _testTimeMinController,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Test Time Min field should not be empty";
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
                                  "https://drivinginstructorsdiary.com/app/api/createTestApi?instructor_id=" +
                                      "${snapshot.data}");
                            },
                            child: Text(
                              "Create Test",
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
      await createLesson(url, body: {
        "pupil_id": _pupilIDController.text,
        "start": _startController.text,
        "date": _dateController.text,
        "duration": _durationDaysController.text,
        "pupil_postcode": _pupilPostCodeController.text,
        "pupil_address": _pupilAddressController.text,
        "do_postcode": _doPostCodeController.text,
        "memo": _memoController.text,
        "status": _stat,
        "available": "false",
        "test_centre": _testCenterController.text,
        "test_time_hour": _testTimeHourController.text,
        "test_time_min": _testTimeMinController.text,
      });
      formState.reset();
    }
  }
}
