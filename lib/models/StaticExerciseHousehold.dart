import 'dart:ffi';

class StaticExerciseHousehold {
  String name;
  int id;
  String met;

  StaticExerciseHousehold();

  Map<String, dynamic> toJson() => {
    'name': name,
    'met': met,
    'id': id,
  };

  StaticExerciseHousehold.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        met = json['met'];
}