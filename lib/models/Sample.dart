class Sample {
  int orderNumber;
  String name;
  String date;
  List<dynamic> intervals;

  Sample();

  Map<String, dynamic> toJson() => {
    'orderNumber': orderNumber,
    'name': name,
    'date': date,
    'intervals': intervals,
  };

  Sample.fromJson(Map<String, dynamic> json)
      : orderNumber = json['orderNumber'],
        name = json['name'],
        date = json['date'],
        intervals = json['intervals'];
}
