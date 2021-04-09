import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/screens/login.dart';
import 'package:nutriclock_app/screens/settings/ChangeEmail.dart';
import 'package:nutriclock_app/screens/settings/ChangePassword.dart';
import 'package:nutriclock_app/screens/settings/Notifications.dart';
import 'package:nutriclock_app/screens/settings/Profile.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsList extends StatefulWidget {
  @override
  _SettingsListState createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _appWidget = AppWidget();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appWidget.getAppbar("Definições"),
      body: _isLoading
          ? _appWidget.getLoading(Color(0xFFFFBCBC))
          : ListView(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Color(0xFF60B2A3),
                  ),
                  title: Text(
                    "Perfil",
                    style: TextStyle(
                      color: Color(0xFF60B2A3),
                      fontFamily: 'Roboto',
                    ),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: Color(0xFF60B2A3)),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Profile()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock, color: Color(0xFF60B2A3)),
                  title: Text(
                    "Alterar Password",
                    style: TextStyle(
                      color: Color(0xFF60B2A3),
                      fontFamily: 'Roboto',
                    ),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: Color(0xFF60B2A3)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChangePassword()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.email, color: Color(0xFF60B2A3)),
                  title: Text(
                    "Alterar Email",
                    style: TextStyle(
                      color: Color(0xFF60B2A3),
                      fontFamily: 'Roboto',
                    ),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: Color(0xFF60B2A3)),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ChangeEmail()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notification_important,
                      color: Color(0xFF60B2A3)),
                  title: Text(
                    "Notificações",
                    style: TextStyle(
                      color: Color(0xFF60B2A3),
                      fontFamily: 'Roboto',
                    ),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: Color(0xFF60B2A3)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NotificationsFragment()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.do_disturb_on_rounded,
                      color: Color(0xFFADADAD)),
                  title: Text(
                    "Esquecer os meus dados",
                    style: TextStyle(
                      color: Color(0xFFADADAD),
                      fontFamily: 'Roboto',
                    ),
                  ),
                  onTap: _showForgetDataModal,
                ),
              ],
            ),
    );
  }

  Future<void> _showForgetDataModal() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Tem a certeza que pretende deixar de participar no estudo Nutriclock?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF60B2A3),
                fontFamily: 'Roboto',
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    "A confirmação do esquecimento dos seus dados implica o cancelamento da sua participação no estudo Nutriclock, a remoção da sua conta e a eliminação dos seus dados da base de dados.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _forgetMeRequest();
                },
                child: Text("Confirmar"),
              ),
            ],
          );
        });
  }

  _forgetMeRequest() async {
    this.setState(() {
      _isLoading = true;
    });
    try {
      var response = await Network().getWithAuth(FORGOT_ME);

      if (response.statusCode == RESPONSE_SUCCESS) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.clear();
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
      }
    } catch (error) {
      _showMessage("Ocorreu um erro durante o pedido", Colors.red);
    } finally {
      this.setState(() {
        _isLoading = true;
      });
    }
  }

  _showMessage(message, color) {
    _appWidget.showSnackbar(message, color, _scaffoldKey);
  }
}
