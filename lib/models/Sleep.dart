class Sleep {
  int id;
  String date;
  String userId;
  String wakeUpTime;
  String sleepTime;
  bool hasWakeUp;
  List<String> activities;
  List<String> motives;
  Sleep();

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'userId': userId,
    'wakeUpTime': wakeUpTime,
    'sleepTime': sleepTime,
    'hasWakeUp': hasWakeUp,
    'activities': activities,
    'motives': motives
  };

  Sleep.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        userId = json['userId'],
        id = json['id'],
        wakeUpTime = json['wakeUpTime'],
        sleepTime = json['sleepTime'],
        hasWakeUp = json['hasWakeUp'],
        activities = json['activities'],
        motives = json['motives'];
}
