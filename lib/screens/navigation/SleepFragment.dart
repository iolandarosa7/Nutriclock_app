import 'package:flutter/material.dart';

class SleepFragment extends StatefulWidget {
  @override
  _SleepFragmentState createState() => _SleepFragmentState();
}

class _SleepFragmentState extends State<SleepFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x8074D44D), Color(0x20FFFFFF)]),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Horas de Sono",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ClipRect(
                    child: Image.asset(
                      "assets/images/pillow.png",
                      fit: BoxFit.cover,
                      height: 150,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x20FFFFFF), Color(0x80A8DFFE)]),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Estatisticas",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ClipRect(
                    child: Image.asset(
                      "assets/images/stats.png",
                      fit: BoxFit.cover,
                      height: 150,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x80A8DFFE), Color(0x4074D44D)]),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Dicas",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ClipRect(
                    child: Image.asset(
                      "assets/images/tips.png",
                      fit: BoxFit.cover,
                      height: 150,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

/*

 */
