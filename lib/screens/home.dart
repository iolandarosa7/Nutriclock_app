import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/screens/login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var name = '';

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  _loadUserData() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var storeUser = localStorage.getString(LOCAL_STORAGE_USER_KEY);

    if (storeUser != null) {
      User user = User.fromJson(json.decode(storeUser));
      setState(() {
        name = user.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test App'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Hi, $name',
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
            Center(
              child: RaisedButton(
                elevation: 10,
                onPressed: (){
                  _logout();
                },
                color: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout () async {
    try {
      await Network().getWithAuth(LOGOUT_URL);
    } catch(error) {}

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove(LOCAL_STORAGE_USER_KEY);
    localStorage.remove(LOCAL_STORAGE_TOKEN_KEY);

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => Login()));
  }
}
