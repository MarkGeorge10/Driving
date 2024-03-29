import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:driving_instructor/PupilPackage/API.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Calender page.dart';
import 'Signature.dart';

class EditTest extends StatefulWidget {
  String bookingID;
  int parseindex;

  EditTest(this.bookingID, this.parseindex);
  @override
  _EditTestState createState() => _EditTestState();
}

class _EditTestState extends State<EditTest> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _dateController = new TextEditingController();
  TextEditingController _durationDaysController = new TextEditingController();
  TextEditingController _pupilPostCodeController = new TextEditingController();
  TextEditingController _pupilAddressController = new TextEditingController();
  TextEditingController _doPostCodeController = new TextEditingController();
  TextEditingController _memoController = new TextEditingController();
  TextEditingController _startController = new TextEditingController();
  TextEditingController _testCenterController = new TextEditingController();
  TextEditingController _testTimeHourController = new TextEditingController();
  TextEditingController _testTimeMinController = new TextEditingController();
  final currentTime = DateTime.now();

  List status = ["pending", "Delivered", "Cancelled"];
  List duration = [
    "0.5",
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

  List<DropdownMenuItem<String>> _dropDownMenuStatusItems;
  String _stat;

  String pupilItemstr;

  API api = new API();
  @override
  void initState() {
    _dropDownMenuStatusItems = getDropDownStatusMenuItems();
    _dropDownMenuDurationItems = getDropDownDurationMenuItems();

    _duration = _dropDownMenuDurationItems[0].value;
    _stat = _dropDownMenuStatusItems[0].value;
    super.initState();
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

  Future<void> deleteLesson(String url, {Map body}) async {
    print(url);

    try {
      return http.post(url, body: body).then((http.Response response) async {
        final String responseBody = response.body;
        String jsondecode = json.decode(responseBody)['data'];
        print(jsondecode);
        _showDialog(jsondecode);
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  final dateFormat = DateFormat("dd/MM/yyyy");
  final timeFormat = DateFormat("h:mm");

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

                      _startController.text = snapViewBooking
                          .data[widget.parseindex]['start_datetime']
                          .substring(11, 16);

                      _pupilPostCodeController.text = snapViewBooking
                          .data[widget.parseindex]['p_u_postcode'];

                      _doPostCodeController.text = snapViewBooking
                          .data[widget.parseindex]['d_o_postcode'];
                      _pupilAddressController.text = snapViewBooking
                          .data[widget.parseindex]['p_u_address'];

                      _memoController.text =
                          snapViewBooking.data[widget.parseindex]['memo'] ==
                                  null
                              ? ""
                              : snapViewBooking.data[widget.parseindex]['memo'];

                      _stat = snapViewBooking.data[widget.parseindex]['status'];

                      return Scaffold(
                        appBar: AppBar(
                          title: Text("Edit Test"),
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
                            ),
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
                                  FutureBuilder(
                                    future: api.fetchMsg(
                                        "https://drivinginstructorsdiary.com/app/api/viewPupilApi/active?instructor_id=${snapshot.data}"),
                                    builder: (context, snap) {
                                      if (snap.hasData) {
                                        List<DropdownMenuItem<String>> items =
                                            new List();
                                        String pupil;
                                        for (int i = 0;
                                            i < snap.data.length;
                                            i++) {
                                          pupil = snap.data[i]["first_name"] +
                                              " " +
                                              snap.data[i]["last_name"];
                                          String pupilID = snap.data[i]["id"];
                                          // here we are creating the drop down menu items, you can customize the item right here
                                          // but I'll just use a simple text for this
                                          items.add(new DropdownMenuItem(
                                              value: pupilID,
                                              child: new Text(pupil)));
                                        }

                                        void changedDropDownPupilItem(
                                            String selectedCity) {
                                          print(
                                              "Selected city $selectedCity, we are going to refresh the UI");
                                          setState(() {
                                            pupilItemstr = selectedCity;
                                          });
                                        }

                                        return ListTile(
                                          title: Text(
                                            "Pupil Name",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: new DropdownButton(
                                            value: pupilItemstr,
                                            items: items,
                                            onChanged: changedDropDownPupilItem,
                                          ),
                                          trailing: Column(
                                            children: <Widget>[
                                              Text(
                                                "Currently User Name: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                pupil,
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 40,
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
                                      "Duration in Hrs",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: new DropdownButton(
                                      value: _duration,
                                      items: _dropDownMenuDurationItems,
                                      onChanged: changedDropDownDurationItem,
                                    ),
                                    trailing: Column(
                                      children: <Widget>[
                                        Text(
                                          "Currently Duration: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          snapViewBooking.data[
                                                              widget.parseindex]
                                                          ['duration'] ==
                                                      null ||
                                                  snapViewBooking.data[
                                                              widget.parseindex]
                                                          ['duration'] ==
                                                      ""
                                              ? "No added duration "
                                              : snapViewBooking
                                                      .data[widget.parseindex]
                                                  ['duration'],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "Pupil Post Code",
                                      hintText: "Pupil Post Code",
                                      hintStyle: TextStyle(fontSize: 18),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "Do Post Code",
                                      hintText: "Do Post Code",
                                      hintStyle: TextStyle(fontSize: 18),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Pupil Address",
                                      hintText: "Pupil Address",
                                      hintStyle: TextStyle(fontSize: 18),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Memo",
                                      hintText: "Memo",
                                      hintStyle: TextStyle(fontSize: 18),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Status",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: new DropdownButton(
                                      value: _stat,
                                      items: _dropDownMenuStatusItems,
                                      onChanged: changedDropDownStatusItem,
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Test Center",
                                      hintText: "Test Center",
                                      hintStyle: TextStyle(fontSize: 18),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "Test Time Hour",
                                      hintText: "Test Time Hour",
                                      hintStyle: TextStyle(fontSize: 18),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "Test Time Min",
                                      hintText: "Test Time Min",
                                      hintStyle: TextStyle(fontSize: 18),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    controller: _testTimeMinController,
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return "Test Time Min field should not be empty";
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
                                              "https://drivinginstructorsdiary.com/app/api/updateTestApi/" +
                                                  "${widget.bookingID}");
                                        },
                                        child: Text(
                                          "Update Lesson",
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
                                          deleteLesson(
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
                                        child: Text("Delete Lesson"),
                                        color: Colors.red,
                                      ),
                                    ),
                                    Expanded(
                                        child: FlatButton(
                                            onPressed: () {
                                              Navigator.push(context,
                                                  new MaterialPageRoute(
                                                      builder: (context) {
                                                return SignaturePage(
                                                    widget.bookingID);
                                              }));
                                            },
                                            child: Text("ADD Signature")))
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
      await createLesson(url, body: {
        "pupil_id": pupilItemstr,
        "start": _startController.text,
        "date": _dateController.text.substring(0, 10),
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
