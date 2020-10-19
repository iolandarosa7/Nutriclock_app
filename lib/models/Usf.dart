class Usf {
  int id;
  String name;

  Usf();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  Usf.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'];
}
