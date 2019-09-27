import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class API {
  List<dynamic> pupilItem;
  List<dynamic> msgItem;

  Future<List<dynamic>> fetchPupil(String url) async {
    //print(body);

    try {
      return http.post(url).then((http.Response response) async {
        final String responseBody = response.body;
        pupilItem = json.decode(responseBody)["data"]["data"];
        print(pupilItem);

        return pupilItem;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  Future<List<dynamic>> fetchMsg(String url) async {
    print(url);

    try {
      return http.post(url).then((http.Response response) async {
        final String responseBody = response.body;
        msgItem = json.decode(responseBody)["data"]["data"];
        print(msgItem.length);

        return msgItem;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dat = prefs.get("idPref");

    return dat;
  }

  List<dynamic> bookingItems;
  Future<List<dynamic>> fetchBooking(String url) async {
    print(url);

    try {
      return http.post(url).then((http.Response response) async {
        final String responseBody = response.body;
        bookingItems = json.decode(responseBody)["bookings"];

        print("mark");
        print(bookingItems);

        return bookingItems;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");

    return null;
  }
}
