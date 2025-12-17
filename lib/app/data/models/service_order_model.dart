class ServiceOrder {
  int? type;
  String? name;
  int? state;
  int? updatedState;

  ServiceOrder({this.type, this.name, this.state, this.updatedState});

  ServiceOrder.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    state = json['state'];
    updatedState = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['name'] = this.name;
    data['state'] = this.state;
    return data;
  }
}
