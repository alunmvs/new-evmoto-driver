class Vehicle {
  String? car;
  List<AvailableVehicleList>? availableVehicleList;

  Vehicle({this.car, this.availableVehicleList});

  Vehicle.fromJson(Map<String, dynamic> json) {
    car = json['car'];
    if (json['list'] != null) {
      availableVehicleList = <AvailableVehicleList>[];
      json['list'].forEach((v) {
        availableVehicleList!.add(new AvailableVehicleList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['car'] = this.car;
    if (this.availableVehicleList != null) {
      data['list'] = this.availableVehicleList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AvailableVehicleList {
  int? id;
  String? name;

  AvailableVehicleList({this.id, this.name});

  AvailableVehicleList.fromJson(Map<String, dynamic> json) {
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
