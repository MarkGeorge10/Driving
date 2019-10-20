import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:driving_instructor/PupilPackage/API.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Calender page.dart';

class EditHoliday extends StatefulWidget {
  String bookingID;
  int parseindex;

  EditHoliday(this.bookingID, this.parseindex);

  @override
  _EditHolidayState createState() => _EditHolidayState();
}

class _EditHolidayState extends State<EditHoliday> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _dateController = new TextEditingController();
  TextEditingController _durationDaysController = new TextEditingController();
  TextEditingController _reasonController = new TextEditingController();
  API api = new API();
  final currentTime = DateTime.now();
  List duration = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];

  List<DropdownMenuItem<String>> _dropDownMenuDurationItems;
  String _duration;

  Future<void> createTransaction(String url, {Map body}) async {
    print("mark");
    print(body);

    try {
      return http.post(url, body: body).then((http.Response response) async {
        final String responseBody = response.body;
        String jsondecode = json.decode(responseBody)["message"];
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _dropDownMenuDurationItems = getDropDownDurationMenuItems();
  }

  final dateFormat = DateFormat("dd/MM/yyyy");

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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
          future: getID(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                  future: api.fetchBooking(
                      "https://drivinginstructorsdiary.com/app/api/viewBookingApi?instructor_id=" +
                          "${snapshot.data}"),
                  builder: (context, snapViewBooking) {
                    if (snapViewBooking.hasData) {
                      List<String> startList, endList;
                      if (snapViewBooking.data[widget.parseindex]
                                  ["start_datetime"] ==
                              null ||
                          snapViewBooking.data[widget.parseindex]
                                  ["end_datetime"] ==
                              null) {
                        String startDate =
                            "0000-00-00".replaceAll(new RegExp(r'-'), '/');

                        String endDate =
                            "0000-00-00".replaceAll(new RegExp(r'-'), '/');

                        print(snapViewBooking.data[widget.parseindex]
                            ["end_datetime"]);

                        startList = startDate.split('/');
                        endList = endDate.split('/');
                      } else {
                        String startDate = snapViewBooking
                            .data[widget.parseindex]["start_datetime"]
                            .replaceAll(new RegExp(r'-'), '/');

                        String endDate = snapViewBooking.data[widget.parseindex]
                                ["end_datetime"]
                            .replaceAll(new RegExp(r'-'), '/');

                        print(snapViewBooking.data[widget.parseindex]
                            ["end_datetime"]);

                        startList = startDate.split('/');
                        endList = endDate.split('/');
                      }

                      _dateController.text = startList[2].substring(0, 2) +
                          '/' +
                          startList[1] +
                          '/' +
                          startList[0];

                      _reasonController.text = snapViewBooking
                                  .data[widget.parseindex]['reason'] ==
                              null
                          ? ""
                          : snapViewBooking.data[widget.parseindex]['reason'];

                      _duration = snapViewBooking.data[widget.parseindex]
                                      ['duration'] ==
                                  null ||
                              snapViewBooking.data[widget.parseindex]
                                      ['duration'] ==
                                  ""
                          ? "1"
                          : snapViewBooking.data[widget.parseindex]['duration'];

                      return Scaffold(
                        appBar: AppBar(
                          title: Text("Edit Holiday"),
                          actions: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          80),
                                  child: Center(
                                      child: currentTime.isBefore(
                                              DateTime.parse(snapViewBooking
                                                      .data[widget.parseindex]
                                                  ['end_datetime']))
                                          ? Text("Up coming")
                                          : Text(
                                              "Expired date",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )),
                                ),
                                Text(
                                  "End Date : " +
                                      endList[2].substring(0, 2) +
                                      '/' +
                                      endList[1] +
                                      '/' +
                                      endList[0],
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            )
                          ],
                        ),
                        body: SingleChildScrollView(
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                  DateTimeField(
                                    format: dateFormat,
                                    controller: _dateController,
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate:
                                              currentValue ?? DateTime.now(),
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
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Duration",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: new DropdownButton(
                                      value: _duration,
                                      items: _dropDownMenuDurationItems,
                                      onChanged: changedDropDownDurationItem,
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 40,
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
                                  Row(children: <Widget>[
                                    Expanded(
                                      child: FlatButton(
                                        onPressed: () {
                                          // TODO: implement validate function

                                          validateForm(
                                              "https://drivinginstructorsdiary.com/app/api/updateHolidayApi/" +
                                                  "${widget.bookingID}");
                                        },
                                        child: Text(
                                          "Update holiday",
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
                                                'instructor_id': snapshot.data,
                                                'date': _dateController.text
                                              });
                                          Navigator.pop(context,
                                              new MaterialPageRoute(
                                                  builder: (context) {
                                            return CalenderPage();
                                          }));
                                        },
                                        child: Text("Delete holiday"),
                                        color: Colors.red,
                                      ),
                                    ),
                                  ])
                                ],
                              )),
                        ),
                      );
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

  Future<void> validateForm(String url) async {
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      await createTransaction(url, body: {
        "date": _dateController.text.substring(0, 10),
        "durationDays": _duration,
        "reason": _reasonController.text
      });
      formState.reset();
    }
  }
}
