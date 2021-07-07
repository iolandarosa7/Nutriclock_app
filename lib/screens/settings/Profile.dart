import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/models/Usf.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/screens/settings/Diseases.dart';
import 'package:nutriclock_app/screens/settings/Medication.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';
import 'package:nutriclock_app/utils/DropMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final picker = ImagePicker();
  final dateFormat = new DateFormat('dd/MM/yyyy');
  List<DropMenu> _genderList = [
    DropMenu('MALE', 'Masculino'),
    DropMenu('FEMALE', 'Feminino'),
    DropMenu('NONE', 'Não me identifico')
  ];
  DateTime selectedDate = DateTime.now();
  List<Usf> _usfs = [];
  bool _isLoading = false;
  User _user = User();
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
      appBar: AppBar(
        title: Text(
          "Perfil",
          style: TextStyle(
            fontFamily: 'Pacifico',
          ),
        ),
        backgroundColor: Color(0xFFA3E1CB),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.medical_services_rounded),
            tooltip: 'Medicamentos / Suplementos',
            onPressed: () {
              openDiseasesList(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.healing),
            tooltip: 'Patologias / Alergias',
            onPressed: () {
              openMedicationList(context);
            },
          ),
        ],
      ),
      body: appWidget.getImageContainer(
        "assets/images/bg_profile.png",
        _isLoading,
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 4.0,
                        color: Colors.white,
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 40.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Form(
                                key: _formKey,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 24,
                                  ),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        initialValue: _user.name,
                                        style: TextStyle(
                                          color: Color(0xFF000000),
                                        ),
                                        cursorColor: Color(0xFF9b9b9b),
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFA3E1CB),
                                            ),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.person,
                                            color: Color(0xFFA3E1CB),
                                          ),
                                          labelText: 'Nome',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        validator: (nameValue) {
                                          if (nameValue.isEmpty) {
                                            return ERROR_MANDATORY_FIELD;
                                          }
                                          _user.name = nameValue;
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Stack(
                                        children: <Widget>[
                                          DropdownButton(
                                            value: _user.ufc_id,
                                            hint: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 50),
                                              child: Text(
                                                "Unidade Saúde Familiar",
                                                style: TextStyle(
                                                  color: Color(0xFF9b9b9b),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: Color(0xFFA3E1CB),
                                            ),
                                            onChanged: (newValue) {
                                              setState(() {
                                                _user.ufc_id = newValue;
                                              });
                                            },
                                            isExpanded: true,
                                            items: _usfs
                                                .map<DropdownMenuItem<int>>(
                                                    (Usf value) {
                                              return DropdownMenuItem<int>(
                                                value: value.id,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 50),
                                                  child: Text(value.name),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 10),
                                              child: Icon(
                                                Icons.home_work_sharp,
                                                color: Color(0xFFA3E1CB),
                                              )),
                                        ],
                                      ),
                                      Stack(
                                        children: <Widget>[
                                          DropdownButton(
                                            value: _user.gender,
                                            hint: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 50),
                                              child: Text(
                                                "Género",
                                                style: TextStyle(
                                                  color: Color(0xFF9b9b9b),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: Color(0xFFA3E1CB),
                                            ),
                                            onChanged: (newValue) {
                                              setState(() {
                                                _user.gender = newValue;
                                              });
                                            },
                                            isExpanded: true,
                                            items: _genderList
                                                .map<DropdownMenuItem<String>>(
                                                    (DropMenu item) {
                                              return DropdownMenuItem<String>(
                                                value: item.value,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 50),
                                                  child: Text(item.description),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 10),
                                              child: Icon(
                                                Icons.wc,
                                                color: Color(0xFFA3E1CB),
                                              )),
                                        ],
                                      ),
                                      Column(
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
                                                  padding: EdgeInsets.only(
                                                      left: 16.0),
                                                  child: Text(
                                                    'Data de Nascimento',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          TextButton(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 35.0),
                                              child: Text(
                                                dateFormat.format(selectedDate),
                                                style: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              _selectDate(context);
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: TextFormField(
                                              initialValue:
                                                  _user.weight.toString(),
                                              style: TextStyle(
                                                  color: Color(0xFF000000)),
                                              cursorColor: Color(0xFF9b9b9b),
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFFA3E1CB)),
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.accessibility,
                                                  color: Color(0xFFA3E1CB),
                                                ),
                                                suffix: Text(
                                                  'kg',
                                                  style: TextStyle(
                                                      color: Color(0xFF000000)),
                                                ),
                                                labelText: 'Peso',
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                hintStyle: TextStyle(
                                                    color: Color(0xFF9b9b9b),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              validator: (weightValue) {
                                                if (weightValue.isNotEmpty &&
                                                    double.tryParse(
                                                            weightValue) ==
                                                        null) {
                                                  return ERROR_INVALID_FORMAT_FIELD;
                                                }

                                                if (weightValue.isNotEmpty &&
                                                    double.tryParse(
                                                            weightValue) <=
                                                        0) {
                                                  return ERROR_NEGATIVE_VALUE;
                                                }
                                                _user.weight = weightValue;
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: TextFormField(
                                              initialValue:
                                                  _user.height.toString(),
                                              style: TextStyle(
                                                  color: Color(0xFF000000)),
                                              cursorColor: Color(0xFF9b9b9b),
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFFA3E1CB)),
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.swap_vert,
                                                  color: Color(0xFFA3E1CB),
                                                ),
                                                suffix: Text(
                                                  'cm',
                                                  style: TextStyle(
                                                      color: Color(0xFF000000)),
                                                ),
                                                labelText: 'Altura',
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                hintStyle: TextStyle(
                                                    color: Color(0xFF9b9b9b),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              validator: (heightValue) {
                                                if (heightValue.isNotEmpty &&
                                                    double.tryParse(
                                                            heightValue) ==
                                                        null) {
                                                  return ERROR_INVALID_FORMAT_FIELD;
                                                }

                                                if (heightValue.isNotEmpty &&
                                                    double.tryParse(
                                                            heightValue) <=
                                                        0) {
                                                  return ERROR_NEGATIVE_VALUE;
                                                }

                                                _user.height = heightValue;
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 24.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: TextButton(
                                            child: Text(
                                              _isLoading
                                                  ? 'Aguarde...'
                                                  : 'Guardar Perfil',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0,
                                                decoration: TextDecoration.none,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFFA3E1CB),
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                  20.0,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                _updateUser();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
              Positioned(
                top: 8,
                right: 24,
                child: _user != null
                    ? Center(
                        child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: _user.avatarUrl != null
                                  ? Image.network(
                                      "$IMAGE_BASE_URL/avatars/${_user.avatarUrl}",
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace stackTrace) {
                                        return _renderImageDefault();
                                      },
                                    )
                                  : _renderImageDefault(),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openMedicationList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicationList(),
      ),
    );
  }

  void openDiseasesList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Diseases(),
      ),
    );
  }

  Widget _renderImageDefault() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border(
          top: BorderSide(color: Colors.white),
          left: BorderSide(color: Colors.white),
        ),
      ),
      child: Icon(
        Icons.image_rounded,
        color: Colors.grey[800],
      ),
    );
  }

  void _loadDataFromServer() async {
    List<Usf> list = [];
    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    try {
      var response = await Network().getWithoutAuth(USF_URL);

      if (response.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];

        data.forEach((element) {
          Usf usf = Usf.fromJson(element);
          list.add(usf);
        });

        this.setState(() {
          _usfs = list;
        });
      }

      SharedPreferences localStorage = await SharedPreferences.getInstance();

      var storeUser = localStorage.getString(LOCAL_STORAGE_USER_KEY);

      if (storeUser != null) {
        User user = User.fromJson(json.decode(storeUser));
        this.setState(() {
          _user = user;
          selectedDate = DateTime.parse(_user.birthday);
        });
      }
    } catch (error) {}

    setState(() {
      _isLoading = false;
    });
  }

  void _showPicker(context) {
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
                        getImage(ImageSource.gallery);
                        Navigator.pop(context);
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Câmara'),
                    onTap: () {
                      getImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      if (!this._isLoading) {
        var isShowMessage = false;
        this.setState(() {
          _isLoading = true;
        });
        try {
          var response = await Network()
              .updateAvatar(USERS_AVATAR_URL, File(pickedFile.path));

          if (response.statusCode == RESPONSE_SUCCESS) {
            var data = User.fromJson(json.decode(response.body)[JSON_DATA_KEY]);

            SharedPreferences localStorage =
                await SharedPreferences.getInstance();
            localStorage.setString(LOCAL_STORAGE_USER_KEY, json.encode(data));

            this.setState(() {
              _user = data;
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
          appWidget.showSnackbar(
              "Ocorreu um erro no upload", Colors.red, _scaffoldKey);
      }
    }
  }

  _updateUser() async {
    var isShowMessage = false;

    if (!this._isLoading) {
      this.setState(() {
        _isLoading = true;
      });

      try {
        var response = await Network().postWithAuth({
          'name': _user.name,
          'gender': _user.gender,
          'weight': _user.weight,
          'height': _user.height,
          'birthday': _user.birthday
        }, USERS_PROFILE_URL);

        if (response.statusCode == RESPONSE_SUCCESS) {
          var data = User.fromJson(json.decode(response.body)[JSON_DATA_KEY]);

          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.setString(LOCAL_STORAGE_USER_KEY, json.encode(data));

          this.setState(() {
            _user = data;
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
        appWidget.showSnackbar("Ocorreu um erro na atualização do perfil",
            Colors.red, _scaffoldKey);
    }
  }

  void _selectDate(BuildContext context) async {
    final ThemeData themeData = Theme.of(context);
    assert(themeData.platform != null);

    switch (themeData.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }
  }

  void buildMaterialDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: this.selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      cancelText: 'Cancelar',
      locale: Locale('pt', 'PT'),
      fieldLabelText: 'Data de Nascimento',
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void buildCupertinoDatePicker(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                  });
              },
              initialDateTime: selectedDate,
              minimumYear: 1900,
              maximumDate: DateTime.now(),
            ),
          );
        });
  }
}
