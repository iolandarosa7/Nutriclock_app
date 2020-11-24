import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Meal.dart';
import 'package:nutriclock_app/models/StaticMealNameResponse.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/DropMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealDetailFragment extends StatefulWidget {
  @override
  _MealDetailFragmentState createState() => _MealDetailFragmentState();
}

class _MealDetailFragmentState extends State<MealDetailFragment> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _isLoading = false;
  final ptDatesFuture = initializeDateFormatting('pt', null);
  final dateFormat = new DateFormat('dd/MM/yyyy');
  final picker = ImagePicker();
  final TextEditingController _typeAheadController = TextEditingController();
  final _mealTypes = [
    DropMenu('P', 'Pequeno-almoço'),
    DropMenu('A', 'Almoço'),
    DropMenu('L', 'Lanche'),
    DropMenu('J', 'Jantar'),
    DropMenu('S', 'Snack'),
    DropMenu('O', 'Outro'),
  ];
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
    DropMenu('Outro', 'Outro'),
  ];
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  File _foodPhoto;
  File _nutritionalInfoPhoto;
  var _autocompleteSuggestions = [];
  var _name;
  var _selectedMealType;
  var _quantity;
  var _selectedUnit;
  var _observations;
  var _showError = false;
  var _userId;

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
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    List list = [];

    var storeUser = localStorage.getString(LOCAL_STORAGE_USER_KEY);

    if (storeUser != null) {
      User user = User.fromJson(json.decode(storeUser));
      this.setState(() {
        _userId = user.id;
      });
    }

    try {
      var response = await Network().getWithoutAuth(MEALS_NAMES_URL);

      print(response.statusCode);

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
      print('error'+error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Novo Alimento",
            style: TextStyle(
              fontFamily: 'Pacifico',
            ),
          ),
          backgroundColor: Color(0xFF74D44D),
        ),
        body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _showPicker(context, 'FOOD_PHOTO');
                      },
                      child: _foodPhoto != null
                          ? ClipRRect(
                              child: Image.file(
                                _foodPhoto,
                                width: double.infinity,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                              ),
                              width: double.infinity,
                              height: 100,
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
                                    " + Clica para adicionar uma foto da refeição",
                                    style: TextStyle(
                                        color: Colors.black38, fontSize: 12),
                                  )
                                ],
                              )),
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
                                    "Se o produto for embalado adiciona foto da Informção Nutricional",
                                    style: TextStyle(
                                        color: Colors.black38, fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "O fornecimento desta informação é relevante.",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              )),
                    ),
                    Padding(
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
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                            Stack(
                              children: <Widget>[
                                DropdownButton(
                                  value: _selectedMealType,
                                  hint: Padding(
                                    padding: const EdgeInsets.only(left: 50),
                                    child: Text(
                                      "Tipo de Refeição *",
                                      style: TextStyle(
                                          color: Color(0xFF9b9b9b),
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  icon: Icon(Icons.arrow_drop_down),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedMealType = newValue;
                                      _showError = false;
                                    });
                                  },
                                  isExpanded: true,
                                  items: _mealTypes
                                      .map<DropdownMenuItem<String>>(
                                          (DropMenu value) {
                                    return DropdownMenuItem<String>(
                                      value: value.value,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50),
                                        child: Text(value.description),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    child: Icon(
                                      Icons.list,
                                      color: Colors.grey,
                                    )),
                              ],
                            ),
                            TypeAheadFormField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: _typeAheadController,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFA3DC92)),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.restaurant,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Nome *",
                                  labelText: 'Nome *',
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
                              transitionBuilder:
                                  (context, suggestionsBox, controller) {
                                return suggestionsBox;
                              },
                              onSuggestionSelected: (suggestion) {
                                this._typeAheadController.text = suggestion;
                              },
                              suggestionsCallback: (pattern) {
                                var list = [];
                                var size = 0;
                                _autocompleteSuggestions.forEach((element) {
                                  if (size <= 20 &&
                                      element
                                          .toString()
                                          .toLowerCase()
                                          .startsWith(pattern)) {
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
                                        borderSide: BorderSide(
                                            color: Color(0xFFA3DC92)),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.check_circle,
                                        color: Colors.grey,
                                      ),
                                      hintText: "Quant. *",
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
                                        padding: const EdgeInsets.only(
                                            top: 26, left: 8.0),
                                        child: DropdownButton(
                                          value: _selectedUnit,
                                          hint: Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 20),
                                            child: Text(
                                              "Unidade *",
                                              style: TextStyle(
                                                  color: Color(0xFF9b9b9b),
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          icon: Icon(Icons.arrow_drop_down),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selectedUnit = newValue;
                                              _showError = false;
                                            });
                                          },
                                          isExpanded: true,
                                          items: _units
                                              .map<DropdownMenuItem<String>>(
                                                  (DropMenu value) {
                                            return DropdownMenuItem<String>(
                                              value: value.value,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 16),
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
                            Row(
                              children: [
                                // date picker
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              color: Colors.grey,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 16.0),
                                              child: Text(
                                                'Data',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      FlatButton(
                                        color: Colors.transparent,
                                        splashColor: Colors.black26,
                                        onPressed: () =>
                                            _selectDate(context, 'DATE'),
                                        child: Text(
                                          dateFormat.format(_date),
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              color: Colors.grey,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 16.0),
                                              child: Text(
                                                'Hora',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      FlatButton(
                                        color: Colors.transparent,
                                        splashColor: Colors.black26,
                                        onPressed: () =>
                                            _selectDate(context, 'TIME'),
                                        child: Text(
                                          "${_time.hour}:${_time.minute > 9 ? _time.minute : "0${_time.minute}"} horas",
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            TextFormField(
                              maxLines: 4,
                              style: TextStyle(color: Color(0xFF000000)),
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFA3DC92)),
                                ),
                                hintText: "Informação Adicional",
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
                                child: FlatButton(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    child: Text(
                                      _isLoading ? 'Aguarde...' : 'Confirmar',
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
                                    if (!_formKey.currentState.validate() ||
                                        _name == null ||
                                        _name.trim() == "" ||
                                        _selectedMealType == null ||
                                        _selectedMealType.trim() == "" ||
                                        _quantity == null ||
                                        _quantity.trim == "" ||
                                        _selectedUnit == null ||
                                        _selectedUnit == "") {
                                      setState(() {
                                        _showError = true;
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
                  ],
                ),
              ],
            ),
          ),
        ));
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
                'Selecionou a unidade "Outro". Seria importante que desse alguma informação adicional sobre o produto.'),
            content:
                  TextFormField(
                    maxLines: 4,
                    style: TextStyle(color: Color(0xFF000000)),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFA3DC92)),
                      ),
                      hintText: "Informação Adicional",
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
              FlatButton(
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
    meal.type = _selectedMealType;
    meal.date = _date.toIso8601String();
    meal.time =
        "${_time.hour}:${_time.minute < 9 ? "0 ${_time.minute}" : _time.minute}";
    meal.observations = _observations;

    try {
      var response = await Network()
          .postMeal(meal, _foodPhoto, _nutritionalInfoPhoto, _userId, MEAL_URL);

      var body = json.decode(response.body);
      print(response.statusCode);

      if (response.statusCode == RESPONSE_SUCCESS_201) {
        Navigator.of(context).pop();
      } else {
        isShowMessage = true;
        if (body[JSON_ERROR_KEY] != null) message = (body[JSON_ERROR_KEY]);
      }
    } catch (error) {
      isShowMessage = true;
    }

    if (isShowMessage) _showMessage(message);

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
        } else
          _nutritionalInfoPhoto = File(pickedFile.path);
        _showError = false;
      }
    });
  }

  // show datepicker
  void _selectDate(BuildContext context, String type) async {
    final ThemeData themeData = Theme.of(context);
    assert(themeData.platform != null);

    switch (themeData.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context, type);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context, type);
    }
  }

  void buildMaterialDatePicker(BuildContext context, String type) async {
    if (type == 'TIME') {
      final pickedTime =
          await showTimePicker(context: context, initialTime: _time);

      if (pickedTime != null && pickedTime != _time) {
        setState(() {
          _time = pickedTime;
          _showError = false;
        });
      }

      return;
    }

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      cancelText: 'Cancelar',
      fieldLabelText: 'Data de Nascimento',
    );

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
        _showError = false;
      });
    }
  }

  void buildCupertinoDatePicker(BuildContext context, String type) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: type == 'TIME'
                  ? CupertinoDatePickerMode.time
                  : CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (type != 'TIME' && picked != null && picked != _date)
                  setState(() {
                    _date = picked;
                    _showError = false;
                  });

                if (type == 'TIME' && picked != null && picked != _time)
                  setState(() {
                    _time = TimeOfDay(hour: picked.hour, minute: picked.minute);
                    _showError = false;
                  });
              },
              initialDateTime: type == 'TIME'
                  ? DateTime(1969, 1, 1, _time.hour, _time.minute)
                  : _date,
              minimumYear: 2000,
              maximumYear: 2025,
              use24hFormat: true,
              minuteInterval: 1,
            ),
          );
        });
  }
}
