class MyVehicle {
  String? car;
  List<AlternativeVehicle>? alternativeVehicle;

  MyVehicle({this.car, this.alternativeVehicle});

  MyVehicle.fromJson(Map<String, dynamic> json) {
    car = json['car'];
    if (json['list'] != null) {
      alternativeVehicle = <AlternativeVehicle>[];
      json['list'].forEach((v) {
        alternativeVehicle!.add(new AlternativeVehicle.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['car'] = this.car;
    if (this.alternativeVehicle != null) {
      data['list'] = this.alternativeVehicle!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AlternativeVehicle {
  int? id;
  String? name;

  AlternativeVehicle({this.id, this.name});

  AlternativeVehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
