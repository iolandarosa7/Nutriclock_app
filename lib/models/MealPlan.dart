class MealPlan {
  int id;
  String dayOfWeek;
  String date;
  List<dynamic> mealTypes;
  int opened;

  MealPlan();

  Map<String, dynamic> toJson() => {
    'id': id,
    'dayOfWeek': dayOfWeek,
    'date': date,
    'mealTypes': mealTypes
  };

  MealPlan.fromJson(Map<String, dynamic> json)
      : dayOfWeek = json['dayOfWeek'],
        date = json['date'],
        mealTypes = json['mealTypes'],
        opened = 0,
        id = json['id'];
}
