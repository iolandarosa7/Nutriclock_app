class AcceptanceTerms {
  String title;
  String description;
  int version;
  int id;

  AcceptanceTerms();

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'version': version,
        'id': id,
      };

  AcceptanceTerms.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        version = json['version'],
        id = json['id'];
}
