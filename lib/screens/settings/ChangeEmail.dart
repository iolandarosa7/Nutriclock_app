import 'package:flutter/material.dart';

class ChangeEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Alterar Email",
            style: TextStyle(
              fontFamily: 'Pacifico',
            ),
          ),
          backgroundColor: Color(0xFF74D44D),
        ),
        body: Center(
          child: Text('Alterar Email'),
        ));
  }
}
