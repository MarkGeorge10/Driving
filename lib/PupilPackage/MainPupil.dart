import 'package:flutter/material.dart';

import 'InactivePupil.dart';
import 'Pupil.dart';

class MainPupil extends StatefulWidget {
  @override
  _MainPupilState createState() => _MainPupilState();
}

class _MainPupilState extends State<MainPupil> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Active Pupil'),
    Tab(text: 'Inactive Pupil'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 20.0,
          title: Text("Pupil Page"),
          centerTitle: true,
          bottom: TabBar(
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          children: myTabs.map((Tab tab) {
            return buildNavPage(tab.text, context);
          }).toList(),
        ),
      ),
    );
  }

  Widget buildNavPage(String text, BuildContext context) {
    if (text == "Active Pupil") {
      return Pupils();
    }
    return InactivePupil();
  }
}
