import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';

class RecoverPassword extends StatefulWidget {
  @override
  _RecoverPasswordState createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  bool _isLoading = false;
  var appWidget = AppWidget();
  var email;
  var message = ERROR_GENERAL_API;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: appWidget.getImageContainer(
        "assets/images/bg_green.png",
        _isLoading,
        Stack(
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
                          borderRadius: BorderRadius.circular(15.0)),
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
                                      labelText: 'Email',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFA3E1CB)),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Color(0xFFA3E1CB),
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
                                      if (!RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(emailValue)) {
                                        return ERROR_INVALID_FORMAT_FIELD;
                                      }
                                      email = emailValue;
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
                                                : 'Submeter Email',
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                              decoration: TextDecoration.none,
                                              fontWeight: FontWeight.normal,
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
    var hasError = false;
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var response =
          await Network().postWithoutAuth({'email': email}, PASSWORD_URL);

      if (response.statusCode == RESPONSE_SUCCESS_201) {
        appWidget.showSnackbar(
            'Foi enviado um email para recuperação de password',
            Colors.green,
            _scaffoldKey);
      } else {
        hasError = true;
        message = ERROR_USER_NOT_FOUND_API;
      }
    } catch (error) {
      hasError = true;
    }

    if (hasError) appWidget.showSnackbar(message, Colors.red, _scaffoldKey);

    setState(() {
      _isLoading = false;
    });
  }
}
