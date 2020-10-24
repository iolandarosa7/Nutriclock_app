import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x8074D44D), Color(0x20FFFFFF)]),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  ClipRect(
                    child: Image.asset(
                      "assets/images/header.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Diário de Refeições",
                          style: TextStyle(
                              color: Color(0x9074D44D),
                              fontFamily: 'Pacifico',
                              fontSize: 16),
                        ),
                        Text(
                          "Ainda não há progresso para mostrar!",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Sono",
                          style: TextStyle(
                              color: Color(0x9074D44D),
                              fontFamily: 'Pacifico',
                              fontSize: 16),
                        ),
                        Text(
                          "Ainda não há progresso para mostrar!",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Exercicio",
                          style: TextStyle(
                              color: Color(0x9074D44D),
                              fontFamily: 'Pacifico',
                              fontSize: 16),
                        ),
                        Text(
                          "Ainda não há progresso para mostrar!",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
