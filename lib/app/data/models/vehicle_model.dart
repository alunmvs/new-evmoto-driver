class Vehicle {
  String? car;

  Vehicle({this.car});

  Vehicle.fromJson(Map<String, dynamic> json) {
    car = json['car'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['car'] = this.car;
    return data;
  }
}
