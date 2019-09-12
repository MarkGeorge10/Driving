import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class DetailedMsg extends StatefulWidget {
  String title, subject, body;
  DetailedMsg(this.title, this.subject, this.body);
  @override
  _DetailedMsgState createState() => _DetailedMsgState();
}

class _DetailedMsgState extends State<DetailedMsg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 40,
                  left: MediaQuery.of(context).size.width / 8),
              child: Row(
                children: <Widget>[
                  Text(
                    "Subject: ",
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                  ),
                  Text(
                    widget.subject,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      fontSize: 20.0,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 35,
            ),
            Container(
              margin:
                  EdgeInsets.only(left: MediaQuery.of(context).size.width / 40),
              child: HtmlWidget(
                widget.body,
                webView: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
