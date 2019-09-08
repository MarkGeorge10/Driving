import 'package:flutter/material.dart';

import '../MyHomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username;
  String password;

  String errorUsernamePassword;
  bool passwordVisibility = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                buildLogo(size),
                Container(
//      padding: EdgeInsets.only(left: 20, right: 15),
                  child: TextFormField(
                    obscureText: false,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: "User Name",
                      hintText: "User Name",
                      hintStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "UserName field cannot be empty";
                      } else {
                        return null;
                      }
                    },
                  ),
                  margin: EdgeInsets.fromLTRB(25, 0, 25, 5.0),
                ),
                Container(
//      padding: EdgeInsets.only(left: 20, right: 15),
                  child: TextFormField(
                    obscureText: !passwordVisibility,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Password",
                      hintStyle: TextStyle(fontSize: 18),
                      suffixIcon: buildEye(passwordVisibility),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "The password field cannot be empty";
                      } else if (value.length < 6) {
                        return "At least 6 characters long";
                      }
                      return null;
                    },
                  ),
                  margin: EdgeInsets.fromLTRB(25, 0, 25, 5.0),
                ),
                buildForgotPassword(),
                buildLoginButton(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLogo(Size size) {
    return Container(
      child: Image.asset(
        "img/logo.png",
        height: size.height / 4,
        width: size.width / 2,
      ),
//      margin: EdgeInsets.all(20),
    );
  }

  Widget buildLoginButton(Size size) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: FlatButton(
        onPressed: () {
          // TODO: implement validate function
//          validate();
          validateForm();
        },
        child: Text(
          "Login",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        shape: StadiumBorder(),
        color: Colors.deepOrange,
        splashColor: Colors.indigo,
        padding: EdgeInsets.fromLTRB(size.width / 8, 15, size.width / 8, 15),
      ),
    );
  }

  Widget buildEye(bool visible) {
    return IconButton(
        icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          setState(() {
            passwordVisibility = !passwordVisibility;
          });
        });
  }

  Widget buildForgotPassword() {
    return Container(
      margin: EdgeInsets.only(left: 45),
      child: Align(
          child: InkWell(
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => forgotPassword(),
          ),
          alignment: Alignment.centerLeft),
    );
  }

  Future<bool> forgotPassword() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('You Really Forgot Your Password?!!!'),
        content: new Text('Are you really that dumb?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
        ],
      ),
    );
  }

  Future<void> validateForm() async {
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      formState.reset();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
          ModalRoute.withName('/LoginPage'));
    }
  }
}
