import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/screens/navigation/chat/MessageHistoryFragment.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';
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
  var appWidget = AppWidget();

  @override
  void initState() {
    _getProfessionalsByUsf();
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

  onData(event) {
    var parsedArray = event.toString().replaceAll("'", "").split(":");
    var type = parsedArray[1].split(",")[0].trim();
    var senderId = parsedArray[3].split(",")[0].trim();
    var receiverId = parsedArray[6].split(",")[0].trim();

    if (int.parse(senderId) == authUser.id ||
        int.parse(receiverId) == authUser.id) {
      if (type == 'update') return;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appWidget.getImageContainer(
        "assets/images/bg_chat.png",
        _isLoading,
        ListView.builder(
            padding:
                const EdgeInsets.only(top: 16, left: 0, bottom: 8, right: 16),
            itemCount: _professionals.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
                margin: EdgeInsets.only(bottom: 10, top: 20),
                shadowColor: Color(0xFFFFBCBC),
                elevation: 10,
                child: ListTile(
                  leading: Image.network(
                    "$IMAGE_BASE_URL/avatars/${_professionals[index].avatarUrl}",
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return _renderImageDefault();
                    },
                  ),
                  title: Text(
                    '${_professionals[index].name}',
                    style: TextStyle(fontFamily: 'PatrickHand', fontSize: 20),
                  ),
                  trailing: _professionals[index].unreadMessages > 0
                      ? Icon(
                          Icons.mark_chat_unread,
                          color: Color(0xFFFFBCBC),
                        )
                      : Icon(
                          Icons.chat_bubble_outlined,
                          color: Color(0xFFA3E1CB),
                        ),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MessageHistoryFragment(
                              user: _professionals[index])),
                    ).then((value) => {_getProfessionalsByUsf()})
                  },
                ),
              );
            }),
       Color(0xFF45C393),
      ),
    );
  }

  Widget _renderImageDefault() {
    return Container(
      child: Icon(
        Icons.image_rounded,
      ),
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
            authUser = user;
          });
        } else {}
      } catch (error) {}

      this.setState(() {
        _isLoading = false;
      });
    }
  }
}
