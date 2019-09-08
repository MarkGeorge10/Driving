import 'package:flutter/material.dart';

import 'Mail.dart';

class MailGenerator {
  static var mailList = [
    MailContent("Happy Halloween", "John Doe", "31 Oct",
        "This is a simple demo mail..."),
    MailContent("Happy Halloween", "John Doe", "31 Oct",
        "This is a simple demo mail..."),
  ];
  static MailContent getMailContent(int position) => mailList[position];
  static int mailListLength = mailList.length;
}

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: MailGenerator.mailListLength,
          itemBuilder: (context, position) {
            MailContent mailContent = MailGenerator.getMailContent(position);
            return Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: 14.0, right: 14.0, top: 5.0, bottom: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.account_circle,
                      size: 55.0,
                      color: Colors.red,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  mailContent.sender,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87,
                                      fontSize: 17.0),
                                ),
                                Text(
                                  mailContent.time,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: 13.5),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      mailContent.subject,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54,
                                          fontSize: 15.5),
                                    ),
                                    Text(
                                      mailContent.message,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54,
                                          fontSize: 15.5),
                                    )
                                  ],
                                ),
                                Icon(Icons.star_border, size: 25.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
            ]);
          }),
    );
  }
}
