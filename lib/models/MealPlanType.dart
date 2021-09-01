class MealPlanType {
  int id;
  String type;
  int planMealId;
  int portion;
  String hour;
  List<dynamic> ingredients;
  bool opened;
  bool confirmed;
  String confirmedHours;
  String photoUrl;

  MealPlanType();

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'planMealId': planMealId,
        'portion': portion,
        'hour': hour,
        'ingredients': ingredients,
        'confirmed': confirmed,
        'confirmedHours': confirmedHours,
        'photoUrl': photoUrl,
      };

  MealPlanType.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        planMealId = json['planMealId'],
        portion = json['portion'],
        hour = json['hour'],
        ingredients = json['ingredients'],
        opened = false,
        confirmed = json['confirmed'],
        confirmedHours = json['confirmedHours'],
        photoUrl = json['photoUrl'],
        id = json['id'];
}
