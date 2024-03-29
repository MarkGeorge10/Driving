import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as URLLauncher;

// ignore: must_be_immutable
class PupilDetailed extends StatefulWidget {
  String firstName,
      lastName,
      address,
      createdAt,
      instructorName,
      email,
      postalCode,
      houseNumbe,
      phone;

  PupilDetailed(
      {this.firstName,
      this.lastName,
      this.email,
      this.address,
      this.phone,
      this.instructorName,
      this.createdAt,
      this.houseNumbe,
      this.postalCode});

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
                      "First Name: ",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17.0),
                    ),
                    Text(
                      widget.firstName == null || widget.firstName == ""
                          ? ""
                          : widget.firstName,
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
                      widget.lastName == null || widget.lastName == ""
                          ? ""
                          : widget.lastName,
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
                      widget.email == null || widget.email == ""
                          ? ""
                          : widget.email,
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(children: <Widget>[
                  Text(
                    "Phone: ",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),
                  ),
                  Text(
                    widget.phone == null || widget.phone == ""
                        ? ""
                        : widget.phone,
                    style: TextStyle(fontSize: 15.0),
                  ),
                  IconButton(
                      icon: Icon(Icons.dialer_sip),
                      onPressed: () {
                        URLLauncher.launch("tel:" + widget.phone);
                      }),
                ]),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "House Number: ",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17.0),
                    ),
                    Text(
                      widget.houseNumbe,
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
                      "Postal Code: ",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17.0),
                    ),
                    Text(
                      widget.postalCode,
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
