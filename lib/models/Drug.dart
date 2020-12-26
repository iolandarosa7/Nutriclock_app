class Drug {
  int userId;
  String name;
  String timesAWeek;
  String timesADay;
  int id;
  String posology;
  String type;

  Drug(String name, String posology, String timesADay, String timesAWeek, String type) {
    this.name = name;
    this.timesADay = timesADay;
    this.timesAWeek = timesAWeek;
    this.posology = posology;
    this.type = type;
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'timesAWeek': timesAWeek,
        'timesADay': timesADay,
        'id': id,
        'posology': posology,
        'type': type,
      };

  Drug.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        userId = json['userId'],
        timesAWeek = json['timesAWeek'],
        timesADay = json['timesADay'],
        posology = json['posology'],
        type = json['type'],
        id = json['id'];
}
