import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:driving_instructor/PupilPackage/API.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTransaction extends StatefulWidget {
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _dateController = new TextEditingController();
  TextEditingController _hoursController = new TextEditingController();
  TextEditingController _amountController = new TextEditingController();
  TextEditingController _pupilIDController = new TextEditingController();

  TextEditingController _noteController = new TextEditingController();

  List paymentMethod = [
    "Bank Transfer",
    "Cash",
    "Cheque",
    "Credit Card",
    "Debit Card",
    "Diredct Debit",
    "Paypal",
    "Standing Order",
  ];

  List status = [
    "Recieved",
    "Paid",
  ];

  List types = [
    "Accountancy & Legal",
    "Adverstising",
    "Bank Interest",
    "Computer Equipment",
    "Finance Charges",
    "Franchise / Car Rental",
    "Fuel",
    "Home Office",
    "Miscellaneous",
    "Motor Expenses",
    "Stationary & Postage",
    "Pupil Lessons Fees",
    "Pupil Test Fees",
    "Pupil Training Materials",
    "Subsistence",
    "Telephone & Internet",
    "Trade Subscription",
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _category;
  int indexCategory;

  List<DropdownMenuItem<String>> _dropDownMenuPaymentItems;
  String _payment;

  List<DropdownMenuItem<String>> _dropDownMenuStatusItems;
  String _stat;

  List<DropdownMenuItem<String>> _dropDownMenuPupilItems;
  String pupilItemstr;
  final dateFormat = DateFormat("dd/MM/yyyy");
  DateTime date;

  API api = new API();

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _dropDownMenuPaymentItems = getDropDownPaymentMenuItems();
    _dropDownMenuStatusItems = getDropDownStatusMenuItems();
    _category = _dropDownMenuItems[0].value;
    _payment = _dropDownMenuPaymentItems[0].value;

    _stat = _dropDownMenuStatusItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < types.length; i++) {
      String city = types[i];
      String index = "${i + 1}";
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(value: index, child: new Text(city)));
    }

    return items;
  }

  List<DropdownMenuItem<String>> getDropDownPaymentMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in paymentMethod) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }

    return items;
  }

  List<DropdownMenuItem<String>> getDropDownStatusMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in status) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }

    return items;
  }

  void changedDropDownItem(String selectedCity) {
    print("Selected city $selectedCity, we are going to refresh the UI");
    setState(() {
      _category = selectedCity;
    });
  }

  void changedDropDownPaymentItem(String selectedCity) {
    print("Selected city $selectedCity, we are going to refresh the UI");
    setState(() {
      _payment = selectedCity;
    });
  }

  void changedDropDownStatusItem(String selectedCity) {
    print("Selected city $selectedCity, we are going to refresh the UI");
    setState(() {
      _stat = selectedCity;
    });
  }

  Future<void> createTransaction(String url, {Map body}) async {
    print("mark");
    print(body);

    try {
      return http.post(url, body: body).then((http.Response response) async {
        final String responseBody = response.body;
        String jsondecode = json.decode(responseBody)["message"];
        _showDialog(jsondecode);
      });
    } catch (ex) {
      _showDialog("Something happened errored");
    }
    _showDialog("Something happened errored");
    return null;
  }

  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dat = prefs.get("idPref");

    return dat;
  }

  void _showDialog(String str) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          //title: new Text("Alert Dialog title"),
          content: new Text(str),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new transaction"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getID(),
          builder: (context, snap) {
            if (snap.hasData) {
              return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    DateTimeField(
                      format: dateFormat,
                      controller: _dateController,
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                      decoration: InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Hours",
                        hintText: "Hours",
                        hintStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      controller: _hoursController,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: "Amount",
                        hintText: "Amount",
                        hintStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Amount field should not be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    ListTile(
                      title: Text(
                        "Status",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: new DropdownButton(
                        value: _stat,
                        items: _dropDownMenuStatusItems,
                        onChanged: changedDropDownStatusItem,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    ListTile(
                      title: Text(
                        "Type",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: new DropdownButton(
                        value: _category,
                        items: _dropDownMenuItems,
                        onChanged: changedDropDownItem,
                      ),
                    ),
                    _category == "12" || _category == "13"
                        ? FutureBuilder(
                            future: api.fetchMsg(
                                "https://drivinginstructorsdiary.com/app/api/viewPupilApi/active?instructor_id=${snap.data}"),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                Map<String, String> items = new Map();
                                List<DropdownMenuItem<String>> itemsDrop =
                                    new List();

                                for (int i = 0; i < snapshot.data.length; i++) {
                                  String pupil = snapshot.data[i]
                                          ["first_name"] +
                                      " " +
                                      snapshot.data[i]["last_name"];
                                  String pupilID = snapshot.data[i]["id"];
                                  // here we are creating the drop down menu items, you can customize the item right here
                                  // but I'll just use a simple text for this
                                  items.addAll({'name': pupil, 'ID': pupilID});
                                  itemsDrop.add(new DropdownMenuItem(
                                      value: items['ID'],
                                      child: new Text(items['name'])));
                                }

                                void changedDropDownPupilItem(
                                    String selectedCity) {
                                  print(
                                      "Selected city $selectedCity, we are going to refresh the UI");
                                  setState(() {
                                    pupilItemstr = selectedCity;
                                  });
                                }

                                return ListTile(
                                  title: Text(
                                    "Pupil ID",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: new DropdownButton(
                                    value: pupilItemstr,
                                    items: itemsDrop,
                                    onChanged: changedDropDownPupilItem,
                                  ),
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height / 40,
                          ),
                    ListTile(
                      title: Text(
                        "Payment Method",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: new DropdownButton(
                        value: _payment,
                        items: _dropDownMenuPaymentItems,
                        onChanged: changedDropDownPaymentItem,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _noteController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: "Notes",
                        hintText: "Notes",
                        hintStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: FlatButton(
                        onPressed: () {
                          // TODO: implement validate function

                          validateForm(
                              "https://drivinginstructorsdiary.com/app/api/insertTransactionApi?instructor_id=" +
                                  "${snap.data}");
                        },
                        child: Text(
                          "Add Transaction",
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
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Future<void> validateForm(String url) async {
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      await createTransaction(url, body: {
        "client_id": "4",
        "pupil_id": pupilItemstr,
        "date": _dateController.text.substring(0, 9),
        "amount": _amountController.text,
        "hours": _hoursController.text,
        "type": _category.toString(),
        "payment_method": _payment.toString(),
        "status": _stat.toString(),
        "note": _noteController.text
      });
      formState.reset();
    }
  }
}
