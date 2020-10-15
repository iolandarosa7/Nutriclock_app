class Disease {
  String name;
  String type;
  int id;

  Disease();

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'id': id,
      };

  Disease.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        type = json['type'],
        id = json['id'];
}
