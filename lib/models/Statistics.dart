import 'package:nutriclock_app/models/MealPlanType.dart';

class Statistics {
  int daysFromInitialDate;
  int totalDaysRegistered;
  int meals;
  int totalSleepDays;
  String averageSleepHours;
  int totalDuration;
  int totalBurnedCals;
  String averageDuration;
  int averageBurnedCals;
  int totalSportDays;
  dynamic mealPlanType;

  Statistics();

  Map<String, dynamic> toJson() => {
        'daysFromInitialDate': daysFromInitialDate,
        'totalDaysRegistered': totalDaysRegistered,
        'meals': meals,
        'totalSleepDays': totalSleepDays,
        'averageSleepHours': averageSleepHours,
        'totalDuration': totalDuration,
        'totalBurnedCals': totalBurnedCals,
        'averageDuration': averageDuration,
        'averageBurnedCals': averageBurnedCals,
        'totalSportDays': totalSportDays,
        'mealPlanType': mealPlanType
      };

  Statistics.fromJson(Map<String, dynamic> json)
      : daysFromInitialDate = json['daysFromInitialDate'],
        totalDaysRegistered = json['totalDaysRegistered'],
        meals = json['meals'],
        totalSleepDays = json['totalSleepDays'],
        averageSleepHours = json['averageSleepHours'],
        totalDuration = json['totalDuration'],
        totalBurnedCals = json['totalBurnedCals'],
        averageDuration = json['averageDuration'],
        averageBurnedCals = json['averageBurnedCals'],
        mealPlanType = json['mealPlanType'],
        totalSportDays = json['totalSportDays'];
}
