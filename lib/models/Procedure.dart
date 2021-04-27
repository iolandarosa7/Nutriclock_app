class Procedure {
  int orderNumber;
  String value;

  Procedure();

  Map<String, dynamic> toJson() => {
    'orderNumber': orderNumber,
    'value': value,
  };

  Procedure.fromJson(Map<String, dynamic> json)
      : orderNumber = json['orderNumber'],
        value = json['value'];
}
