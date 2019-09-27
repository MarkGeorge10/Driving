import 'dart:async';

import 'package:calendar_view_widget/calendar_view_widget.dart';
import 'package:driving_instructor/PupilPackage/API.dart';
import 'package:flutter/material.dart';

import 'EditHoliday.dart';
import 'EditLesson.dart';

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

  @override
  Widget build(BuildContext context) {
    void onEventTapped(Map<String, String> event) {
      if (event['type'].substring(0, 6) == 'lesson') {
        int index;

        index = eventsList.indexOf(event);

        print(index);
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return EditLesson(event['id'], index, event['pupil_text']);
        }));
      } else if (event['type'].substring(0, 7) == 'holiday') {
        int index;

        index = eventsList.indexOf(event);

        print(index);
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return EditHoliday(event['id']);
        }));
      } else if (event['type'].substring(0, 7) == 'blocked') {
        int index;

        index = eventsList.indexOf(event);

        print(index);
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return EditHoliday(event['id']);
        }));
      } else if (event['type'].substring(0, 4) == 'test') {
        int index;

        index = eventsList.indexOf(event);
        print(index);
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return EditHoliday(event['id']);
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
