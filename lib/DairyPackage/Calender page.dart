import 'dart:async';
import 'dart:convert';

import 'package:calendar_view_widget/calendar_view_widget.dart';
import 'package:driving_instructor/PupilPackage/API.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CalenderPage extends StatefulWidget {
  CalenderPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalenderPageState createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage>
    with TickerProviderStateMixin {
  StreamController<List<Map<String, String>>> eventsController =
      new StreamController();

  List<dynamic> bookingItems;
  Future<List<dynamic>> fetchBooking(String url) async {
    print(url);

    try {
      return http.post(url).then((http.Response response) async {
        final String responseBody = response.body;
        bookingItems = json.decode(responseBody)["bookings"];

        print("mark");
        print(bookingItems);

        return bookingItems;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");

    return null;
  }

  @override
  void dispose() {
    eventsController.close();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> createSignature(String url, {Map body}) async {
    print("mark");
    print(body);

    try {
      return http.post(url, body: body).then((http.Response response) async {
        final String responseBody = response.body;
        String jsondecode = json.decode(responseBody)["message"];
        print(jsondecode);
        print(jsondecode);
      });
    } catch (ex) {
      _showDialog("Something happened errored");
    }
    _showDialog("Something happened errored");
    return null;
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _signature = new TextEditingController();

  void _showDialog(String bookingID) {
    // flutter defined function

    Future<void> validateForm(String url) async {
      FormState formState = _formKey.currentState;

      if (formState.validate()) {
        await createSignature(url, body: {'signature': _signature.text});
        formState.reset();
      }
    }

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
                  controller: _signature,
                  decoration: InputDecoration(
                    labelText: "Your Signature",
                    hintText: "Your Signature",
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
                    validateForm(
                        "https://drivinginstructorsdiary.com/app/api/updateSignatureApi" +
                            "?booking_id=" +
                            "$bookingID");
                    Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData.dark().copyWith(
      primaryColor: Colors.grey,
      accentColor: Colors.lightGreen,
      canvasColor: Colors.white,
      backgroundColor: Colors.lightGreen,
      dividerColor: Colors.green,
      textTheme: ThemeData.dark().textTheme.copyWith(
            display1: TextStyle(
              fontSize: 21.0,
            ),
            subhead: TextStyle(
              fontSize: 14.0,
              color: Colors.green,
            ),
            headline: TextStyle(
              fontSize: 18.0,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
            title: TextStyle(
              fontSize: 14.0,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
      accentTextTheme: ThemeData.dark().accentTextTheme.copyWith(
            body1: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            title: TextStyle(
              fontSize: 21.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            display1: TextStyle(
              fontSize: 21.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
    );

    void onEventTapped(Map<String, String> event) {
      if (event['type'].substring(0, 6) == 'lesson') {
        _showDialog(event['id']);
      }

      print(event['type'].substring(0, 6));
    }

    API api = new API();

    return FutureBuilder(
      future: api.getID(),
      builder: (context, snapshot) {
        return FutureBuilder(
            future: fetchBooking(
                "https://drivinginstructorsdiary.com/app/api/viewBookingApi?instructor_id=" +
                    "${snapshot.data}"),
            builder: (context, snap) {
              if (snap.hasData) {
                List<Map<String, String>> eventsList = [];
                for (int i = 0; i < snap.data.length; i++) {
                  eventsList.add(
                    {
                      'type': snap.data[i]['pupil_text'] == null ||
                              snap.data[i]['pupil_text'] == ""
                          ? snap.data[i]['type']
                          : snap.data[i]['type'] +
                              "\n" +
                              snap.data[i]['pupil_text'],
                      'reason': snap.data[i]['reason'] == null ||
                              snap.data[i]['reason'] == ""
                          ? ""
                          : snap.data[i]['reason'],
                      'date': snap.data[i]['start_datetime'],
                      'id': snap.data[i]['id']
                    },
                  );
                  eventsController.add(eventsList);
                }

                print(eventsController);

                return new Scaffold(
                  appBar: new AppBar(
                    title: new Text("Calender Page"),
                  ),
                  floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        Navigator.pushNamed(context, '/Choice');
                      }),
                  body: new Center(
                    // Center is a layout widget. It takes a single child and positions it
                    // in the middle of the parent.
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // default String parameter values used below as example
                        new CalendarView(
                          onEventTapped: onEventTapped,
                          titleField: 'type',
                          detailField: 'reason',
                          dateField: 'date',
                          separatorTitle: 'Event',
                          theme: theme,
                          eventStream: eventsController.stream,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            });
      },
    );
  }
}
