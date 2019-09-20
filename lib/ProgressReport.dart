import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dat = prefs.get("idPref");

    return dat;
  }

  List<dynamic> transactionItem;
  Future<List<dynamic>> fetchReport(String url) async {
    print(url);

    try {
      return http.post(url).then((http.Response response) async {
        final String responseBody = response.body;
        transactionItem = json.decode(responseBody)["data"]["progress_report"];

        print("mark");
        print(transactionItem);

        return transactionItem;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Progress Report Page"),
      ),
      body: FutureBuilder(
        future: getID(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: fetchReport(
                  "https://drivinginstructorsdiary.com/app/api/progressReportApi/" +
                      "${snapshot.data}"),
              builder: (context, snap) {
                if (snap.hasData) {
                  return ListView.builder(
                      itemCount: snap.data.length,
                      itemBuilder: (context, index) {
                        return Card(
                            elevation: 5.0,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(15.0),
                              subtitle: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 50,
                                  ),
                                  Text(
                                    "Description",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(snap.data[index]["note"] == null
                                      ? "No Notes Added"
                                      : snap.data[index]["note"]),
                                ],
                              ),
                              title: Center(
                                  child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Payment : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Flexible(
                                          child: Text(snap.data[index]
                                              ["payment_method"])),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "amount: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(snap.data[index]["amount"]),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Status: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(snap.data[index]["status"]),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Hours: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(snap.data[index]["hours"] == null
                                          ? "No addede hrs"
                                          : snap.data[index]["hours"]),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "type: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(snap.data[index]["type"] == null
                                          ? "No addede type"
                                          : snap.data[index]["type"]),
                                    ],
                                  ),
                                ],
                              )),
                            ));
                      });
                }
                return Center(
                  child: Text(
                    "Not Founded Data",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
