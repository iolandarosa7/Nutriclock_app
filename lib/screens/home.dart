import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/screens/drawer/BioMarkersFragment.dart';
import 'package:nutriclock_app/screens/drawer/ContactsFragment.dart';
import 'package:nutriclock_app/screens/drawer/mealPlan/FoodPlanFragment.dart';
import 'package:nutriclock_app/screens/navigation/HomeFragment.dart';
import 'package:nutriclock_app/screens/drawer/ReportsFragment.dart';
import 'package:nutriclock_app/screens/login.dart';
import 'package:nutriclock_app/screens/navigation/exercise/ExerciseCalendarFragment.dart';
import 'package:nutriclock_app/screens/navigation/chat/ChatFragment.dart';
import 'package:nutriclock_app/screens/navigation/meals/MealsFragment.dart';
import 'package:nutriclock_app/screens/navigation/sleep/SleepFragment.dart';
import 'package:nutriclock_app/screens/settings/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _name = '';
  String _email = '';
  String _avatarUrl = '';
  var _id = -1;
  String _title = '';
  int _selectedIndex = 0;
  int _currentIndex = 0;
  var channel = IOWebSocketChannel.connect(WEBSOCKET_URL);
  var _shouldConnect = true;
  var _totalUnread = 0;

  @override
  void initState() {
    _loadUserData();
    _getUnreadMessages();
    channel.stream
        .listen(this.onData, onError: this.onError, onDone: this.onDone);
    super.initState();
  }

  onDone() {
    if (_shouldConnect) connectToSocket();
  }

  onError(err) {
    var exception = err as WebSocketChannelException;
    print("socket error ${err.runtimeType.toString()} ${exception.message}");
  }

  @override
  void dispose() {
    _shouldConnect = false;
    channel.sink.close();
    super.dispose();
  }

  connectToSocket() {
    channel = IOWebSocketChannel.connect(WEBSOCKET_URL);
  }

  onData(event) {
    var parsedArray = event.toString().replaceAll("'", "").split(":");
    var receiverId = parsedArray[6].split(",")[0].trim();
    var senderId = parsedArray[3].split(",")[0].trim();
    if (receiverId == _id.toString() || senderId == _id.toString()) {
      _getUnreadMessages();
    }
  }

  _getUnreadMessages() async {
    try {
      var response = await Network().getWithAuth(MESSAGES_UNREAD_URL);
      if (response.statusCode == RESPONSE_SUCCESS) {
        var count = json.decode(response.body)[JSON_DATA_KEY];
        this.setState(() {
          _totalUnread = count;
        });
      }
    } catch (error) {}
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var storeUser = localStorage.getString(LOCAL_STORAGE_USER_KEY);

    if (storeUser != null) {
      User user = User.fromJson(json.decode(storeUser));
      var avatarUrl = '';

      if (user.avatarUrl != null) {
        avatarUrl = "$IMAGE_BASE_URL/avatars/${user.avatarUrl}";
      }

      setState(() {
        _name = user.name;
        _email = user.email;
        _avatarUrl = avatarUrl;
        _id = user.id;
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
    ExerciseCalendarFragment(),
    ChatFragment(),
    ReportsFragment(),
    FoodPlanFragment(),
    ContactsFragment(),
    BioMarkersFragment(),
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
        backgroundColor: Color(0xFFA3E1CB),
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
          color: Color(0xFF60B2A3),
          opacity: 1,
        ),
        unselectedIconTheme: IconThemeData(
          color: Color(0xFFA3E1CB),
          opacity: 0.6,
        ),
        selectedItemColor: Color(0xFF60B2A3),
        items: [
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
          _totalUnread > 0
              ? BottomNavigationBarItem(
                  icon: Icon(
                    Icons.mark_chat_unread,
                  ),
                  label: 'Chat',
                )
              : BottomNavigationBarItem(
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
                backgroundColor: Color(0xFFC1FECB),
                onBackgroundImageError: (_, __) {},
              ),
              accountName: new Text(
                this._name,
                style: TextStyle(color: Color(0xFFA3E1CB)),
              ),
              accountEmail: new Text(this._email,
                  style: TextStyle(color: Color(0xFF60B2A3))),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg_drawer.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            new Column(children: [
              ListTile(
                leading: Icon(
                  Icons.insert_chart,
                  color: Color(0xFFA3E1CB),
                ),
                title: Text(
                  'Relatórios',
                  style: TextStyle(color: Color(0xFF60B2A3)),
                ),
                onTap: () => _onSelectItem(5, "Relatórios"),
              ),
              ListTile(
                leading: Icon(
                  Icons.restaurant,
                  color: Color(0xFFA3E1CB),
                ),
                title: Text('Plano Alimentar',
                    style: TextStyle(color: Color(0xFF60B2A3))),
                onTap: () => _onSelectItem(6, "Plano Alimentar"),
              ),
              ListTile(
                leading: Icon(
                  Icons.email,
                  color: Color(0xFFA3E1CB),
                ),
                title: Text('Contactos',
                    style: TextStyle(color: Color(0xFF60B2A3))),
                onTap: () => _onSelectItem(7, "Contactos"),
              ),
              ListTile(
                leading: Icon(
                  Icons.accessibility,
                  color: Color(0xFFA3E1CB),
                ),
                title: Text('Biomarcadores',
                    style: TextStyle(color: Color(0xFF60B2A3))),
                onTap: () => _onSelectItem(8, "Biomarcadores"),
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
