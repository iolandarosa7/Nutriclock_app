class Statistics {
  int daysFromInitialDate;
  int totalDaysRegistered;
  int meals;
  int totalSleepDays;
  double averageSleepHours;

  Statistics();

  Map<String, dynamic> toJson() => {
        'daysFromInitialDate': daysFromInitialDate,
        'totalDaysRegistered': totalDaysRegistered,
        'meals': meals,
        'totalSleepDays': totalSleepDays,
        'averageSleepHours': averageSleepHours,
      };

  Statistics.fromJson(Map<String, dynamic> json)
      : daysFromInitialDate = json['daysFromInitialDate'],
        totalDaysRegistered = json['totalDaysRegistered'],
        meals = json['meals'],
        totalSleepDays = json['totalSleepDays'],
        averageSleepHours = json['averageSleepHours'];
}
