import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class UpdatePupil extends StatefulWidget {
  String pupilID;
  UpdatePupil(this.pupilID);
  @override
  _UpdatePupilState createState() => _UpdatePupilState();
}

class _UpdatePupilState extends State<UpdatePupil> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _firstController = new TextEditingController();
  TextEditingController _lastController = new TextEditingController();
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _titleController = new TextEditingController();

  TextEditingController _productIDController = new TextEditingController();
  TextEditingController _lessonTypeIDController = new TextEditingController();
  TextEditingController _usualAvalability = new TextEditingController();
  TextEditingController _pickUpAddress = new TextEditingController();
  TextEditingController _pickUpPostCode = new TextEditingController();
  TextEditingController _homePostCode = new TextEditingController();
  TextEditingController _homeAddress = new TextEditingController();

  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.get("idPref");
    print(data);
    return data;
  }

  Future<void> updatePupil(String url, {Map body}) async {
    print("mark");
    print(body);

    try {
      return http.post(url, body: body).then((http.Response response) async {
        final String responseBody = response.body;
        String jsondecode = json.decode(responseBody);
        print(json.decode(responseBody));
      });
    } catch (ex) {
      print("Something happened errored");
    }
    print("Something happened errored");
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Pupil Data"),
      ),
      body: FutureBuilder(
          future: getID(),
          builder: (context, snap) {
            if (snap.hasData) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      TextFormField(
                        controller: _emailController,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 15.0),
                        decoration: InputDecoration(
                          labelText: "Your Email *",
                          hintText: "Your Email *",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Title field cannot be empty";
                          } else {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(value))
                              return 'Please make sure your email address is valid';
                            else
                              return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "First name",
                          hintText: "First name",
                          hintStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        controller: _firstController,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "First name field should not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Last name",
                          hintText: "Last name",
                          hintStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        controller: _lastController,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "First name field should not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "UserName",
                          hintText: "UserName",
                          hintStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        controller: _userNameController,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "UserName field should not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Title",
                          hintText: "Mr, MS, Dr",
                          hintStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        controller: _titleController,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Date field should not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Product ID",
                          hintText: "Product ID",
                          hintStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        controller: _productIDController,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Product ID field should not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Lesson Type ID",
                          hintText: "Lesson Type ID",
                          hintStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        controller: _lessonTypeIDController,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Lesson Type ID field should not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Usual Avaliability",
                          hintText: "Usual Avaliability",
                          hintStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        controller: _usualAvalability,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Usual Avaliability field should not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Pick Up Address",
                          hintText: "Pick Up Address",
                          hintStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        controller: _pickUpAddress,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Pick Up Address field should not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Pick Up Post Code",
                          hintText: "Pick Up Post Code",
                          hintStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        controller: _pickUpPostCode,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Pick Up Post Code field should not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Home Post Code",
                          hintText: "Home Post Code",
                          hintStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        controller: _homePostCode,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Home Post Code field should not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Home Address",
                          hintText: "Home Address",
                          hintStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        controller: _homeAddress,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Home Address field should not be empty";
                          }
                          return null;
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        child: FlatButton(
                          onPressed: () {
                            // TODO: implement validate function

                            validateForm();
                          },
                          child: Text(
                            "Update Data",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          shape: StadiumBorder(),
                          color: Colors.green,
                          splashColor: Colors.indigo,
                          padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width / 8,
                              15,
                              MediaQuery.of(context).size.width / 8,
                              15),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Future<void> validateForm() async {
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      await updatePupil(
          "https://drivinginstructorsdiary.com/app/api/updatePupilApi/" +
              "${widget.pupilID}",
          body: {
            "email": _emailController.text,
            "instructor_id": "1054",
            "product_id": _productIDController.text,
            "lessonType_id": _lessonTypeIDController.text,
            "usual_availability": _usualAvalability.text,
            "pick_up_address": _pickUpAddress.text,
            "pick_up_postcode": _pickUpPostCode.text,
            "home_postcode": _homePostCode.text,
            "home_address": _homeAddress.text,
            "username": _userNameController.text,
            "firstName": _firstController.text,
            "lastName": _lastController.text
          });
      formState.reset();
    }
  }
}
