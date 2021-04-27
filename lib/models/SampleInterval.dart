class SampleInterval {
  int id;
  String hour;

  SampleInterval();

  Map<String, dynamic> toJson() => {
    'id': id,
    'hour': hour,
  };

  SampleInterval.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        hour = json['hour'];
}
