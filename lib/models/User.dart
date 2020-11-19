class User {
  int id;
  String name;
  String gender;
  String weight;
  String height;
  String email;
  String role;
  bool active;
  // int active;
  String avatarUrl;
  String birthday;
  String diseases;
  int ufc_id;
  bool terms_accepted;
  // int terms_accepted;

  User();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'gender': gender,
        'weight': weight,
        'height': height,
        'email': email,
        'role': role,
        'active': active,
        'avatarUrl': avatarUrl,
        'birthday': birthday,
        'diseases': diseases,
        'ufc_id': ufc_id,
        'terms_accepted': terms_accepted,
      };

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        gender = json['gender'],
        id = json['id'],
        weight = json['weight'],
        height = json['height'],
        email = json['email'],
        role = json['role'],
        active = json['active'],
        avatarUrl = json['avatarUrl'],
        birthday = json['birthday'],
        diseases = json['diseases'],
        ufc_id = json['ufc_id'],
        terms_accepted = json['terms_accepted'];
}
