class Ingredient {
  int id;
  String code;
  String name;
  int quantity;
  String unit;
  String description;

  Ingredient();

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'quantity': quantity,
    'name': name,
    'unit': unit,
    'description': description,
  };

  Ingredient.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        quantity = json['quantity'],
        name = json['name'],
        unit = json['unit'],
        description = json['description'],
        id = json['id'];
}
