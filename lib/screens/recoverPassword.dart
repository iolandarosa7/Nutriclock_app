import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/network_utils/api.dart';

class RecoverPassword extends StatefulWidget {
  @override
  _RecoverPasswordState createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  bool _isLoading = false;
  var email;
  var color = Colors.red;
  var message = ERROR_GENERAL_API;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

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
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: Column(
                        children: <Widget>[
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
                                    style: TextStyle(color: Color(0xFF000000)),
                                    cursorColor: Color(0xFF9b9b9b),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFFA3DC92)),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.grey,
                                      ),
                                      hintText: "Preencha o email",
                                      hintStyle: TextStyle(
                                          color: Color(0xFF9b9b9b),
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    validator: (emailValue) {
                                      if (emailValue.isEmpty) {
                                        return ERROR_MANDATORY_FIELD;
                                      }
                                      if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailValue)) {
                                        return ERROR_INVALID_FORMAT_FIELD;
                                      }
                                      email = emailValue;
                                      return null;
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child:
                                    SizedBox(
                                      width: double.infinity,
                                      child: FlatButton(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 8, bottom: 8, left: 10, right: 10),
                                          child: Text(
                                            _isLoading ? 'Aguarde...' : 'Submeter Email',
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
                                            borderRadius: new BorderRadius.circular(20.0)
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState.validate()) {
                                            _forgotPassword();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  
  void _forgotPassword() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      var response = await Network().postWithoutAuth({'email': email}, PASSWORD_URL);

      if (response.statusCode == RESPONSE_SUCCESS_201) {
        message = 'Foi enviado um email para recuperação de password';
        color = Colors.green;
      } else {
        message = ERROR_USER_NOT_FOUND_API;
      }
    } catch (error) {}

    _showMessage(message, color);

    setState(() {
      _isLoading = false;
    });
  }

  _showMessage(String message, Color color) {
    final snackBar = SnackBar(
      backgroundColor: color,
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
