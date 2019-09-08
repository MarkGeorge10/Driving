import 'package:flutter/material.dart';

class Pupils extends StatefulWidget {
  @override
  _PupilsState createState() => _PupilsState();
}

class _PupilsState extends State<Pupils> {
  final TextEditingController _searchControl = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: TextField(
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: "Search..",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                suffixIcon: Icon(
                  Icons.filter_list,
                  color: Colors.black,
                ),
                hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
              maxLines: 1,
              controller: _searchControl,
            ),
          ),
        ),
        body: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                elevation: 10.0,
                child: ListTile(
                  leading: Container(
                    child: Icon(
                      Icons.account_circle,
                      size: 50.0,
                    ),
                  ),
                  title: Text("First Name" + " Last Name"),
                  subtitle: Text("Email"),
                ),
              );
            }));
  }
}
