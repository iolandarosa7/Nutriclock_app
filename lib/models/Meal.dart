class Meal {
  int id;
  String name;
  String quantity;
  String foodPhotoUrl;
  String nutritionalInfoPhotoUrl;
  String relativeUnit;
  String type;
  String date;
  String time;
  String userId;
  String numericUnit;
  String observations;

  Meal();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'quantity': quantity,
    'foodPhotoUrl': foodPhotoUrl,
    'nutritionalInfoPhotoUrl': nutritionalInfoPhotoUrl,
    'relativeUnit': relativeUnit,
    'type': type,
    'date': date,
    'time': time,
    'userId': userId,
    'numericUnit': numericUnit,
    'observations': observations
  };

  Meal.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        quantity = json['quantity'],
        id = json['id'],
        foodPhotoUrl = json['foodPhotoUrl'],
        nutritionalInfoPhotoUrl = json['nutritionalInfoPhotoUrl'],
        relativeUnit = json['relativeUnit'],
        type = json['type'],
        date = json['date'],
        time = json['time'],
        userId = json['userId'],
        numericUnit = json['numericUnit'],
        observations = json['observations'];
}