class OpenCity {
  int? id;
  String? name;
  double? lon;
  double? lat;

  OpenCity({this.id, this.name, this.lon, this.lat});

  OpenCity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lon = json['lon'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    return data;
  }
}
