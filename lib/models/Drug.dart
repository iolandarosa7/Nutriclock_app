class Drug {
  int userId;
  String name;
  String timesAWeek;
  String timesADay;
  int id;
  String posology;

  Drug(String name, String posology, String timesADay, String timesAWeek) {
    this.name = name;
    this.timesADay = timesADay;
    this.timesAWeek = timesAWeek;
    this.posology = posology;
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'timesAWeek': timesAWeek,
        'timesADay': timesADay,
        'id': id,
        'posology': posology,
      };

  Drug.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        userId = json['userId'],
        timesAWeek = json['timesAWeek'],
        timesADay = json['timesADay'],
        posology = json['posology'],
        id = json['id'];
}
