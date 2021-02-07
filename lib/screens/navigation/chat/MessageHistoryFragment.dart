import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/Message.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';
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
  var hasMore = true;
  final dateFormat = new DateFormat('dd/MM/yyyy hh:mm');
  var appWidget = AppWidget();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    _loadData();
    channel.stream
        .listen(this.onData, onError: this.onError, onDone: this.onDone);
    super.initState();
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (hasMore) _loadData();
    }
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
    var type = parsedArray[1].split(",")[0].trim();
    var senderId = parsedArray[3].split(",")[0].trim();
    var receiverId = parsedArray[6].split(",")[0].trim();
    var message = parsedArray[9].split(",")[0].trim();
    var id = parsedArray[parsedArray.length - 1].split("}")[0].trim();

    if (senderId == authUser.id.toString() && type == 'store') return;

    if (receiverId == authUser.id.toString() ||
        senderId == authUser.id.toString()) {
      if (type == 'store') {
        setState(() {
          _messages = [];
        });
        _loadData();
      } else if (type == 'update') {
        var aux = _messages;
        aux.forEach((element) {
          if (element.id == int.parse(id)) {
            element.message = message;
          }
        });

        this.setState(() {
          _messages = aux;
        });
      } else if (type == 'delete') {
        var selectedMessage;
        var aux = _messages;
        aux.forEach((element) {
          if (element.id == int.parse(id)) {
            selectedMessage = element;
          }
        });
        aux.remove(selectedMessage);
        this.setState(() {
          _messages = aux;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: appWidget.getAppbar("Histórico de Mensagens"),
      body: appWidget.getImageContainer(
        "assets/images/bg_chat.jpg",
        _isLoading,
        Stack(
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
                          child: Text("Não existe histórico de mensagens.",
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
                  right: 0,
                  left: 0,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          style: TextStyle(color: Color(0xFF000000)),
                          cursorColor: Color(0xFF9b9b9b),
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Escreva a mensagem a enviar...',
                            labelStyle: TextStyle(color: Colors.grey),
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
                  bottom: 70,
                  right: 5,
                  child: FloatingActionButton(
                    onPressed: () => {
                      if (_formKey.currentState.validate()) {_postNewMessage()}
                    },
                    backgroundColor: Color(0xFFA3E1CB),
                    child: Icon(
                      Icons.send,
                    ),
                  ),
                ),
              ],
            ),
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
    List<Message> list = _messages;
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
        var data = Message.fromJson(json.decode(response.body)[JSON_DATA_KEY]);
        list.add(data);
        this.setState(() {
          _messages = list;
        });
      }
    } catch (error) {
      print('error $error');
    }

    this.setState(() {
      _isLoading = false;
    });
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
        var response = await Network().getWithAuth(
            "$MESSAGES_FROM_USER/${widget.user.id}?skip=${_messages.length}");

        if (response.statusCode == RESPONSE_SUCCESS) {
          List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];

          var messageToSend = {
            'senderId': user.id,
            'senderName': user.name,
            'senderPhotoUrl': user.avatarUrl,
            'receiverId': this.widget.user.id,
            'receiverName': this.widget.user.name,
            'receiverPhotoUrl': this.widget.user.avatarUrl,
            'message': _response,
            'read': false,
            'refMessageId': '',
            'fromModal': false,
          };

          this
              .channel
              .sink
              .add("\"{type:\'all_read\',message:$messageToSend}\"");

          data.forEach((element) {
            Message m = Message.fromJson(element);
            list.insert(0, m);
          });

          this.setState(() {
            _messages = list;
            authUser = user;
            hasMore = data.length > 0;
          });
        } else {}
      } catch (error) {
        print('error $error');
      }

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
        color: Color(0xFFF4FFFD),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        shadowColor: Color(0xFFA0DDFF),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  message.read == 0 || message.read == false
                      ? Badge(
                          badgeColor: Colors.redAccent,
                          badgeContent: Text(""),
                        )
                      : SizedBox(),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Eu, ${_getStringTime(DateTime.parse(message.created_at))}",
                    style: TextStyle(
                        fontFamily: 'Neucha',
                        fontSize: 12,
                        color: Color(0xFF6890A7)),
                  ),
                ],
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

  _getStringTime(DateTime d) {
    return "${_parseTwoDigits(d.day)}/${_parseTwoDigits(d.month)}/${d.year} ${_parseTwoDigits(d.hour)}:${_parseTwoDigits(d.minute)}";
  }

  _parseTwoDigits(int value) {
    return value > 9 ? "$value" : "0$value";
  }

  _renderUserMessage(Message message) {
    return Padding(
      padding: EdgeInsets.only(left: 50),
      child: Card(
        color: Color(0xFFFFF6F6),
        shadowColor: Color(0xFFFFBCBC),
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
                  message.read == 0 || message.read == false
                      ? Badge(
                          badgeColor: Colors.redAccent,
                          badgeContent: Text(""),
                        )
                      : SizedBox(),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "${message.senderName}, ${_getStringTime(DateTime.parse(message.created_at))}",
                    style: TextStyle(
                        fontFamily: 'PatrickHand',
                        fontSize: 12,
                        color: Color(0xFFC18C8C)),
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
