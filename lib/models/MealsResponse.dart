import 'package:nutriclock_app/models/Meal.dart';

class MealsResponse {
  List<MealTypeByDate> mealsTypeByDate;

  MealsResponse();
}

class MealTypeByDate {
  String date;
  List<Meal> breakfasts;
  List<Meal> midMorning;
  List<Meal> lunchs;
  List<Meal> dinners;
  List<Meal> snacks;
  List<Meal> brunchs;
  List<Meal> anothers;
}
