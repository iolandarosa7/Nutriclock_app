import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Disease.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Diseases extends StatefulWidget {
  @override
  _DiseasesState createState() => _DiseasesState();
}

class _DiseasesState extends State<Diseases> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _allergies = [];
  List<String> _diseases = [];
  List<String> _userDiseases = [];
  var _isLoading = false;
  var selectedDisease;
  var selectedAllergy;
  var diseaseToAdd;
  var appWidget = AppWidget();

  @override
  void initState() {
    _loadDataFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          _addNewDisease();
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF60B2A3),
        elevation: 50,
      ),
      appBar: appWidget.getAppbar("Doenças / Alergias"),
      body: appWidget.getImageContainer(
        "assets/images/bg_disease.png",
        _isLoading,
        _userDiseases.length == 0
            ? _renderNoDiseases()
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ..._renderDiseases(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  List<Widget> _renderDiseases() {
    List<Widget> list = [];
    _userDiseases.asMap().forEach((i, element) {
      list.add(
        SizedBox(
          width: double.infinity,
          height: 100,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            margin: EdgeInsets.only(top: 10),
            shadowColor: Color(0xFFA3E1CB),
            elevation: 10,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    top: 0,
                    child: Center(
                      child: Text(
                        element,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF60B2A3),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    top: 0,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 40,
                          child: FloatingActionButton(
                            heroTag: "edit$element$i",
                            child: Icon(
                              Icons.edit,
                              size: 15,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.blue,
                            onPressed: () {
                              this._showUpdateModal(i);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: FloatingActionButton(
                            heroTag: "delete$element$i",
                            child: Icon(
                              Icons.delete,
                              size: 15,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.redAccent,
                            onPressed: () {
                              this._showDeleteConfirmation(i);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
    return list;
  }

  Future<void> _showUpdateModal(int index) async {
    if (_isLoading) return;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
              'Editar Doença / Alergia Alimentar',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFA3E1CB)),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    onChanged: (value) => {
                      this.setState(() {
                        _userDiseases[index] = value;
                      }),
                    },
                    initialValue: _userDiseases[index],
                    style: TextStyle(color: Color(0xFF000000)),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFA3E1CB)),
                      ),
                      hintText: "Outra doença",
                      hintStyle: TextStyle(
                        color: Color(0xFF9b9b9b),
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Guardar',
                  style: TextStyle(color: Color(0xFF60B2A3)),
                ),
                onPressed: () {
                  _makeRequest();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _showDeleteConfirmation(int index) async {
    if (_isLoading) return;
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Apagar doença / alergia alimentar",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFA3E1CB),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    "Tem a certeza que deseja apagar a doença / alergia alimentar selecionada?",
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
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteDisease(index);
                },
              ),
            ],
          );
        });
  }

  Widget _renderNoDiseases() {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        "Não existem doenças / alergias alimentares registadas.",
        style: TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> _addNewDisease() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
              'Adicionar Problema de Saúde',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFA3E1CB)),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    "Esta informação poderá posteriormente ser confirmada com o seu médico",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  DropdownButton(
                    value: selectedDisease,
                    hint: Text("Seleciona a doença"),
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (newValue) {
                      setState(() {
                        selectedDisease = newValue;
                      });
                    },
                    isExpanded: true,
                    items:
                        _diseases.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButton(
                    value: selectedAllergy,
                    hint: Text("Seleciona a alergia"),
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (newValue) {
                      setState(() {
                        selectedAllergy = newValue;
                      });
                    },
                    isExpanded: true,
                    items: _allergies
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    onChanged: (value) => {
                      this.setState(() {
                        diseaseToAdd = value;
                      }),
                    },
                    style: TextStyle(color: Color(0xFF000000)),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFA3E1CB)),
                      ),
                      hintText: "Outra doença",
                      hintStyle: TextStyle(
                          color: Color(0xFF9b9b9b),
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Adicionar',
                  style: TextStyle(color: Color(0xFF60B2A3)),
                ),
                onPressed: () {
                  _updateDiseaseList();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  _deleteDisease(index) {
    _userDiseases.removeAt(index);
    _makeRequest();
  }

  _updateDiseaseList() {
    if (_checkDiseaseToAdd(selectedAllergy)) _userDiseases.add(selectedAllergy);
    if (_checkDiseaseToAdd(selectedDisease)) _userDiseases.add(selectedDisease);
    if (_checkDiseaseToAdd(diseaseToAdd)) _userDiseases.add(diseaseToAdd);
    _makeRequest();
  }

  _makeRequest() async {
    var isShowMessage = false;

    // request update diseases in user
    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network().postWithAuth({
        'diseases': _parseUserDiseases(),
      }, USERS_DISEASES_URL);

      if (response.statusCode == RESPONSE_SUCCESS) {
        var data = User.fromJson(json.decode(response.body)[JSON_DATA_KEY]);

        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString(LOCAL_STORAGE_USER_KEY, json.encode(data));

        this.setState(() {
          _userDiseases = _makeDiseasesList(data.diseases);
        });
      } else {
        isShowMessage = true;
      }
    } catch (error) {
      isShowMessage = true;
    }

    this.setState(() {
      _isLoading = false;
    });

    if (isShowMessage)
      appWidget.showSnackbar("Ocorreu um erro", Colors.red, _scaffoldKey);

    this.setState(() {
      diseaseToAdd = null;
      selectedDisease = null;
      selectedAllergy = null;
    });
  }

  _makeDiseasesList(String auxStr) {
    var tempArray = auxStr.toString().split(',');
    List<String> list = [];

    tempArray.forEach((element) {
      if (element.trim().isNotEmpty) list.add(element);
    });

    return list;
  }

  _parseUserDiseases() {
    var auxStr = "";
    _userDiseases.forEach((element) {
      if (element.trim().isNotEmpty) auxStr += "$element,";
    });

    return auxStr;
  }

  _checkDiseaseToAdd(String d) {
    if (d == null) return false;

    if (d.trim().isEmpty) return false;

    _userDiseases.forEach((element) {
      if (element.trim().toLowerCase() == d.toString().trim().toLowerCase())
        return false;
    });
    return true;
  }

  void _loadDataFromServer() async {
    List<String> diseases = [];
    List<String> allergies = [];

    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network().getWithoutAuth(DISEASES_URL);

      if (response.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];

        data.forEach((element) {
          Disease disease = Disease.fromJson(element);
          if (disease.type == "D")
            diseases.add(disease.name);
          else
            allergies.add(disease.name);
        });

        this.setState(() {
          _diseases = diseases;
          _allergies = allergies;
        });
      }

      SharedPreferences localStorage = await SharedPreferences.getInstance();

      var storeUser = localStorage.getString(LOCAL_STORAGE_USER_KEY);

      if (storeUser != null) {
        User user = User.fromJson(json.decode(storeUser));
        if (user.diseases != null) {
          this.setState(() {
            _userDiseases = _makeDiseasesList(user.diseases.toString());
          });
        }
      }
    } catch (error) {}

    setState(() {
      _isLoading = false;
    });
  }
}
