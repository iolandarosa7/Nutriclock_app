import 'package:flutter/material.dart';
import 'package:nutriclock_app/screens/settings/ChangeEmail.dart';
import 'package:nutriclock_app/screens/settings/ChangePassword.dart';
import 'package:nutriclock_app/screens/settings/Profile.dart';

class SettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Definições",
            style: TextStyle(
              fontFamily: 'Pacifico',
            ),
          ),
          backgroundColor: Color(0xFF74D44D),
        ),
        body: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                "Perfil",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Roboto',
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text(
                "Alterar Password",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Roboto',
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChangePassword()));
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(
                "Alterar Email",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Roboto',
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChangeEmail()));
              },
            )
          ],
        ));
  }
}
