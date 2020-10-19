import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Perfil de Utilizador",
            style: TextStyle(
              fontFamily: 'Pacifico',
            ),
          ),
          backgroundColor: Color(0xFF74D44D),
        ),
        body: Center(
          child: Text('Perfil'),
        ));
  }
}
