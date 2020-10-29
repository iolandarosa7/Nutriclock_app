class Statistics {
  int daysFromInitialDate;
  int totalDaysRegistered;
  int meals;

  Statistics();

  Map<String, dynamic> toJson() => {
    'daysFromInitialDate': daysFromInitialDate,
    'totalDaysRegistered': totalDaysRegistered,
    'meals': meals,
  };

  Statistics.fromJson(Map<String, dynamic> json)
      : daysFromInitialDate = json['daysFromInitialDate'],
        totalDaysRegistered = json['totalDaysRegistered'],
        meals = json['meals'];
}