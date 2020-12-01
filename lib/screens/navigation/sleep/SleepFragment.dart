import 'package:flutter/material.dart';
import 'package:nutriclock_app/screens/navigation/sleep/SleepCalendarFragment.dart';

import 'SleepStatsFragment.dart';

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
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SleepCalendarFragment()),
                      );
                    },
                    child: Text(
                      "Diário do Sono",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SleepCalendarFragment()),
                      );
                    },
                    child: ClipRect(
                      child: Image.asset(
                        "assets/images/pillow.png",
                        fit: BoxFit.cover,
                        height: 120,
                      ),
                    ),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SleepStatsFragment()),
                      );
                    },
                    child: Text(
                      "Estatísticas",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SleepStatsFragment()),
                      );
                    },
                    child: ClipRect(
                      child: Image.asset(
                        "assets/images/stats.png",
                        fit: BoxFit.cover,
                        height: 100,
                      ),
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
                      height: 120,
                    ),
                  ),
                  SizedBox(
                    height: 68,
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
