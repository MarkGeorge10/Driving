import 'package:flutter/material.dart';

import 'Message/MessagesPage.dart';
import 'Pupil.dart';
import 'RegistrationForm/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: LoginPage(),
      routes: {
        '/Pupils': (context) => Pupils(),
        '/MessagePage': (context) => MessagePage(),
      },
    );
  }
}
