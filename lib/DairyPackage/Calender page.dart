import 'dart:async';

import 'package:calendar_view_widget/calendar_view_widget.dart';
import 'package:driving_instructor/PupilPackage/API.dart';
import 'package:flutter/material.dart';

import 'EditBlocked.dart';
import 'EditHoliday.dart';
import 'EditLesson.dart';
import 'EditTest.dart';

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
  API api = new API();

  @override
  void dispose() {
    eventsController.close();
    // TODO: implement dispose
    super.dispose();
  }

  List<Map<String, String>> eventsList = [];

  bool check = false;
  Color cInput;

  @override
  Widget build(BuildContext context) {
    void onEventTapped(Map<String, String> event) {
      if (event['type'].substring(0, 6) == 'lesson') {
        int index;
        index = eventsList.indexOf(event);
        eventsController.close();
        check = true;
        print(index);
        List<String> startList;
        if (event['start_datetime'] == null) {
          String startDate = "0000-00-00".replaceAll(new RegExp(r'-'), '/');

          String endDate = "0000-00-00".replaceAll(new RegExp(r'-'), '/');

          startList = startDate.split('/');
        } else {
          String startDate =
              event['start_datetime'].replaceAll(new RegExp(r'-'), '/');

          startList = startDate.split('/');
        }

        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return EditLesson(event['id'], index, event['start_datetime']);
        }));
      } else if (event['type'].substring(0, 7) == 'holiday') {
        int index;

        index = eventsList.indexOf(event);
        eventsController.close();
        check = true;
        print(index);
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return EditHoliday(event['id'], index);
        }));
      } else if (event['type'].substring(0, 7) == 'blocked') {
        int index;

        index = eventsList.indexOf(event);
        eventsController.close();
        check = true;
        print(index);
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return EditBlocked(event['id'], index);
        }));
      } else if (event['type'].substring(0, 4) == 'test' ||
          event['type'].substring(0, 4) == 'Test') {
        int index;
        eventsController.close();
        check = true;
        index = eventsList.indexOf(event);
        print(index);
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return EditTest(event['id'], index);
        }));
      }

      //print(i);
    }

    return FutureBuilder(
      future: api.getID(),
      builder: (context, snapshot) {
        return FutureBuilder(
            future: api.fetchBooking(
                "https://drivinginstructorsdiary.com/app/api/viewBookingApi?instructor_id=" +
                    "${snapshot.data}"),
            builder: (context, snap) {
              if (snap.hasData) {
                print(snap.data.length);

                if (check == false) {
                  for (int i = 0; i < snap.data.length; i++) {
/*
                    if (snap.data[i]['type'] == 'lesson') {
                      cInput = const Color(0xFF37F7A4);
                    } else if (snap.data[i]['type'] == 'holiday') {
                      cInput = const Color(0xFFF2F584);
                    } else if (snap.data[i]['type'] == 'blocked') {
                      cInput = const Color(0xFFB8B8B4);
                    } else if (snap.data[i]['type'] == 'test') {
                      cInput = const Color(0xFF67F4F7);
                    }*/
                    List<String> startList, endList;
                    if (snap.data[i]["start_datetime"] == null ||
                        snap.data[i]["end_datetime"] == null) {
                      String startDate =
                          "0000-00-00".replaceAll(new RegExp(r'-'), '/');

                      String endDate =
                          "0000-00-00".replaceAll(new RegExp(r'-'), '/');

                      print(snap.data[i]["end_datetime"]);

                      startList = startDate.split('/');
                      endList = endDate.split('/');
                    } else {
                      String startDate = snap.data[i]["start_datetime"]
                          .replaceAll(new RegExp(r'-'), '/');

                      String endDate = snap.data[i]["end_datetime"]
                          .replaceAll(new RegExp(r'-'), '/');

                      print(snap.data[i]["end_datetime"]);

                      startList = startDate.split('/');
                      endList = endDate.split('/');
                    }

                    eventsList.add(
                      {
                        'type': snap.data[i]['pupil_text'] == null ||
                                snap.data[i]['pupil_text'] == ""
                            ? snap.data[i]['type'] +
                                "\n" +
                                "Start: " +
                                startList[2].substring(0, 2) +
                                '/' +
                                startList[1] +
                                '/' +
                                startList[0] +
                                " " +
                                startList[2].substring(3, 11) +
                                "\n" +
                                "End: " +
                                endList[2].substring(0, 2) +
                                '/' +
                                endList[1] +
                                '/' +
                                endList[0] +
                                " " +
                                endList[2].substring(3, 11)
                            : snap.data[i]['type'] +
                                "\n" +
                                snap.data[i]['pupil_text'] +
                                "\n" +
                                "Start: " +
                                startList[2].substring(0, 2) +
                                '/' +
                                startList[1] +
                                '/' +
                                startList[0] +
                                " " +
                                startList[2].substring(3, 11) +
                                "\n" +
                                "End: " +
                                endList[2].substring(0, 2) +
                                '/' +
                                endList[1] +
                                '/' +
                                endList[0] +
                                " " +
                                endList[2].substring(3, 11),
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
                }

                print(eventsController);

                return new Scaffold(
                  appBar: new AppBar(
                    title: new Text("Calender Page"),
                  ),
                  floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        //eventsController.close();
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
                          theme: ThemeData.dark().copyWith(
                            primaryColor: Colors.green,
                            canvasColor: Colors.white,
                            backgroundColor: Colors.green,
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
                            accentTextTheme:
                                ThemeData.dark().accentTextTheme.copyWith(
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
                          ),
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
