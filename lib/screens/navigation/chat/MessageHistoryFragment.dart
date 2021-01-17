import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Message.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageHistoryFragment extends StatefulWidget {
  final User user;

  MessageHistoryFragment({Key key, @required this.user}) : super(key: key);

  @override
  _MessageHistoryFragmentState createState() => _MessageHistoryFragmentState();
}

class _MessageHistoryFragmentState extends State<MessageHistoryFragment> {
  var _isLoading = false;
  var _response;
  User authUser;
  List<Message> _messages = [];
  var channel = IOWebSocketChannel.connect(WEBSOCKET_URL);
  var _shouldConnect = true;
  var _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    _loadData();
    channel.stream.listen(this.onData, onError: this.onError, onDone: this.onDone);
    super.initState();
  }

  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        debugPrint("reach the top 1");
      });
      _loadData();
    }
  }

  onDone() {
    debugPrint("Socket is closed");
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
    print('socket connect');
  }

  onData(event) {
    var parsedArray = event.toString().replaceAll("'", "").split(":");
    var senderId = parsedArray[3].split(",")[0].trim();
    var senderName = parsedArray[4].split(",")[0].trim();
    var senderPhotoUrl = parsedArray[5].split(",")[0].trim();
    var receiverId = parsedArray[6].split(",")[0].trim();
    var receiverName = parsedArray[7].split(",")[0].trim();
    var receiverPhotoUrl = parsedArray[8].split(",")[0].trim();
    var message = parsedArray[9].split(",")[0].trim();

    if (receiverId == authUser.id.toString() ||
        senderId == authUser.id.toString()) {
      var m = Message();
      m.created_at = new DateTime.now().toIso8601String();
      m.senderId = int.parse(senderId);
      m.senderName = senderName;
      m.senderPhotoUrl = senderPhotoUrl;
      m.receiverId = int.parse(receiverId);
      m.receiverName = receiverName;
      m.receiverPhotoUrl = receiverPhotoUrl;
      m.message = message;
      m.refMessageId = null;
      m.read = 0;
      _addMessage(m);
    }
  }

  _addMessage(Message message) {
    var auxMessages = _messages;
    auxMessages.add(message);
    this.setState(() {
      _messages = auxMessages;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Histórico de Mensagens",
          style: TextStyle(
            fontFamily: 'Pacifico',
          ),
        ),
        backgroundColor: Color(0xFF74D44D),
      ),
      body: Container(
        child: _isLoading
            ? Center(
                child: Loading(
                  indicator: BallPulseIndicator(),
                  size: 50.0,
                  color: Colors.orangeAccent,
                ),
              )
            : Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: 110,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      controller: _scrollController,
                      child: _messages == null || _messages.length == 0
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Text(
                                    "Não existe histórico de mensagens.",
                                    style: TextStyle(
                                        fontFamily: 'Neucha',
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: data(),
                            ),
                    ),
                  ),
                  Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        right: 70,
                        left: 10,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.multiline,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  labelText: 'Escreva a mensagem a enviar...',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFA3DC92)),
                                  ),
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return ERROR_MANDATORY_FIELD;
                                  }
                                  _response = value;
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 60,
                        right: 5,
                        child: FloatingActionButton(
                          onPressed: () => {
                            if (_formKey.currentState.validate())
                              {_postNewMessage()}
                          },
                          backgroundColor: Color(0xFF74D44D),
                          child: Icon(
                            Icons.send,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }

  _getRefMessageId() {
    if (_messages != null && _messages.length > 0) {
      return _messages[_messages.length - 1].id;
    }
    return null;
  }

  _postNewMessage() async {
    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    var messageId = _getRefMessageId();

    var messageToSend = {
      'senderId': authUser.id,
      'senderName': authUser.name,
      'senderPhotoUrl': authUser.avatarUrl,
      'receiverId': this.widget.user.id,
      'receiverName': this.widget.user.name,
      'receiverPhotoUrl': this.widget.user.avatarUrl,
      'message': _response,
      'read': false,
      'refMessageId': messageId,
      'fromModal': false,
    };
    try {
      var response = await Network().postWithAuth(messageToSend, "$MESSAGES");
      if (response.statusCode == RESPONSE_SUCCESS_201) {
        this.channel.sink.add("\"{type:\'store\',message:$messageToSend}\"");
      }
      this.setState(() {
        _isLoading = false;
      });
    } catch (error) {
      this.setState(() {
        _isLoading = false;
      });
    }
  }

  _loadData() async {
    List<Message> list = _messages;
    if (_isLoading) return;
    this.setState(() {
      _isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var storeUser = localStorage.getString(LOCAL_STORAGE_USER_KEY);

    if (storeUser != null) {
      User user = User.fromJson(json.decode(storeUser));
      try {
        var response = await Network()
            .getWithAuth("$MESSAGES_FROM_USER/${widget.user.id}?skip=${_messages.length}");

        print(response.statusCode);

        if (response.statusCode == RESPONSE_SUCCESS) {
          List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];

          data.forEach((element) {
            Message m = Message.fromJson(element);
            list.insert(0, m);
          });

          this.setState(() {
            _messages = _messages;
            authUser = user;
          });
        } else {}
      } catch (error) {}

      this.setState(() {
        _isLoading = false;
      });
    }
  }

  List<Widget> data() {
    List<Widget> list = List();
    _messages.forEach((element) {
      list.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: element.senderId == authUser.id
              ? _renderMyMessage(element)
              : _renderUserMessage(element),
        ),
      );
    });
    return list;
  }

  _renderMyMessage(Message message) {
    return Padding(
      padding: EdgeInsets.only(right: 50),
      child: Card(
        color: Color(0xFFcff6cf),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Eu, ${message.created_at}",
                style: TextStyle(
                    fontFamily: 'Neucha', fontSize: 12, color: Colors.black54),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                message.message,
                style: TextStyle(
                    fontFamily: 'Neucha', fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  _renderUserMessage(Message message) {
    return Padding(
      padding: EdgeInsets.only(left: 50),
      child: Card(
        color: Color(0xFFddf3f5),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  message.read == 0
                      ? Badge(
                          badgeColor: Colors.redAccent,
                          badgeContent: Text(""),
                        )
                      : SizedBox(),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "${message.senderName}, ${message.created_at}",
                    style: TextStyle(
                        fontFamily: 'PatrickHand',
                        fontSize: 12,
                        color: Colors.black54),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                message.message,
                style: TextStyle(
                    fontFamily: 'PatrickHand',
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
