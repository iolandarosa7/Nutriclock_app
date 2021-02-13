import 'dart:ffi';

class Exercise {
  String name;
  int id;
  String met;
  int startTime;
  int endTime;
  int duration;
  dynamic burnedCalories;
  String date;
  int userId;
  int exerciseId;
  String type;

  Exercise();

  Map<String, dynamic> toJson() => {
    'name': name,
    'met': met,
    'id': id,
    'startTime': startTime,
    'endTime': endTime,
    'duration': duration,
    'burnedCalories': burnedCalories,
    'date': date,
    'userId': userId,
    'exerciseId': exerciseId,
    'type': type
  };

  Exercise.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        met = json['met'],
        startTime = json['startTime'],
        endTime  = json['endTime'],
        duration = json['duration'],
        burnedCalories = json['burnedCalories'],
        date = json['date'],
        userId = json['userId'],
        exerciseId  = json['exerciseId'],
        type = json['type'];
}