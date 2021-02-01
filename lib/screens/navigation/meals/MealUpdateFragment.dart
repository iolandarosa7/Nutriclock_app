import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Meal.dart';
import 'package:nutriclock_app/models/StaticMealNameResponse.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/DropMenu.dart';

class MealUpdateFragment extends StatefulWidget {
  final Meal meal;

  MealUpdateFragment({Key key, @required this.meal}) : super(key: key);

  @override
  _MealUpdateFragmentState createState() => _MealUpdateFragmentState();
}

class _MealUpdateFragmentState extends State<MealUpdateFragment> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  final ptDatesFuture = initializeDateFormatting('pt', null);
  final dateFormat = DateFormat('dd/MM/yyyy');
  final dateParser = DateFormat('yyyy-MM-dd');
  final _mealTypes = [
    DropMenu('P', 'Pequeno-almoço'),
    DropMenu('M', 'Meio da manhã'),
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
  var _autocompleteSuggestions = [];
  var _splitTime;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  var _showError = false;
  var _isLoading = false;
  final picker = ImagePicker();
  var _name;
  var _type;
  var _userId;
  var _quantity;
  var _unit;
  var _foodPhotoUrl;
  var _nutritionalInfoPhotoUrl;
  var _observations;
  var _pickedPhoto;

  @override
  void initState() {
    _date = dateParser.parse(this.widget.meal.date.substring(0, 10));
    _splitTime = this.widget.meal.time.split(":");
    _time = TimeOfDay(
        hour: int.parse(_splitTime[0].replaceAll(new RegExp(r"\s+"), "")),
        minute: int.parse(_splitTime[1].replaceAll(new RegExp(r"\s+"), "")));
    _foodPhotoUrl = this.widget.meal.foodPhotoUrl;
    _name = this.widget.meal.name;
    _userId = this.widget.meal.userId;
    _quantity = this.widget.meal.quantity.toString();
    _type = this.widget.meal.type;
    _nutritionalInfoPhotoUrl = this.widget.meal.nutritionalInfoPhotoUrl;
    _unit = this.widget.meal.relativeUnit;
    _observations = this.widget.meal.observations;
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

      _typeAheadController.text = this.widget.meal.name;

      setState(() {
        _isLoading = false;
        _autocompleteSuggestions = list;
      });
    } catch (error) {}
  }

  Widget _renderImageFoodDefault() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black12,
          border: Border(right: BorderSide(color: Colors.white))),
      child: Icon(
        Icons.image_rounded,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _renderImageNutriDefault() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border(
          left: BorderSide(color: Colors.white),
        ),
      ),
      child: Icon(
        Icons.image_rounded,
        color: Colors.grey[800],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Editar Alimento / Refeição",
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
            image: AssetImage("assets/images/bg_login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: _isLoading
            ? Center(
                child: Loading(
                    indicator: BallPulseIndicator(),
                    size: 50.0,
                    color: Color(0xFFFFBCBC)),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Card(
                  elevation: 4.0,
                  color: Colors.white,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                              TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: _typeAheadController,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFA3E1CB)),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.restaurant,
                                      color: Color(0xFFA3E1CB),
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
                              Padding(
                                padding: EdgeInsets.only(top: 24, bottom: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            child: Container(
                                              height: 100,
                                              child: SizedBox(
                                                  width: double.infinity,
                                                  child: _foodPhotoUrl != null
                                                      ? ClipRect(
                                                          child: Image.network(
                                                              "$IMAGE_BASE_URL/food/thumb_$_foodPhotoUrl",
                                                              fit: BoxFit.cover,
                                                              errorBuilder: (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace
                                                                      stackTrace) {
                                                            return _renderImageFoodDefault();
                                                          }),
                                                        )
                                                      : _renderImageFoodDefault()),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 4,
                                            right: 0,
                                            height: 40,
                                            child: FloatingActionButton(
                                              heroTag: _foodPhotoUrl,
                                              child: Icon(
                                                Icons.edit,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                              backgroundColor: Colors.blue,
                                              onPressed: () {
                                                _showPicker(
                                                    context, 'FOOD_PHOTO');
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            child: Container(
                                              height: 100,
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: ClipRect(
                                                    child: _nutritionalInfoPhotoUrl !=
                                                            null
                                                        ? Image.network(
                                                            "$IMAGE_BASE_URL/nutritionalInfo/thumb_$_nutritionalInfoPhotoUrl",
                                                            fit: BoxFit.cover,
                                                            errorBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Object
                                                                        exception,
                                                                    StackTrace
                                                                        stackTrace) {
                                                            return _renderImageNutriDefault();
                                                          })
                                                        : _renderImageNutriDefault()),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 4,
                                            right: 0,
                                            height: 40,
                                            child: FloatingActionButton(
                                              heroTag: _nutritionalInfoPhotoUrl,
                                              child: Icon(
                                                Icons.edit,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                              backgroundColor: Colors.blue,
                                              onPressed: () {
                                                _showPicker(context,
                                                    'NUTRI_INFO_PHOTO');
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Stack(
                                children: <Widget>[
                                  DropdownButton(
                                    value: _type,
                                    hint: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 50,
                                      ),
                                      child: Text(
                                        "Tipo de Refeição *",
                                        style: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    icon: Icon(Icons.arrow_drop_down, color: Color(0xFFA3E1CB),),
                                    onChanged: (newValue) {
                                      setState(() {
                                        _type = newValue;
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
                                        color: Color(0xFFA3E1CB),
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      initialValue:
                                          this.widget.meal.quantity.toString(),
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFA3E1CB)),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.check_circle,
                                          color: Color(0xFFA3E1CB),
                                        ),
                                        hintText: "Quant. *",
                                        labelText: 'Quant. *',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
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
                                            value: _unit,
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
                                            icon: Icon(Icons.arrow_drop_down, color: Color(0xFFA3E1CB)),
                                            onChanged: (newValue) {
                                              setState(() {
                                                _unit = newValue;
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16),
                                                  child:
                                                      Text(value.description),
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
                                                color: Color(0xFFA3E1CB),
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
                                                color: Color(0xFFA3E1CB),
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
                                initialValue: this.widget.meal.observations,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFA3E1CB)),
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
                                          top: 8,
                                          bottom: 8,
                                          left: 10,
                                          right: 10),
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
                                    color: Color(0xFFA3E1CB),
                                    disabledColor: Colors.grey,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(20.0)),
                                    onPressed: () {
                                      if (!_formKey.currentState.validate() ||
                                          _name == null ||
                                          _name.trim() == "" ||
                                          _type == null ||
                                          _type.trim() == "" ||
                                          _quantity == null ||
                                          _quantity.trim == "" ||
                                          _unit == null ||
                                          _unit == "") {
                                        setState(() {
                                          _showError = true;
                                        });
                                        return;
                                      }

                                      if (_unit == "Outro" &&
                                          (_observations == "" ||
                                              _observations == null)) {
                                        _showAdditionalInformationDialog();
                                        return;
                                      }
                                      _updateMeal();
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
                ),
              ),
      ),
    );
  }

  Future _updateMeal() async {
    var isShowMessage = false;
    var message = "Ocorreu um erro ao adicionar a refeição";
    if (_isLoading) return;

    this.setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network().putWithAuth({
        'name': _name,
        'quantity': _quantity,
        'relativeUnit': _unit,
        'type': _type,
        'date': _date.toIso8601String(),
        'time':
            "${_time.hour}:${_time.minute > 9 ? _time.minute : "0${_time.minute}"}",
        'observations': _observations
      }, MEALS_UPDATE_URL, this.widget.meal.id);

      var body = json.decode(response.body);

      if (response.statusCode == RESPONSE_SUCCESS) {
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
    if (pickedFile != null) {
      await _submitPhoto(type, File(pickedFile.path));
    }
  }

  Future _submitPhoto(String type, File file) async {
    try {
      if (_isLoading) return;
      this.setState(() {
        _isLoading = true;
      });

      var response = await Network().postImageFormData(
          file, "$MEAL_URL/${this.widget.meal.id}/$PHOTOS_URL", type);

      this.setState(() {
        _isLoading = false;
      });

      print(response.statusCode);

      if (response.statusCode == RESPONSE_SUCCESS) {
        var data = json.decode(response.body)[JSON_DATA_KEY];
        print(data);

        if (type == 'NUTRI_INFO_PHOTO') {
          this.setState(() {
            _nutritionalInfoPhotoUrl = data;
          });
          return;
        }

        this.setState(() {
          _foodPhotoUrl = data;
        });
      }
    } catch (error) {
      print(error);
      this.setState(() {
        _isLoading = false;
      });
    }
    /*
    try {
      var response = await Network()
          .postMeal(meal, _foodPhoto, _nutritionalInfoPhoto, _userId, MEAL_URL);

      var body = json.decode(response.body);
      print(response.statusCode);

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
      } else {
        isShowMessage = true;
        if (body[JSON_ERROR_KEY] != null) message = (body[JSON_ERROR_KEY]);
      }
    } catch (error) {
      isShowMessage = true;
    }
     */
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
            content: TextFormField(
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
                  _updateMeal();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
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
