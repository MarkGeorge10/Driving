import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

class CalenderPage extends StatefulWidget {
  CalenderPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalenderPageState createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage>
    with TickerProviderStateMixin {
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

  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();

    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calender Page"),
      ),
      body: FutureBuilder(
          future: fetchBooking(
              "https://drivinginstructorsdiary.com/app/api/viewBookingApi?instructor_id=" +
                  "1054"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DateTime _selectedDay;
              for (int i = 0; i < snapshot.data.length; i++) {
                _selectedDay =
                    DateTime.parse(snapshot.data[i]['start_datetime']);
                _events = {
                  _selectedDay: [
                    snapshot.data[i]['type'],
                  ],
                };
              }

              _selectedEvents = _events[_selectedDay] ?? [];

              void _onDaySelected(DateTime day, List events) {
                print('CALLBACK: _onDaySelected');

                setState(() {
                  _selectedEvents = events;
                  _selectedDay = day;
                });
              }

              void _onVisibleDaysChanged(
                  DateTime first, DateTime last, CalendarFormat format) {
                print('CALLBACK: _onVisibleDaysChanged');
              }

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  // Switch out 2 lines below to play with TableCalendar's settings
                  //-----------------------
                  TableCalendar(
                    calendarController: _calendarController,
                    events: _events,
                    onDaySelected: _onDaySelected,
                    onVisibleDaysChanged: _onVisibleDaysChanged,
                    initialCalendarFormat: CalendarFormat.month,
                    // holidays: _holidays,
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    calendarStyle: CalendarStyle(
                      selectedColor: Colors.deepOrange[400],
                      todayColor: Colors.deepOrange[200],
                      markersColor: Colors.brown[700],
                      outsideDaysVisible: false,
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonTextStyle: TextStyle()
                          .copyWith(color: Colors.white, fontSize: 15.0),
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.deepOrange[400],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(child: _buildEventList()),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/Choice');
          }),
    );
  }

  Widget _buildEventList() {
    return ListView.builder(
        itemCount: _selectedEvents.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.8),
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              title: Text(_selectedEvents[index].toString()),
              onTap: () => print('$_selectedEvents tapped!'),
            ),
          );
        });
  }
}
