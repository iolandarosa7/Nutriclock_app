import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Drug.dart';
import 'package:nutriclock_app/network_utils/api.dart';

class MedicationList extends StatefulWidget {
  @override
  _MedicationListState createState() => _MedicationListState();
}

class _MedicationListState extends State<MedicationList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Drug> _medications = [];
  List<Drug> _suplements = [];
  var _isLoading = false;

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
            onPressed: () {
              _addNewMedication();
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

  _addNewMedication() {}

  Widget _renderMedications() {
    return Container(
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
          : _suplements.length == 0
              ? _renderNoData('Não existem medicamentos registados')
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Column(children: _renderDrug(_suplements)),
                  ),
                ),
    );
  }

  Widget _renderSuplements() {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg_home_r.jpg"),
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
          : _suplements.length == 0
              ? _renderNoData('Não existem suplementos registados')
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Column(children: _renderDrug(_suplements)),
                  ),
                ),
    );
  }

  Widget _renderNoData(String message) {
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
              message,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _renderDrug(List<Drug> drugs) {
    List<Widget> list = List();
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
                              // this._showUpdateModal(i);
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
                              // this._showDeleteConfirmation(i);
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

  void _loadDataFromServer() async {
    List<Drug> medications = [];
    List<Drug> suplements = [];

    print('load data');

    if (_isLoading) return;

    this.setState(() {
      _isLoading = true;
    });

    print('load data after');

    try {
      var response = await Network().getWithAuth(MEDICATION_AUTH_URL);

      print(response.statusCode);

      if (response.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];

        print(data);

        data.forEach((element) {
          Drug m = Drug.fromJson(element);
          print(m);
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
