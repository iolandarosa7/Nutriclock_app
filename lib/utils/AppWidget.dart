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

  getParsedMonths(value) {
    switch (value) {
      case '1':
      case '01':
        return 'Janeiro';
      case '2':
      case '02':
        return 'Fevereiro';
      case '3':
      case '03':
        return 'Março';
      case '4':
      case '04':
        return 'Abril';
      case '5':
      case '05':
        return 'Maio';
      case '6':
      case '06':
        return 'Junho';
      case '7':
      case '07':
        return 'Julho';
      case '8':
      case '08':
        return 'Agosto';
      case '9':
      case '09':
        return 'Setembro';
      case '10':
        return 'Outobro';
      case '11':
        return 'Novembro';
      case '12':
        return 'Dezembro';
      default:
        return '';
    }
  }
}
