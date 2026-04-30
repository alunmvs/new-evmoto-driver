class Working {
  int? id;
  int? type;
  String? time;
  String? placementLon;
  String? placementLat;
  String? startAddress;
  String? startLon;
  String? startLat;
  String? endAddress;
  String? endLon;
  String? endLat;
  double? orderMoney;
  int? state;
  String? name;

  Working({
    this.id,
    this.type,
    this.time,
    this.placementLon,
    this.placementLat,
    this.startAddress,
    this.startLon,
    this.startLat,
    this.endAddress,
    this.endLon,
    this.endLat,
    this.orderMoney,
    this.state,
    this.name,
  });

  Working.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    time = json['time'];
    placementLon = json['placementLon'];
    placementLat = json['placementLat'];
    startAddress = json['startAddress'];
    startLon = json['startLon'];
    startLat = json['startLat'];
    endAddress = json['endAddress'];
    endLon = json['endLon'];
    endLat = json['endLat'];
    orderMoney = json['orderMoney'];
    state = json['state'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['time'] = this.time;
    data['placementLon'] = this.placementLon;
    data['placementLat'] = this.placementLat;
    data['startAddress'] = this.startAddress;
    data['startLon'] = this.startLon;
    data['startLat'] = this.startLat;
    data['endAddress'] = this.endAddress;
    data['endLon'] = this.endLon;
    data['endLat'] = this.endLat;
    data['orderMoney'] = this.orderMoney;
    data['state'] = this.state;
    data['name'] = this.name;
    return data;
  }
}
