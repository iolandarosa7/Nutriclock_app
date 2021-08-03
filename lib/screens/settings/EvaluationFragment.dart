import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';

import '../home.dart';

class EvaluationFragment extends StatefulWidget {
  const EvaluationFragment({Key key}) : super(key: key);

  @override
  _EvaluationFragmentState createState() => _EvaluationFragmentState();
}

class _EvaluationFragmentState extends State<EvaluationFragment> {
  var appWidget = AppWidget();
  var _isInfoShow = false;
  var _isLoading = false;
  var _question1 = 0;
  var _question2 = 0;
  var _question3 = 0;
  var _question4 = 0;
  var _question5 = 0;
  var _question6 = 0;
  var _question7 = 0;
  var _question8 = 0;
  var _question9 = 0;
  var _question10 = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appWidget.getAppbar("Avaliação"),
      body: appWidget.getImageContainer(
        "assets/images/bg_green_gradient.png",
        _isLoading,
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _onInfoClick,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(
                            4.0)), //             <--- BoxDecoration here
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.grey,
                          size: 16,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            "Ver níveis de classificação",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "1. Considero a app Nutriclock fácil de usar?",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 1, 2, 3, 4, 5]
                      .map((item) => GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 4, right: 8, left: 8, bottom: 16),
                              child: Image.asset(
                                _question1 == item
                                    ? 'assets/images/likert${item}_selected.png'
                                    : 'assets/images/likert$item.png',
                                width: 30,
                              ),
                            ),
                            onTap: () {
                              this.setState(() {
                                _question1 = item;
                              });
                            },
                          ))
                      .toList(),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "2. Tive de aprender muito de forma a conseguir usar a app Nutriclock?",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 1, 2, 3, 4, 5]
                      .map((item) => GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 4, right: 8, left: 8, bottom: 16),
                              child: Image.asset(
                                _question2 == item
                                    ? 'assets/images/likert${item}_selected.png'
                                    : 'assets/images/likert$item.png',
                                width: 30,
                              ),
                            ),
                            onTap: () {
                              this.setState(() {
                                _question2 = item;
                              });
                            },
                          ))
                      .toList(),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "3.Fui capaz de registar a informação necessária através da app Nutriclock?",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 1, 2, 3, 4, 5]
                      .map((item) => GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 4, right: 8, left: 8, bottom: 16),
                              child: Image.asset(
                                _question3 == item
                                    ? 'assets/images/likert${item}_selected.png'
                                    : 'assets/images/likert$item.png',
                                width: 30,
                              ),
                            ),
                            onTap: () {
                              this.setState(() {
                                _question3 = item;
                              });
                            },
                          ))
                      .toList(),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "4. Achei que a app Nutriclock não tinha inconsistências?",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 1, 2, 3, 4, 5]
                      .map((item) => GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 4, right: 8, left: 8, bottom: 16),
                              child: Image.asset(
                                _question4 == item
                                    ? 'assets/images/likert${item}_selected.png'
                                    : 'assets/images/likert$item.png',
                                width: 30,
                              ),
                            ),
                            onTap: () {
                              this.setState(() {
                                _question4 = item;
                              });
                            },
                          ))
                      .toList(),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "5. A organização das informações/menus da app Nutriclock foi clara?",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 1, 2, 3, 4, 5]
                      .map((item) => GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 4, right: 8, left: 8, bottom: 16),
                              child: Image.asset(
                                _question5 == item
                                    ? 'assets/images/likert${item}_selected.png'
                                    : 'assets/images/likert$item.png',
                                width: 30,
                              ),
                            ),
                            onTap: () {
                              this.setState(() {
                                _question5 = item;
                              });
                            },
                          ))
                      .toList(),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 4, right: 8, left: 8, bottom: 16),
                  child: Text(
                    "6. De um modo geral, estou satisfeito/a com a app Nutriclock?",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 1, 2, 3, 4, 5]
                      .map((item) => GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 4, right: 8, left: 8, bottom: 16),
                              child: Image.asset(
                                _question6 == item
                                    ? 'assets/images/likert${item}_selected.png'
                                    : 'assets/images/likert$item.png',
                                width: 30,
                              ),
                            ),
                            onTap: () {
                              this.setState(() {
                                _question6 = item;
                              });
                            },
                          ))
                      .toList(),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "7. Considero que que houve profissionais disponíveis para me ajudar quando tive dificuldades ao usar app Nutriclock?",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 1, 2, 3, 4, 5]
                      .map((item) => GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 4, right: 8, left: 8, bottom: 16),
                              child: Image.asset(
                                _question7 == item
                                    ? 'assets/images/likert${item}_selected.png'
                                    : 'assets/images/likert$item.png',
                                width: 30,
                              ),
                            ),
                            onTap: () {
                              this.setState(() {
                                _question7 = item;
                              });
                            },
                          ))
                      .toList(),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "8. As instruções de utilização da app Nutriclock são claras e detalhadas?",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 1, 2, 3, 4, 5]
                      .map((item) => GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 4, right: 8, left: 8, bottom: 16),
                              child: Image.asset(
                                _question8 == item
                                    ? 'assets/images/likert${item}_selected.png'
                                    : 'assets/images/likert$item.png',
                                width: 30,
                              ),
                            ),
                            onTap: () {
                              this.setState(() {
                                _question8 = item;
                              });
                            },
                          ))
                      .toList(),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "9. Em geral, penso que as aplicações de saúde podem ser úteis?",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 1, 2, 3, 4, 5]
                      .map((item) => GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 4, right: 8, left: 8, bottom: 16),
                              child: Image.asset(
                                _question9 == item
                                    ? 'assets/images/likert${item}_selected.png'
                                    : 'assets/images/likert$item.png',
                                width: 30,
                              ),
                            ),
                            onTap: () {
                              this.setState(() {
                                _question9 = item;
                              });
                            },
                          ))
                      .toList(),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "10. Tenciono continuar a usar aplicações de saúde no futuro?",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 1, 2, 3, 4, 5]
                      .map((item) => GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 4, right: 8, left: 8, bottom: 16),
                              child: Image.asset(
                                _question10 == item
                                    ? 'assets/images/likert${item}_selected.png'
                                    : 'assets/images/likert$item.png',
                                width: 30,
                              ),
                            ),
                            onTap: () {
                              this.setState(() {
                                _question10 = item;
                              });
                            },
                          ))
                      .toList(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 10, right: 10),
                        child: Text(
                          _isLoading ? 'Aguarde...' : 'Submeter Avaliação',
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
                          borderRadius: new BorderRadius.circular(20.0)),
                      onPressed: _submitForm,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_isLoading) return;
    var message = "Ocorreu um erro na submissão. Por favor tente novamente.";
    var hasError = false;

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network().postWithAuth({
        'question1': _question1,
        'question2': _question2,
        'question3': _question3,
        'question4': _question4,
        'question5': _question5,
        'question6': _question6,
        'question7': _question7,
        'question8': _question8,
        'question9': _question9,
        'question10': _question10,
      }, EVALUATION_URL);

      var body = json.decode(response.body);

      if (response.statusCode == RESPONSE_SUCCESS_201) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      } else {
        if (body[JSON_ERROR_KEY] != null) message = body[JSON_ERROR_KEY];
        hasError = true;
      }
    } catch (error) {
      hasError = true;
    }

    setState(() {
      _isLoading = false;
    });

    if (hasError) appWidget.showSnackbar(message, Colors.red, _scaffoldKey);
  }

  Future<void> _onInfoClick() async {
    if (_isInfoShow) return;
    this.setState(() {
      _isInfoShow = true;
    });

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Níveis de classificação",
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Column(
                    children: [
                      _renderInfoRow('assets/images/likert1_selected.png',
                          "Discordo Totalmente"),
                      _renderInfoRow(
                          'assets/images/likert2_selected.png', "Discordo"),
                      _renderInfoRow('assets/images/likert3_selected.png',
                          "Não estou decidido"),
                      _renderInfoRow(
                          'assets/images/likert4_selected.png', "Concordo"),
                      _renderInfoRow('assets/images/likert5_selected.png',
                          "Concordo Totalmente"),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Fechar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  this._isInfoShow = false;
                },
              ),
            ],
          );
        });
  }

  _renderInfoRow(asset, label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Image.asset(
            asset,
            width: 30,
          ),
          SizedBox(
            width: 16,
          ),
          Text(label),
        ],
      ),
    );
  }
}
