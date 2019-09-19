import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PupilDetailed extends StatefulWidget {
  String firstName,
      lastName,
      address,
      createdAt,
      company,
      instructorName,
      email,
      id,
      phone;
  PupilDetailed(
      {this.firstName,
      this.lastName,
      this.email,
      this.address,
      this.phone,
      this.company,
      this.instructorName,
      this.createdAt,
      this.id});
  @override
  _PupilDetailedState createState() => _PupilDetailedState();
}

class _PupilDetailedState extends State<PupilDetailed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.firstName + " " + widget.lastName),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "ID: ",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17.0),
                    ),
                    Text(
                      widget.id,
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "First Name: ",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17.0),
                    ),
                    Text(
                      widget.firstName,
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "Last Name: ",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17.0),
                    ),
                    Text(
                      widget.lastName,
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "Email: ",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17.0),
                    ),
                    Text(
                      widget.email,
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "Phone: ",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17.0),
                    ),
                    Text(
                      widget.phone,
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "Address: ",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17.0),
                    ),
                    Flexible(
                      child: Text(
                        widget.address,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textWidthBasis: TextWidthBasis.parent,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "Company: ",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17.0),
                    ),
                    Text(
                      widget.company,
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "instructor_name: ",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17.0),
                    ),
                    Text(
                      widget.instructorName,
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "created_at: ",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17.0),
                    ),
                    Text(
                      widget.createdAt,
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
