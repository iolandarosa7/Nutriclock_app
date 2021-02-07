import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class AppWidget {
  getLoading() {
    return Center(
      child: Loading(
          indicator: BallPulseIndicator(),
          size: 50.0,
          color: Color(0xFFFFBCBC)),
    );
  }

  getImageContainer(String src, bool isLoading, Widget child) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(src),
          fit: BoxFit.cover,
        ),
      ),
      child: isLoading ? getLoading() : child,
    );
  }

  showSnackbar(
      String message, Color color, GlobalKey<ScaffoldState> scaffoldKey) {
    final snackBar = SnackBar(
      backgroundColor: color,
      content: Text(message),
      action: SnackBarAction(
        label: 'Fechar',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  getAppbar(String title) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Pacifico',
        ),
      ),
      backgroundColor: Color(0xFFA3E1CB),
    );
  }
}
