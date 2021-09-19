import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Drug.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';
import 'package:nutriclock_app/utils/DropMenu.dart';

class MedicationList extends StatefulWidget {
  @override
  _MedicationListState createState() => _MedicationListState();
}

class _MedicationListState extends State<MedicationList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var appWidget = AppWidget();
  List<Drug> _medications = [];
  List<Drug> _suplements = [];
  var _isLoading = false;

  var _drugType;
  var _drugName;
  var _drugTime;
  var _drugPosology;
  List<dynamic> _drugDays = [];

  @override
  void initState() {
    _loadDataFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          key: _scaffoldKey,
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: FloatingActionButton(
            mini: true,
            onPressed: () {
              _addNewMedication(-1, "", "Adicionar");
            },
            child: Icon(Icons.add),
            backgroundColor: Color(0xFF60B2A3),
            elevation: 50,
          ),
          appBar: AppBar(
            title: Text(
              "Medicamentos / Suplementos",
              style: TextStyle(
                fontFamily: 'Pacifico',
              ),
            ),
            backgroundColor: Color(0xFFA3E1CB),
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: 'Medicamentos'),
                Tab(text: 'Suplementos'),
              ],
            ),
          ),
          body: TabBarView(
            children: [_renderMedications(), _renderSuplements()],
          )),
    );
  }

  Future<void> _addNewMedication(int index, String type, String title) async {
    Drug drug = Drug("", "", "", "", "");
    if (index != -1) {
      _drugType = type;
      if (type == 'M') {
        drug = _medications[index];
      } else {
        drug = _suplements[index];
      }
      _drugTime = drug.timesADay;

      if (drug.timesAWeek.trim() != "") {
        drug.timesAWeek.split(",").forEach((element) {
          if (element.trim() != "") {
            _drugDays.add(element);
          }
        });
      }

      _drugName = drug.name;
      _drugPosology = drug.posology;
    }
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text(
                  "$title Medicamento / Suplemento",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFA3E1CB),
                  ),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      DropdownButton(
                        value: _drugType,
                        hint: Text(
                          "Tipo",
                          style: TextStyle(
                              color: Color(0xFF9b9b9b),
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                        icon: Icon(Icons.arrow_drop_down),
                        onChanged: (newValue) {
                          setState(() {
                            _drugType = newValue;
                          });
                        },
                        isExpanded: true,
                        items: [
                          DropMenu('M', 'Medicamento'),
                          DropMenu('S', 'Suplemento'),
                        ].map<DropdownMenuItem<String>>((DropMenu item) {
                          return DropdownMenuItem<String>(
                            value: item.value,
                            child: Text(item.description),
                          );
                        }).toList(),
                      ),
                      TextFormField(
                        onChanged: (value) => {
                          this.setState(() {
                            _drugName = value;
                          }),
                        },
                        initialValue: drug.name,
                        style: TextStyle(color: Color(0xFF000000)),
                        cursorColor: Color(0xFF9b9b9b),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFA3E1CB),
                            ),
                          ),
                          hintText: "Nome",
                          hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      TextFormField(
                        onChanged: (value) => {
                          this.setState(() {
                            _drugPosology = value;
                          }),
                        },
                        initialValue: drug.posology,
                        style: TextStyle(color: Color(0xFF000000)),
                        cursorColor: Color(0xFF9b9b9b),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFA3E1CB),
                            ),
                          ),
                          suffix: Text('mg/ml'),
                          hintText: "Dosagem",
                          hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      DropdownButton(
                        value: _drugTime,
                        hint: Text("Intervalo Horário"),
                        icon: Icon(Icons.arrow_drop_down),
                        onChanged: (newValue) {
                          setState(() {
                            _drugTime = newValue;
                          });
                        },
                        isExpanded: true,
                        items: [
                          "De 4 em 4h",
                          "De 6 em 6h",
                          "De 8 em 8h",
                          "De 12 em 12h",
                          "De 24 em 24h",
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          MultiSelectFormField(
                            autovalidate: false,
                            title: Text(
                              'Dias de Toma',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            dataSource: [
                              {
                                "display": "Todos os dias",
                                "value": "ALL",
                              },
                              {
                                "display": "Segunda",
                                "value": "2",
                              },
                              {
                                "display": "Terça",
                                "value": "3",
                              },
                              {
                                "display": "Quarta",
                                "value": "4",
                              },
                              {
                                "display": "Quinta",
                                "value": "5",
                              },
                              {
                                "display": "Sexta",
                                "value": "6",
                              },
                              {
                                "display": "Sábado",
                                "value": "7",
                              },
                              {
                                "display": "Domingo",
                                "value": "1",
                              },
                            ],
                            textField: 'display',
                            valueField: 'value',
                            okButtonLabel: 'Confirmar',
                            cancelButtonLabel: 'Cancelar',
                            hintWidget: Text('Escolha uma ou mais opções'),
                            initialValue: _drugDays,
                            onSaved: (value) {
                              if (value == null) return;
                              setState(() {
                                _drugDays = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      if (_drugName == null ||
                          _drugName.trim() == "" ||
                          _drugPosology == null ||
                          _drugPosology.trim() == "") {
                        appWidget.showSnackbar(
                            "Deve preencher o nome e dosagem",
                            Colors.red,
                            _scaffoldKey);
                        return;
                      }

                      var days = "";

                      if (_drugDays.contains('ALL'))
                        days = "1,2,3,4,5,6,7,";
                      else {
                        _drugDays.forEach((element) {
                          days += "$element,";
                        });
                      }

                      var data = {
                        'name': _drugName,
                        'timesAWeek': days,
                        'timesADay': _drugTime,
                        'posology': _drugPosology,
                        'type': _drugType
                      };

                      if (index != -1) {
                        _updateRequest(data, index, type);
                      } else {
                        _addRequest(data);
                      }

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      title,
                      style: TextStyle(color: Color(0xFF60B2A3)),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  _updateRequest(Map<String, dynamic> data, int index, String type) async {
    var isShowMessage = false;
    List<Drug> suplements = _suplements;
    List<Drug> medication = _medications;
    int id = 0;
    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    if (type == 'M')
      id = _medications[index].id;
    else
      id = _suplements[index].id;

    try {
      var response = await Network().putWithAuth(data, MEDICATIONS_URL, id);
      if (response.statusCode == RESPONSE_SUCCESS) {
        var data = Drug.fromJson(json.decode(response.body)[JSON_DATA_KEY]);
        if (type == 'M') {
          medication.removeAt(index);
        } else {
          suplements.removeAt(index);
        }

        if (data.type == 'M') {
          medication.add(data);
        } else {
          suplements.add(data);
        }

        this.setState(() {
          _medications = medication;
          _suplements = suplements;
        });
      } else {
        isShowMessage = true;
      }
    } catch (error) {
      print(error);
      isShowMessage = true;
    }

    this.setState(() {
      _isLoading = false;
      _drugName = null;
      _drugPosology = null;
      _drugType = null;
      _drugTime = null;
      _drugDays = [];
    });

    if (isShowMessage)
      appWidget.showSnackbar(
          "Ocorreu um erro ao editar medicamento / suplemento",
          Colors.red,
          _scaffoldKey);
  }

  _addRequest(Map<String, dynamic> data) async {
    var isShowMessage = false;
    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network().postWithAuth(data, MEDICATION_AUTH_URL);
      if (response.statusCode == RESPONSE_SUCCESS_201) {
        var medication =
            Drug.fromJson(json.decode(response.body)[JSON_DATA_KEY]);
        if (medication.type == 'M') {
          var aux = _medications;
          aux.add(medication);
          this.setState(() {
            _medications = aux;
          });
        } else {
          var aux = _suplements;
          aux.add(medication);
          this.setState(() {
            _suplements = aux;
          });
        }
      } else {
        isShowMessage = true;
      }
    } catch (error) {
      print(error);
      isShowMessage = true;
    }

    this.setState(() {
      _isLoading = false;
      _drugName = null;
      _drugPosology = null;
      _drugType = null;
      _drugTime = null;
      _drugDays = [];
    });

    if (isShowMessage)
      appWidget.showSnackbar(
        "Ocorreu um erro na adição de medicamento / suplemento",
        Colors.red,
        _scaffoldKey,
      );
  }

  Widget _renderMedications() {
    return appWidget.getImageContainer(
      "assets/images/bg_medication.png",
      _isLoading,
      _medications.length == 0
          ? _renderNoData('Não existem medicamentos registados')
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    ..._renderDrug(_medications, 'M'),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _renderSuplements() {
    return appWidget.getImageContainer(
      "assets/images/bg_medication.png",
      _isLoading,
      _suplements.length == 0
          ? _renderNoData('Não existem suplementos registados')
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    ..._renderDrug(_suplements, 'S'),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _renderNoData(String message) {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        message,
        style: TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Widget> _renderDrug(List<Drug> drugs, String type) {
    List<Widget> list = <Widget>[];
    drugs.asMap().forEach((i, element) {
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
                        element.name,
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
                              this._addNewMedication(i, type, "Editar");
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
                              this._showDeleteConfirmation(i, type);
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

  Future<void> _showDeleteConfirmation(int index, String type) async {
    if (_isLoading) return;
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Apagar medicamento / suplemento",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFA3E1CB),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    "Tem a certeza que deseja apagar o medicamento / suplemento selecionado?",
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
                  _deleteMedication(index, type);
                },
              ),
            ],
          );
        });
  }

  void _deleteMedication(int index, String type) async {
    var isShowMessage = false;
    List<Drug> list = [];

    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    if (type == 'M')
      list = _medications;
    else
      list = _suplements;

    try {
      var response =
          await Network().deletetWithAuth(MEDICATIONS_URL, list[index].id);

      if (response.statusCode == RESPONSE_SUCCESS) {
        list.removeAt(index);

        if (type == 'M') {
          this.setState(() {
            _medications = list;
          });
        } else {
          this.setState(() {
            _suplements = list;
          });
        }
      } else {
        isShowMessage = true;
      }
    } catch (error) {
      print('error $error');
      isShowMessage = true;
    }

    this.setState(() {
      _isLoading = false;
    });

    if (isShowMessage)
      appWidget.showSnackbar(
          "Ocorreu um erro ao eliminar o medicamento / suplemento",
          Colors.red,
          _scaffoldKey);
  }

  void _loadDataFromServer() async {
    List<Drug> medications = [];
    List<Drug> suplements = [];

    if (_isLoading) return;

    this.setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network().getWithAuth(MEDICATION_AUTH_URL);

      if (response.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];

        data.forEach((element) {
          Drug m = Drug.fromJson(element);
          if (m.type == 'M')
            medications.add(m);
          else
            suplements.add(m);
        });

        this.setState(() {
          _medications = medications;
          _suplements = suplements;
        });
      }
    } catch (error) {
      print(error);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
