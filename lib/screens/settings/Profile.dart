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
          backgroundColor: Color(0xFFA3E1CB),
        ),
        body: Center(
          child: Text('Perfil'),
        ));
  }
}
