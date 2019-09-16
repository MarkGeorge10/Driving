import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddTransaction extends StatefulWidget {
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _dateController = new TextEditingController();
  TextEditingController _hoursController = new TextEditingController();
  TextEditingController _clientIdController = new TextEditingController();
  TextEditingController _amountController = new TextEditingController();

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

  List<DropdownMenuItem<String>> _dropDownMenuPaymentItems;
  String _payment;

  List<DropdownMenuItem<String>> _dropDownMenuStatusItems;
  String _stat;

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
    for (String city in types) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
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
        String jsondecode = json.decode(responseBody);
        print(json.decode(responseBody));
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
                    TextFormField(
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: "Client ID",
                        hintText: "Client ID",
                        hintStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      controller: _clientIdController,
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Client ID field should not be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: "Date",
                        hintText: "1/2/2019",
                        hintStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      controller: _dateController,
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
                    SizedBox(
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
        "client_id": _clientIdController.text,
        "date": _dateController.text,
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
