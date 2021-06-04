import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _password;
  var _confirmationPassword;
  var _newPassword;
  var _isLoading = false;
  var appWidget = AppWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appWidget.getAppbar("Alterar Password"),
      body: appWidget.getImageContainer(
        "assets/images/bg_green_gradient.png",
        _isLoading,
        Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(right: 25, bottom: 16),
                child: Image.asset(
                  'assets/images/password.png',
                  height: MediaQuery.of(context).size.height / 5,
                ),
              ),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Stack(
                  children: [
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Card(
                              elevation: 4.0,
                              color: Colors.white,
                              margin: EdgeInsets.only(left: 20, right: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Image(
                                    image:
                                        AssetImage("assets/images/nutri.png"),
                                    height: 45,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Esta password será utilizada durante a autenticação. A sua alteração ir-se-á refletir no Login.",
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
                                            style: TextStyle(
                                                color: Color(0xFF000000)),
                                            cursorColor: Color(0xFF9b9b9b),
                                            keyboardType: TextInputType.text,
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFA3E1CB)),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.vpn_key,
                                                color: Color(0xFFA3E1CB),
                                              ),
                                              labelText: 'Password atual',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              hintStyle: TextStyle(
                                                  color: Color(0xFF9b9b9b),
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            validator: (passwordValue) {
                                              if (passwordValue.isEmpty) {
                                                return ERROR_MANDATORY_FIELD;
                                              }
                                              _password = passwordValue;
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          TextFormField(
                                            style: TextStyle(
                                                color: Color(0xFF000000)),
                                            cursorColor: Color(0xFF9b9b9b),
                                            keyboardType: TextInputType.text,
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFA3E1CB)),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.vpn_key,
                                                color: Color(0xFFA3E1CB),
                                              ),
                                              labelText: 'Nova password',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              hintStyle: TextStyle(
                                                  color: Color(0xFF9b9b9b),
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            validator: (passwordValue) {
                                              if (passwordValue.isEmpty) {
                                                return ERROR_MANDATORY_FIELD;
                                              }

                                              if (passwordValue.isNotEmpty &&
                                                  passwordValue == _password) {
                                                return ERROR_NEW_PASS_MUST_NOT_BE_EQUAL;
                                              }
                                              _newPassword = passwordValue;
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          TextFormField(
                                            style: TextStyle(
                                                color: Color(0xFF000000)),
                                            cursorColor: Color(0xFF9b9b9b),
                                            keyboardType: TextInputType.text,
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFA3E1CB)),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.vpn_key,
                                                color: Color(0xFFA3E1CB),
                                              ),
                                              labelText:
                                                  'Confirmação de password',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              hintStyle: TextStyle(
                                                  color: Color(0xFF9b9b9b),
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            validator: (passwordValue) {
                                              if (passwordValue.isEmpty) {
                                                return ERROR_MANDATORY_FIELD;
                                              }

                                              if (passwordValue.isNotEmpty &&
                                                  passwordValue !=
                                                      _newPassword) {
                                                return ERROR_CONFIRMATION_PASS_MUST_BE_EQUAL;
                                              }
                                              _confirmationPassword =
                                                  passwordValue;
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
                                                    top: 8,
                                                    bottom: 8,
                                                    left: 10,
                                                    right: 10),
                                                child: Text(
                                                  _isLoading
                                                      ? 'Aguarde...'
                                                      : 'Alterar Password',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.0,
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              color: Color(0xFFA3E1CB),
                                              disabledColor: Colors.grey,
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          20.0)),
                                              onPressed: () {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  _updatePassword();
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updatePassword() async {
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
          {'password': _password, "newPassword": _newPassword},
          PASSWORD_URL,
          user.id);

      var body = json.decode(response.body);

      if (response.statusCode == RESPONSE_SUCCESS) {
        appWidget.showSnackbar(
            "Password atualizada", Colors.green, _scaffoldKey);
      } else {
        isShowMessage = true;
        if (body[JSON_ERROR_KEY] != null) message = (body[JSON_ERROR_KEY]);
      }
    } catch (error) {
      isShowMessage = true;
    }

    if (isShowMessage)
      appWidget.showSnackbar(message, Colors.red, _scaffoldKey);

    setState(() {
      _isLoading = false;
    });
  }
}
