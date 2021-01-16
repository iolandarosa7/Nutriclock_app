import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/screens/navigation/chat/MessageHistoryFragment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatFragment extends StatefulWidget {
  ChatFragment({Key key}) : super(key: key);
  @override
  _ChatFragmentState createState() => _ChatFragmentState();
}

class _ChatFragmentState extends State<ChatFragment> {
  var _isLoading = false;
  List<User> _professionals = [];
  User authUser;
  var channel = IOWebSocketChannel.connect(WEBSOCKET_URL);
  var _shouldConnect = true;

  @override
  void initState() {
    _loadUser();
    _getProfessionalsByUsf();
    channel.stream.listen(this.onData, onError: this.onError, onDone: this.onDone);
    super.initState();
  }

  onDone() {
    debugPrint("Socket is closed");
    if (_shouldConnect) connectToSocket();
  }

  onError(err) {
    var exception = err as WebSocketChannelException;
    print("socket error ${err.runtimeType.toString()} ${exception.message}");
  }

  onData(event) {
    var parsedArray = event.toString().replaceAll("'", "").split(":");
    var senderId = parsedArray[3].split(",")[0].trim();
    var receiverId = parsedArray[6].split(",")[0].trim();

    if (int.parse(senderId) == authUser.id || int.parse(receiverId) == authUser.id) {
      _getProfessionalsByUsf();
    }
  }


  @override
  void dispose() {
    _shouldConnect = false;
    channel.sink.close();
    super.dispose();
  }

  connectToSocket() {
    channel = IOWebSocketChannel.connect(WEBSOCKET_URL);
    print('socket connect');
  }

  _loadUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var storeUser = localStorage.getString(LOCAL_STORAGE_USER_KEY);

    if (storeUser != null) {
      User user = User.fromJson(json.decode(storeUser));
      this.authUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
        child: Loading(
            indicator: BallPulseIndicator(),
            size: 50.0,
            color: Colors.orangeAccent),
      )
          : ListView.builder(
          padding:
          const EdgeInsets.only(top: 16, left: 8, bottom: 8, right: 8),
          itemCount: _professionals.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                leading: _professionals[index].unreadMessages > 0
                    ? Badge(
                  shape: BadgeShape.circle,
                  badgeColor: Colors.redAccent,
                  badgeContent: Text(
                      "${_professionals[index].unreadMessages}",
                      style: TextStyle(color: Colors.white)),
                )
                    : SizedBox(),
                trailing: Icon(
                  Icons.chat_rounded,
                  color: Color(0xFF74D44D),
                ),
                title: Text('${_professionals[index].name}'),
                onTap: () =>
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MessageHistoryFragment(user: _professionals[index])
                    ),
                  ).then((value) => {_getProfessionalsByUsf()})
                },
              ),
            );
          }),
    );
  }

  _getProfessionalsByUsf() async {
    List<User> list = [];

    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var storeUser = localStorage.getString(LOCAL_STORAGE_USER_KEY);

    if (storeUser != null) {
      User user = User.fromJson(json.decode(storeUser));
      try {
        var response =
        await Network().getWithAuth("$PROFESSIONALS_BY_USF/${user.ufc_id}");

        if (response.statusCode == RESPONSE_SUCCESS) {
          List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];

          data.forEach((element) {
            User user = User.fromJson(element);
            list.add(user);
          });

          this.setState(() {
            _professionals = list;
          });
        } else {}
      } catch (error) {}

      this.setState(() {
        _isLoading = false;
      });
    }
  }
}
