import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/AcceptanceTerms.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/screens/home.dart';
import 'package:nutriclock_app/screens/recoverPassword.dart';
import 'package:nutriclock_app/screens/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  var email;
  var password;
  AcceptanceTerms terms;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _loadDataFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                        elevation: 4.0,
                        color: Colors.white,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ClipRect(
                                      child: Image.asset(
                                        "assets/images/logo.png",
                                        height: 40,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    TextFormField(
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFA3DC92)),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Colors.grey,
                                        ),
                                        hintText: "Email",
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (emailValue) {
                                        if (emailValue.isEmpty) {
                                          return ERROR_MANDATORY_FIELD;
                                        }
                                        if (!RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(emailValue)) {
                                          return ERROR_INVALID_FORMAT_FIELD;
                                        }
                                        email = emailValue;
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFA3DC92)),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.vpn_key,
                                          color: Colors.grey,
                                        ),
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (passwordValue) {
                                        if (passwordValue.isEmpty) {
                                          return ERROR_MANDATORY_FIELD;
                                        }
                                        password = passwordValue;
                                        return null;
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: FlatButton(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                left: 10,
                                                right: 10),
                                            child: Text(
                                              _isLoading
                                                  ? 'Aguarde...'
                                                  : 'Login',
                                              textDirection: TextDirection.ltr,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0,
                                                decoration: TextDecoration.none,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          color: Color(0xFFA3DC92),
                                          disabledColor: Colors.grey,
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20.0)),
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _login();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: FlatButton(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    child: Text(
                                      _isLoading ? 'Aguarde...' : 'Nova Conta',
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  color: Color(0xFFA3DC92),
                                  disabledColor: Colors.grey,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0)),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) => Register()));
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, bottom: 20.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              RecoverPassword()));
                                },
                                child: Text(
                                  'Recuperar Password',
                                  style: TextStyle(
                                    color: Color(0xFF74D44D),
                                    fontSize: 15.0,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _login() async {
    if (_isLoading) return;

    var message = ERROR_GENERAL_API;
    var isShowMessage = false;

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network()
          .postWithoutAuth({'email': email, 'password': password}, LOGIN_URL);
      var body = json.decode(response.body);

      if (response.statusCode == RESPONSE_SUCCESS) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString(
            LOCAL_STORAGE_TOKEN_KEY, json.encode(body[JSON_ACCESS_TOKEN_KEY]));
        response = await Network().getWithAuth(USERS_ME_URL);
        if (response.statusCode == RESPONSE_SUCCESS) {
          var data = json.decode(response.body)[JSON_DATA_KEY];
          localStorage.setString(LOCAL_STORAGE_USER_KEY, json.encode(data));

          if (data[JSON_ROLE_KEY] == 'PATIENT') {
            if (data[JSON_ACCEPT_TERMS_KEY] == 0) {
              print(data[JSON_ID_KEY]);
              _showAcceptanceTermsModal(data[JSON_ID_KEY]);
            } else {
              Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
            }
          } else {
            message = 'Apenas utentes podem usar a aplicação';
            isShowMessage = true;
          }
        } else {
          isShowMessage = true;
          if (body[JSON_ERROR_KEY] != null) message = body[JSON_ERROR_KEY];
        }
      } else {
        isShowMessage = true;
        if (body[JSON_ERROR_KEY] != null) message = (body[JSON_ERROR_KEY]);
      }
    } catch (error) {
      isShowMessage = true;
    }

    if (isShowMessage) _showMessage(message);

    setState(() {
      _isLoading = false;
    });
  }

  _showMessage(String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(message),
      action: SnackBarAction(
        label: 'Fechar',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<void> _showAcceptanceTermsModal(int id) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(this.terms.title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    this.terms.description,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Aceito os Termos e Condições'),
                onPressed: () {
                  Navigator.of(context).pop();
                  this._updateTermsAndConditions(id);
                },
              ),
            ],
          );
        });
  }

  void _updateTermsAndConditions(int id) async {
    if (_isLoading) return;

    this.setState(() {
      _isLoading = true;
    });

    try {
      await Network()
          .putWithAuth({'terms_accepted': '1'}, "$USER_TERMS_URL/$id", null);

      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } catch (error) {
      print('catch $error');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _loadDataFromServer() async {
    if (_isLoading) return;

    this.setState(() {
      _isLoading = true;
    });

    var message = ERROR_GENERAL_API;
    var isShowMessage = false;

    try {
      var responseTerms = await Network().getWithoutAuth(TERMS_URL);

      if (responseTerms.statusCode == RESPONSE_SUCCESS) {
        var data = AcceptanceTerms.fromJson(
            json.decode(responseTerms.body)[JSON_DATA_KEY]);

        this.setState(() {
          terms = data;
        });
      } else {
        isShowMessage = true;
      }
    } catch (error) {
      print('catch $error');
      isShowMessage = true;
    }

    if (isShowMessage) _showMessage(message);

    setState(() {
      _isLoading = false;
    });
  }
}
