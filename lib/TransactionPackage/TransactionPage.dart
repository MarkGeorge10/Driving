import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dat = prefs.get("idPref");

    return dat;
  }

  List<dynamic> transactionItem;
  Future<List<dynamic>> fetchTransaction(String url) async {
    print(url);

    try {
      return http.post(url).then((http.Response response) async {
        final String responseBody = response.body;
        transactionItem = json.decode(responseBody)["data"];

        print("mark");
        print(transactionItem[0]);

        return transactionItem;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TranscationPage"),
      ),
      body: FutureBuilder(
        future: getID(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: fetchTransaction(
                  "https://drivinginstructorsdiary.com/app/api/viewMessageApi?instructor_id=" +
                      "${snapshot.data}"),
              builder: (context, snap) {
                if (snap.hasData) {
                  return ListView.builder(
                      itemCount: snap.data.lenght,
                      itemBuilder: (context, index) {
                        return Card(
                            elevation: 5.0,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(15.0),
                              leading: Text(snap.data[index]["type"]),
                              subtitle: Text(snap.data[index]["date"]),
                              title: Center(
                                  child: Column(
                                children: <Widget>[
                                  Text(snap.data[index]["hours"]),
                                  Text(snap.data[index]["status"]),
                                ],
                              )),
                              trailing: Icon(Icons.delete),
                            ));
                      });
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
          return Center(
            child: Text("Data Not founded"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/AddTransaction');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
