import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';
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
  var appWidget = AppWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appWidget.getAppbar("Alterar Email"),
      body: appWidget.getImageContainer(
        "assets/images/bg_green_gradient.png",
        _isLoading,
        Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(right: 24, bottom: 16),
                child: Image.asset(
                  'assets/images/email.png',
                  height: MediaQuery.of(context).size.height / 4,
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
                                        children: <Widget>[
                                          Text(
                                            "A alteração irá refletir-se no Email usado para efetuar o Login.",
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
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFA3E1CB)),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.mail,
                                                color: Color(0xFFA3E1CB),
                                              ),
                                              labelText: 'Email atual',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              hintStyle: TextStyle(
                                                  color: Color(0xFF9b9b9b),
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal),
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
                                            style: TextStyle(
                                                color: Color(0xFF000000)),
                                            cursorColor: Color(0xFF9b9b9b),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFA3E1CB)),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.mail,
                                                color: Color(0xFFA3E1CB),
                                              ),
                                              labelText: 'Novo email',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              hintStyle: TextStyle(
                                                  color: Color(0xFF9b9b9b),
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal),
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

                                              if (value.isNotEmpty &&
                                                  value == _email) {
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
                                            child: TextButton(
                                              child: Text(
                                                _isLoading
                                                    ? 'Aguarde...'
                                                    : 'Alterar Email',
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.0,
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFFA3E1CB),
                                                shape:
                                                    new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  _updateEmail();
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
                            ),
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
        appWidget.showSnackbar("Email atualizada", Colors.green, _scaffoldKey);
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
