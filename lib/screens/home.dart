import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/screens/drawer/ContactsFragment.dart';
import 'package:nutriclock_app/screens/drawer/FoodPlanFragment.dart';
import 'package:nutriclock_app/screens/drawer/HomeFragment.dart';
import 'package:nutriclock_app/screens/drawer/ReportsFragment.dart';
import 'package:nutriclock_app/screens/login.dart';
import 'package:nutriclock_app/screens/navigation/ChatFragment.dart';
import 'package:nutriclock_app/screens/navigation/ExerciseFragment.dart';
import 'package:nutriclock_app/screens/navigation/MealsFragment.dart';
import 'package:nutriclock_app/screens/navigation/SleepFragment.dart';
import 'package:nutriclock_app/screens/settings/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _name = '';
  String _email = '';
  String _avatarUrl = '';
  String _title = '';
  int _selectedIndex = 0;
  int _currentIndex = 0;

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var storeUser = localStorage.getString(LOCAL_STORAGE_USER_KEY);

    if (storeUser != null) {
      User user = User.fromJson(json.decode(storeUser));
      var avatarUrl = '';

      if (user.avatarUrl != null) {
        avatarUrl = "$BASE_URL/storage/avatars/${user.avatarUrl}";
      }

      setState(() {
        _name = user.name;
        _email = user.email;
        _avatarUrl = avatarUrl;
      });
    }
  }

  void _onItemTapped(int index) {
    var title = "";

    switch (index) {
      case 1:
        title = "Diário Alimentar";
        break;
      case 2:
        title = "Sono";
        break;
      case 3:
        title = "Exercício";
        break;
      case 4:
        title = "Chat";
        break;
      default:
        title = "";
    }
    setState(() => {
          _currentIndex = index,
        });
    setState(() => {_selectedIndex = index, _title = title});
  }

  _onSelectItem(int i, String title) {
    setState(() => {_currentIndex = i, _title = title});
    if (i < 3) {
      setState(() => _selectedIndex = i);
    }
    Navigator.of(context).pop(); // close the drawer
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SnackBar snackBar = const SnackBar(content: Text('Showing Snackbar'));

  void openPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsList()),
    );
  }

  List<Widget> _widgetOptions = <Widget>[
    HomeFragment(),
    MealsFragment(),
    SleepFragment(),
    ExerciseFragment(),
    ChatFragment(),
    ReportsFragment(),
    FoodPlanFragment(),
    ContactsFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: TextStyle(
            fontFamily: 'Pacifico',
          ),
        ),
        backgroundColor: Color(0xFF74D44D),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Definições',
            onPressed: () {
              openPage(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.input),
            tooltip: 'Logout',
            onPressed: () {
              _logout();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(
          color: Color(0xFF74D44D),
          opacity: 1,
        ),
        unselectedIconTheme: IconThemeData(
          color: Color(0xFF74D44D),
          opacity: 0.6,
        ),
        selectedItemColor: Color(0xFF74D44D),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ramen_dining),
            label: 'Diário',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bedtime),
            label: 'Sono',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Exercício',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(_avatarUrl),
                backgroundColor: Color(0xFF74D44D),
              ),
              accountName: new Text(this._name),
              accountEmail: new Text(this._email),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0x6074D44D), Color(0xFF74D44D)]),
              ),
            ),
            new Column(children: [
              ListTile(
                leading: Icon(
                  Icons.insert_chart,
                ),
                title: Text(
                  'Relatórios',
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () => _onSelectItem(5, "Relatórios"),
              ),
              ListTile(
                leading: Icon(Icons.restaurant),
                title: Text('Plano Alimentar',
                    style: TextStyle(color: Colors.grey)),
                onTap: () => _onSelectItem(6, "Plano Alimentar"),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text('Contactos', style: TextStyle(color: Colors.grey)),
                onTap: () => _onSelectItem(7, "Contactos"),
              ),
            ])
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_currentIndex),
      ),
    );
  }

  void _logout() async {
    try {
      await Network().getWithAuth(LOGOUT_URL);
    } catch (error) {}

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove(LOCAL_STORAGE_USER_KEY);
    localStorage.remove(LOCAL_STORAGE_TOKEN_KEY);

    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (context) => Login()),
    );
  }
}
