class Message {
  int id;
  String created_at;
  int senderId;
  String senderName;
  String senderPhotoUrl;
  int receiverId;
  String receiverName;
  String receiverPhotoUrl;
  String message;
  dynamic refMessageId;
  int read;
  // bool read;

  Message();

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_at': created_at,
    'senderId': senderId,
    'senderName': senderName,
    'senderPhotoUrl': senderPhotoUrl,
    'receiverId': receiverId,
    'receiverName': receiverName,
    'receiverPhotoUrl': receiverPhotoUrl,
    'message': message,
    'refMessageId': refMessageId,
    'read': read,
  };

  Message.fromJson(Map<String, dynamic> json)
      : created_at = json['created_at'],
        senderId = json['senderId'],
        senderName = json['senderName'],
        senderPhotoUrl = json['senderPhotoUrl'],
        receiverId = json['receiverId'],
        receiverName = json['receiverName'],
        receiverPhotoUrl = json['receiverPhotoUrl'],
        message = json['message'],
        refMessageId = json['refMessageId'],
        read = json['read'],
        id = json['id'];
}