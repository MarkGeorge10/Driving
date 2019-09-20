import 'dart:convert';

import 'package:http/http.dart' as http;

class API {
  List<dynamic> pupilItem;

  Future<List<dynamic>> fetchMsg(String url) async {
    //print(body);

    try {
      return http.post(url).then((http.Response response) async {
        final String responseBody = response.body;
        pupilItem = json.decode(responseBody)["data"]["data"];
        print(pupilItem.length);

        return pupilItem;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }
}
