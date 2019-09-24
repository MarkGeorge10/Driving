import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  String pay;
  SecondPage(this.pay);
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text("PayLoad:"),
            Text(widget.pay),
            RaisedButton(
                child: Text("Back"), onPressed: () => Navigator.pop(context))
          ],
        ),
      ),
    );
  }
}
