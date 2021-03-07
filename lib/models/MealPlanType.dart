import 'package:nutriclock_app/models/Ingredient.dart';

class MealPlanType {
  int id;
  String type;
  int planMealId;
  int portion;
  String hour;
  List<Ingredient> ingredients;
  bool opened;

  MealPlanType();

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'planMealId': planMealId,
        'portion': portion,
        'hour': hour,
        'ingredients': ingredients
      };

  MealPlanType.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        planMealId = json['planMealId'],
        portion = json['portion'],
        hour = json['hour'],
        ingredients = json['ingredient'],
        opened = false,
        id = json['id'];
}
