import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Disease.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/network_utils/api.dart';
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

  @override
  void initState() {
    _loadDataFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Doenças / Alergias",
          style: TextStyle(
            fontFamily: 'Pacifico',
          ),
        ),
        backgroundColor: Color(0xFFA3E1CB),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_home.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: _isLoading
            ? Center(
                child: Loading(
                    indicator: BallPulseIndicator(),
                    size: 50.0,
                    color: Color(0xFFFFBCBC)),
              )
            : Stack(
                children: [
                  Positioned(
                    top: 35,
                    left: 0,
                    right: 0,
                    child: _userDiseases == null || _userDiseases.length == 0
                        ? _renderNoDiseases()
                        : SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.all(4),
                            child: Column(children: _renderDiseases()),
                          ),
                  ),
                  Positioned(
                    top: 10,
                    right: 20,
                    child: FloatingActionButton(
                      onPressed: () {
                        _addNewDisease();
                      },
                      child: Icon(Icons.add),
                      backgroundColor: Color(0xFF60B2A3),
                      elevation: 50,
                    ),
                  )
                ],
              ),
      ),
    );
  }

  List<Widget> _renderDiseases() {
    List<Widget> list = List();
    _userDiseases.forEach((element) {
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
                            heroTag: "edit$element",
                            child: Icon(
                              Icons.edit,
                              size: 15,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.blue,
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: FloatingActionButton(
                            heroTag: "delete$element",
                            child: Icon(
                              Icons.delete,
                              size: 15,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.redAccent,
                            onPressed: () {
                              // this._showDeleteMealConfirmation(element);
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

  /*
  meals.forEach((element) {
      list.add(
        Stack(
          children: [
            Positioned(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Color(0xFFE6A9A9), width: 10.0),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ClipRect(
                    child: element.foodPhotoUrl != null
                        ? Image.network(
                            "$IMAGE_BASE_URL/food/thumb_${element.foodPhotoUrl}",
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                              return _renderImageDefault();
                            },
                          )
                        : _renderImageDefault(),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 0,
              height: 70,
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: FloatingActionButton(
                      heroTag: "edit${element.id}",
                      child: Icon(
                        Icons.edit,
                        size: 15,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MealUpdateFragment(meal: element),
                          ),
                        ).then((value) => {_loadMealsList()});
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    flex: 5,
                    child: FloatingActionButton(
                      heroTag: "delete${element.id}",
                      child: Icon(
                        Icons.delete,
                        size: 15,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.redAccent,
                      onPressed: () {
                        this._showDeleteMealConfirmation(element);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
   */

  Widget _renderNoDiseases() {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      margin: EdgeInsets.only(left: 20, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Neão existem doenças / alergias registadas.",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  /*return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Alergias',
              ),
              Tab(
                text: 'Doenças',
              )
            ],
            indicatorColor: Colors.white,
          ),
          title: Text(
            "Doenças / Alergias",
            style: TextStyle(
              fontFamily: 'Pacifico',
            ),
          ),
          backgroundColor: Color(0xFFA3E1CB),
        ),
        body: TabBarView(children: [
          _renderAllergies(),
          _renderDiseases(),
        ]),
      ),
    );*/

  /*

  Widget _renderAllergies() {
    return Container(

    );
  }

  Widget _renderDiseases() {
    return Container(

    );
  }


   */

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
                    "Esta informação poderá posteriormenmte ser confirmada com o seu médico",
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
              FlatButton(
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
          _userDiseases = data.diseases.split(',');
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

    if (isShowMessage) _showMessage("Ocorreu um erro na atualização do perfil");

    this.setState(() {
      diseaseToAdd = null;
      selectedDisease = null;
      selectedAllergy = null;
    });
  }

  _parseUserDiseases() {
    var auxStr = "";
    _userDiseases.forEach((element) {
      auxStr += "$element,";
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
        if (user.diseases != null && user.diseases.split(',').length > 0) {
          this.setState(() {
            _userDiseases = user.diseases.trim().split(',');
          });
        }
      }
    } catch (error) {}

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
}
