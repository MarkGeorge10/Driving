import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:driving_instructor/PupilPackage/API.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Calender page.dart';

class EditBlocked extends StatefulWidget {
  String bookingID;
  int parseindex;

  EditBlocked(this.bookingID, this.parseindex);

  @override
  _EditBlockedState createState() => _EditBlockedState();
}

class _EditBlockedState extends State<EditBlocked> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _durationDaysController = new TextEditingController();
  TextEditingController _reasonController = new TextEditingController();
  TextEditingController _startController = new TextEditingController();
  API api = new API();
  List duration = [
    "0.5",
    "1",
    "1.5",
    "2",
    "2.5",
    "3",
    "3.5",
    "4",
    "4.5",
    "5",
    "5.5",
    "6",
    "7",
    "7.5",
    "8",
    "8.5",
    "9",
    "9.5",
    "10",
    "10.5",
    "11",
    "11.5",
    "12",
  ];

  List<DropdownMenuItem<String>> _dropDownMenuDurationItems;
  String _duration;

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

  Future<void> deleteHoliday(String url, {Map body}) async {
    print(url);

    try {
      return http.post(url, body: body).then((http.Response response) async {
        final String responseBody = response.body;
        String jsondecode = json.decode(responseBody)["data"];
        print(jsondecode);
        _showDialog(jsondecode);
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dropDownMenuDurationItems = getDropDownDurationMenuItems();
  }

  List<DropdownMenuItem<String>> getDropDownDurationMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in duration) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }

    return items;
  }

  void changedDropDownDurationItem(String selectedCity) {
    print("Selected city $selectedCity, we are going to refresh the UI");
    setState(() {
      _duration = selectedCity;
    });
  }

  final dateFormat = DateFormat("dd/MM/yyyy");
  final timeFormat = DateFormat("h:mm");
  final currentTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
          future: getID(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return
                  //-------------------------------------------------------------------------------
                  FutureBuilder(
                      future: api.fetchBooking(
                          "https://drivinginstructorsdiary.com/app/api/viewBookingApi?instructor_id=" +
                              "${snapshot.data}"),
                      builder: (context, snapViewBooking) {
                        if (snapViewBooking.hasData) {
                          _dateController.text = snapViewBooking
                              .data[widget.parseindex]['start_datetime']
                              .substring(0, 10);

                          _startController.text = snapViewBooking
                              .data[widget.parseindex]['start_datetime']
                              .substring(11, 16);

                          _reasonController.text = snapViewBooking
                                      .data[widget.parseindex]['reason'] ==
                                  null
                              ? ""
                              : snapViewBooking.data[widget.parseindex]
                                  ['reason'];

                          _duration = snapViewBooking.data[widget.parseindex]
                              ['duration'];
                          return Scaffold(
                            appBar: AppBar(
                              title: Text("Edit Blocked"),
                              actions: <Widget>[
                                Card(
                                  color: currentTime.isBefore(DateTime.parse(
                                          snapViewBooking
                                                  .data[widget.parseindex]
                                              ['end_datetime']))
                                      ? Colors.white
                                      : Colors.red,
                                  margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width /
                                          20),
                                  child: Container(
                                    child: Center(
                                        child: currentTime.isBefore(
                                                DateTime.parse(snapViewBooking
                                                        .data[widget.parseindex]
                                                    ['end_datetime']))
                                            ? Text("Available")
                                            : Text("Expired date")),
                                  ),
                                )
                              ],
                            ),
                            body: SingleChildScrollView(
                                child: Form(
                                    key: _formKey,
                                    child: Column(children: <Widget>[
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                40,
                                      ),
                                      DateTimeField(
                                        format: dateFormat,
                                        controller: _dateController,
                                        onShowPicker: (context, currentValue) {
                                          return showDatePicker(
                                              context: context,
                                              firstDate: DateTime(1900),
                                              initialDate: currentValue ??
                                                  DateTime.now(),
                                              lastDate: DateTime(2100));
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Date',
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15))),
                                        /* onChanged: (dt) => setState(() {
                                date = "$dt";
                                print(dt);
                            }),*/
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                40,
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Duration in Hrs",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: new DropdownButton(
                                          value: _duration,
                                          items: _dropDownMenuDurationItems,
                                          onChanged:
                                              changedDropDownDurationItem,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                40,
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: "Reason",
                                          hintText: "Reason",
                                          hintStyle: TextStyle(fontSize: 18),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
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
                                        height:
                                            MediaQuery.of(context).size.height /
                                                40,
                                      ),
                                      DateTimeField(
                                        controller: _startController,
                                        format: timeFormat,
                                        onShowPicker:
                                            (context, currentValue) async {
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
                                                borderRadius:
                                                    BorderRadius.circular(15))),
                                      ),
                                      Row(children: <Widget>[
                                        Expanded(
                                          child: FlatButton(
                                            onPressed: () {
                                              // TODO: implement validate function

                                              validateForm(
                                                  "https://drivinginstructorsdiary.com/app/api/updateBlockedApi/" +
                                                      "${widget.bookingID}");
                                            },
                                            child: Text(
                                              "Update Blocked",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            color: Colors.blue,
                                          ),
                                        ),
                                        Expanded(
                                          child: FlatButton(
                                            onPressed: () {
                                              deleteHoliday(
                                                  "https://drivinginstructorsdiary.com/app/api/deleteBookingApi/" +
                                                      "${widget.bookingID}",
                                                  body: {
                                                    'instructor_id':
                                                        snapshot.data,
                                                    'date': _dateController.text
                                                  });

                                              Navigator.pop(context,
                                                  new MaterialPageRoute(
                                                      builder: (context) {
                                                return CalenderPage();
                                              }));
                                            },
                                            child: Text("Delete blocked"),
                                            color: Colors.red,
                                          ),
                                        ),
                                      ])
                                    ]))),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });

              //-------------------------------------------------------------------------------
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
