import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Signature extends StatefulWidget {
  String bookingID;

  Signature(this.bookingID);

  @override
  _SignatureState createState() => _SignatureState();
}

class _SignatureState extends State<Signature> {
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
    } catch (ex) {}
    return null;
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _signature = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Signature"),
      ),
      body: Column(
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
                      "${widget.bookingID}");
              Navigator.of(context).pop();
            },
            child: Text("Reply on"),
          )
        ],
      ),
    );
  }

  Future<void> validateForm(String url) async {
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      await createSignature(url, body: {'signature': _signature.text});
      formState.reset();
    }
  }
}
