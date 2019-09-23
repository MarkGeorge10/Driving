import 'package:driving_instructor/PupilPackage/API.dart';
import 'package:flutter/material.dart';

import 'DetailedMsg.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  API api = new API();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message Page"),
      ),
      body: FutureBuilder(
          future: api.getID(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                  future: api.fetchMsg(
                      "https://drivinginstructorsdiary.com/app/api/viewMessageApi?instructor_id=" +
                          "${snapshot.data}"),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      return ListView.builder(
                          itemCount: snap.data.length,
                          itemBuilder: (context, position) {
                            //MailContent mailContent = MailGenerator.getMailContent(position);
                            return InkWell(
                              onTap: () {
                                //   print(snapshot.data[position]["receiver_id"]);
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => DetailedMsg(
                                            snap.data[position]
                                                ["receiver_sender_name"],
                                            snap.data[position]["subject"],
                                            snap.data[position]["message"],
                                            snap.data[position]
                                                ["receiver_id"])));
                              },
                              child: Card(
                                color: snap.data[position]["read_status"] == "0"
                                    ? Colors.grey
                                    : Colors.white,
                                child: ListTile(
                                  title: Text(
                                    snap.data[position]
                                                ["receiver_sender_name"] ==
                                            ""
                                        ? "Sender Name"
                                        : api.msgItem[position]
                                            ["receiver_sender_name"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        fontSize: 17.0),
                                  ),
                                  subtitle: Text(
                                    snap.data[position]["subject"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                        fontSize: 15.5),
                                  ),
                                ),
                              ),
                            );
                          });
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/AddMessage');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
