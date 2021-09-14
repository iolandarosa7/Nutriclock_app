import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Meal.dart';
import 'package:nutriclock_app/models/StaticMealNameResponse.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';
import 'package:nutriclock_app/utils/DropMenu.dart';

class MealDetailFragment extends StatefulWidget {
  final String type;
  final DateTime date;
  final String time;

  MealDetailFragment(
      {Key key, @required this.type, @required this.date, @required this.time})
      : super(key: key);

  @override
  _MealDetailFragmentState createState() => _MealDetailFragmentState();
}

class _MealDetailFragmentState extends State<MealDetailFragment> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _isLoading = false;
  final picker = ImagePicker();
  final TextEditingController _typeAheadController = TextEditingController();
  final _units = [
    DropMenu('Gramas', 'Gramas'),
    DropMenu('Mililitros', 'Mililitros'),
    DropMenu('Colher de sopa', 'Colher de sopa'),
    DropMenu('Colher de chá', 'Colher de chá'),
    DropMenu('Colher de café', 'Colher de café'),
    DropMenu('Colher de servir', 'Colher de servir'),
    DropMenu('Concha de sopa', 'Concha de sopa'),
    DropMenu('Colher de sobremesa', 'Colher de sobremesa'),
    DropMenu('Copo', 'Copo'),
    DropMenu('Caneca', 'Caneca'),
    DropMenu('Chavena de chá', 'Chavena de chá'),
    DropMenu('Chavena de café', 'Chavena de café'),
    DropMenu('Prato', 'Prato'),
    DropMenu('Tigela média', 'Tigela média'),
    DropMenu('Pires', 'Pires'),
    DropMenu('Outro', 'Porção/Unidade'),
  ];
  File _foodPhoto;
  File _nutritionalInfoPhoto;
  var _autocompleteSuggestions = [];
  var _name;
  var _quantity;
  var _selectedUnit;
  var _observations;
  var _showError = false;
  var _showErrorQuantity = false;
  var appWidget = AppWidget();
  var withDia = 'àáâãäåòóôõöøèéêëðçìíîïùúûüñšÿýž';
  var withoutDia = 'aaaaaaooooooeeeeeciiiiuuuunsyyz';

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    if (_isLoading) return;

    this.setState(() {
      _isLoading = true;
    });
    List list = [];

    try {
      var response = await Network().getWithoutAuth(MEALS_NAMES_URL);

      if (response.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];
        data.forEach((element) {
          StaticMealNameResponse value =
              StaticMealNameResponse.fromJson(element);
          list.add(value.name);
        });
      }

      setState(() {
        _isLoading = false;
        _autocompleteSuggestions = list;
      });
    } catch (error) {
      print(error);
      this.setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appWidget.getAppbar("Adicionar Alimento"),
      body: appWidget.getImageContainer(
        "assets/images/bg_green.png",
        _isLoading,
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Card(
            elevation: 4.0,
            color: Colors.white,
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _showError
                        ? Text(
                            "Os campos assinalados com * são obrigatórios!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          )
                        : SizedBox(
                            height: 0,
                          ),
                    _showErrorQuantity
                        ? Text(
                            "A quantidade deve ser um valor positivo!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          )
                        : SizedBox(
                            height: 0,
                          ),
                    TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _typeAheadController,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFA3E1CB)),
                          ),
                          prefixIcon: Icon(
                            Icons.restaurant,
                            color: Color(0xFFA3E1CB),
                          ),
                          labelText: 'Nome do alimento *',
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(
                              color: Color(0xFF9b9b9b),
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (suggestion) {
                        this._typeAheadController.text = suggestion;
                      },
                      suggestionsCallback: (pattern) {
                        var list = [];
                        var size = 0;

                        if (pattern.trim().isEmpty) return list;

                        _autocompleteSuggestions.forEach((element) {
                          var str = element.toString().toLowerCase();
                          var ptr = pattern.trim().toLowerCase();
                          for (int i = 0; i < withDia.length; i++) {
                            str = str.replaceAll(withDia[i], withoutDia[i]);
                            ptr = ptr.replaceAll(withDia[i], withoutDia[i]);
                          }

                          if (size <= 10 && str.startsWith(ptr)) {
                            list.add(element);
                            size++;
                          }
                        });
                        return list;
                      },
                      validator: (value) {
                        _name = value;
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            style: TextStyle(color: Color(0xFF000000)),
                            cursorColor: Color(0xFF9b9b9b),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFA3E1CB)),
                              ),
                              prefixIcon: Icon(
                                Icons.check_circle,
                                color: Color(0xFFA3E1CB),
                              ),
                              labelText: 'Quant. *',
                              labelStyle: TextStyle(color: Colors.grey),
                              hintStyle: TextStyle(
                                  color: Color(0xFF9b9b9b),
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                            validator: (value) {
                              _quantity = value;
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 26, left: 8.0),
                                child: DropdownButton(
                                  value: _selectedUnit,
                                  hint: Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      "Unidade *",
                                      style: TextStyle(
                                          color: Color(0xFF9b9b9b),
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: Color(0xFFA3E1CB)),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedUnit = newValue;
                                      _showError = false;
                                    });
                                  },
                                  isExpanded: true,
                                  items: _units.map<DropdownMenuItem<String>>(
                                      (DropMenu value) {
                                    return DropdownMenuItem<String>(
                                      value: value.value,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: Text(value.description),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        _showPicker(context, 'FOOD_PHOTO');
                      },
                      child: _foodPhoto != null
                          ? ClipRRect(
                              child: Image.file(
                                _foodPhoto,
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                              ),
                              width: double.infinity,
                              height: 150,
                              child: Padding(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image,
                                      color: Colors.grey[800],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      " + Clique para adicionar uma foto da refeição",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black38, fontSize: 14),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showPicker(context, 'NUTRI_INFO_PHOTO');
                      },
                      child: _nutritionalInfoPhoto != null
                          ? ClipRRect(
                              child: Image.file(
                                _nutritionalInfoPhoto,
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.black12,
                              ),
                              width: double.infinity,
                              height: 150,
                              child: Padding(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_rounded,
                                      color: Colors.grey[800],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Se o produto for embalado adicione foto da Informação Nutricional",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black38, fontSize: 14),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "O fornecimento desta informação é relevante.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ),
                    TextFormField(
                      maxLines: 4,
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFA3E1CB)),
                        ),
                        labelText: 'Informação Adicional',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (value) {
                        _observations = value;
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          child: Text(
                            _isLoading ? 'Aguarde...' : 'Confirmar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFA3E1CB),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () {
                            if (!_formKey.currentState.validate() ||
                                _name == null ||
                                _name.trim() == "" ||
                                _quantity == null ||
                                _quantity.trim() == "" ||
                                _selectedUnit == null ||
                                _selectedUnit == "") {
                              setState(() {
                                _showError = true;
                              });
                              return;
                            }

                            if (double.parse(_quantity) < 0) {
                              setState(() {
                                _showErrorQuantity = true;
                              });
                              return;
                            }

                            if (_selectedUnit == "Outro" &&
                                (_observations == "" ||
                                    _observations == null)) {
                              _showAdditionalInformationDialog();
                              return;
                            }

                            _postNewMeal();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAdditionalInformationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
                'Selecionou a unidade "Porção/Unidade". Seria importante que desse alguma informação adicional sobre a quantidade ingerida do produto.'),
            content: TextFormField(
              maxLines: 4,
              style: TextStyle(color: Color(0xFF000000)),
              cursorColor: Color(0xFF9b9b9b),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFA3DC92)),
                ),
                labelText: 'Informação Adicional',
                labelStyle: TextStyle(color: Colors.grey),
                hintStyle: TextStyle(
                    color: Color(0xFF9b9b9b),
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
              onChanged: (value) => {
                this.setState(() {
                  _observations = value;
                }),
              },
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  _postNewMeal();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _postNewMeal() async {
    var isShowMessage = false;
    var message = "Ocorreu um erro ao adicionar a refeição";
    if (_isLoading) return;

    this.setState(() {
      _isLoading = true;
    });

    var meal = Meal();
    meal.name = _name;
    meal.quantity = _quantity;
    meal.relativeUnit = _selectedUnit;
    meal.type = this.widget.type;
    meal.date = this.widget.date.toIso8601String();
    meal.time = this.widget.time;
    meal.observations = _observations;

    try {
      var response = await Network()
          .postMeal(meal, _foodPhoto, _nutritionalInfoPhoto, MEAL_URL);

      var body = json.decode(response.body);

      if (response.statusCode == RESPONSE_SUCCESS_201) {
        _typeAheadController.text = '';

        setState(() {
          _name = null;
          _quantity = null;
          _selectedUnit = null;
          _observations = null;
          _foodPhoto = null;
          _nutritionalInfoPhoto = null;
        });
        appWidget.showSnackbar(
            "Alimento adicionado à refeição", Colors.green, _scaffoldKey);
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

  // show imagepicker
  void _showPicker(context, type) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galeria de Imagens'),
                      onTap: () {
                        getImage(ImageSource.gallery, type);
                        Navigator.pop(context);
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Câmara'),
                    onTap: () {
                      getImage(ImageSource.camera, type);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImage(ImageSource source, String type) async {
    final pickedFile = await picker.getImage(source: source, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        if (type == 'FOOD_PHOTO') {
          _foodPhoto = File(pickedFile.path);
          _showError = false;
          _showErrorQuantity = false;
        } else
          _nutritionalInfoPhoto = File(pickedFile.path);
        _showError = false;
        _showErrorQuantity = false;
      }
    });
  }
}
