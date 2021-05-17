class Report {
  String totalSleeps;
  String averageSleepTime;
  String maximumSleepHour;
  String maximumSleepDate;
  String minimumSleepHour;
  String minimumSleepDate;
  List<dynamic> averageSleepArray;
  List<dynamic> percentageSleepArray;
  String totalExercises;
  String averageExerciseTime;
  String averageExerciseCalories;
  String maximumExercise;
  String minimumExercise;
  String maximumCalories;
  String minimumCalories;
  List<dynamic> averageExerciseArray;
  List<dynamic> percentageExerciseArray;
  List<dynamic> averageCaloriesArray;
  List<dynamic> percentageCaloriesArray;

  Report();

  Map<String, dynamic> toJson() => {
    'totalSleeps': totalSleeps,
    'averageSleepTime': averageSleepTime,
    'maximumSleepHour': maximumSleepHour,
    'maximumSleepDate': maximumSleepDate,
    'minimumSleepHour': minimumSleepHour,
    'minimumSleepDate': minimumSleepDate,
    'averageSleepArray': averageSleepArray,
    'percentageSleepArray': percentageSleepArray,
    'totalExercises': totalExercises,
    'averageExerciseTime': averageExerciseTime,
    'averageExerciseCalories': averageExerciseCalories,
    'maximumExercise': maximumExercise,
    'minimumExercise': minimumExercise,
    'maximumCalories': maximumCalories,
    'minimumCalories': minimumCalories,
    'averageExerciseArray': averageExerciseArray,
    'percentageExerciseArray': percentageExerciseArray,
    'averageCaloriesArray': averageCaloriesArray,
    'percentageCaloriesArray': percentageCaloriesArray,
  };

  Report.fromJson(Map<String, dynamic> json)
      : totalSleeps = json['totalSleeps'],
        averageSleepTime = json['averageSleepTime'],
        maximumSleepHour = json['maximumSleepHour'],
        maximumSleepDate = json['maximumSleepDate'],
        minimumSleepHour = json['minimumSleepHour'],
        minimumSleepDate = json['minimumSleepDate'],
        averageSleepArray = json['averageSleepArray'],
        percentageSleepArray = json['percentageSleepArray'],
        totalExercises = json['totalExercises'],
        averageExerciseTime = json['averageExerciseTime'],
        averageExerciseCalories = json['averageExerciseCalories'],
        maximumExercise = json['maximumExercise'],
        minimumExercise = json['minimumExercise'],
        maximumCalories = json['maximumCalories'],
        minimumCalories = json['minimumCalories'],
        averageExerciseArray = json['averageExerciseArray'],
        percentageExerciseArray = json['percentageExerciseArray'],
        averageCaloriesArray = json['averageCaloriesArray'],
        percentageCaloriesArray = json['percentageCaloriesArray'];
}