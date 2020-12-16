import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeEmail extends StatefulWidget {
  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _email;
  var _newEmail;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Alterar Email",
            style: TextStyle(
              fontFamily: 'Pacifico',
            ),
          ),
          backgroundColor: Color(0xFF74D44D),
        ),
        body: _isLoading
            ? Center(
                child: Loading(
                    indicator: BallPulseIndicator(),
                    size: 50.0,
                    color: Colors.orangeAccent),
              )
            : Container(
                child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "A alteração ir-se-á refletir no Email usado para efetuar o Login.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            style: TextStyle(color: Color(0xFF000000)),
                            cursorColor: Color(0xFF9b9b9b),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFA3DC92)),
                              ),
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.grey,
                              ),
                              hintText: "Email atual",
                              labelText: 'Email atual',
                              labelStyle: TextStyle(color: Colors.grey),
                              hintStyle: TextStyle(
                                  color: Color(0xFF9b9b9b),
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return ERROR_MANDATORY_FIELD;
                              }
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return ERROR_INVALID_FORMAT_FIELD;
                              }
                              _email = value;
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            style: TextStyle(color: Color(0xFF000000)),
                            cursorColor: Color(0xFF9b9b9b),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFA3DC92)),
                              ),
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.grey,
                              ),
                              hintText: "Novo email",
                              labelText: 'Novo email',
                              labelStyle: TextStyle(color: Colors.grey),
                              hintStyle: TextStyle(
                                  color: Color(0xFF9b9b9b),
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return ERROR_MANDATORY_FIELD;
                              }
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return ERROR_INVALID_FORMAT_FIELD;
                              }

                              if (value.isNotEmpty && value == _email) {
                                return ERROR_NEW_EMAIL_MUST_NOT_BE_EQUAL;
                              }
                              _newEmail = value;
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: FlatButton(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 8, bottom: 8, left: 10, right: 10),
                                child: Text(
                                  _isLoading ? 'Aguarde...' : 'Alterar Email',
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
                                if (_formKey.currentState.validate()) {
                                  _updateEmail();
                                }
                              },
                            ),
                          ),
                        ],
                      )),
                ),
              )));
  }

  void _updateEmail() async {
    if (_isLoading) return;

    var message = ERROR_GENERAL_API;
    var isShowMessage = false;

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var storeUser = localStorage.getString(LOCAL_STORAGE_USER_KEY);

    if (storeUser == null) return;

    User user = User.fromJson(json.decode(storeUser));

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network().putWithAuth(
          {'email': _email, "newEmail": _newEmail}, EMAIL_URL, user.id);

      var body = json.decode(response.body);

      if (response.statusCode == RESPONSE_SUCCESS) {
        _showMessage("Email atualizada", false);
      } else {
        isShowMessage = true;
        if (body[JSON_ERROR_KEY] != null) message = (body[JSON_ERROR_KEY]);
      }
    } catch (error) {
      isShowMessage = true;
    }

    if (isShowMessage) _showMessage(message, true);

    setState(() {
      _isLoading = false;
    });
  }

  _showMessage(String message, bool isError) {
    final snackBar = SnackBar(
      backgroundColor: isError ? Colors.red : Colors.green,
      content: Text(message),
      action: SnackBarAction(
        label: 'Fechar',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
