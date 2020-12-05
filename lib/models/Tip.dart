class Tip {
  int id;
  String description;

  Tip();

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
  };

  Tip.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        id = json['id'];
}