class StaticMealNameResponse {
  String name;

  StaticMealNameResponse();

  Map<String, dynamic> toJson() => {
    'name': name,
  };

  StaticMealNameResponse.fromJson(Map<String, dynamic> json)
      : name = json['name'];
}