class WorkingArea {
  int? id;
  String? type;
  List<String>? center;

  WorkingArea({this.id, this.type, this.center});

  WorkingArea.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    center = json['center'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['center'] = this.center;
    return data;
  }
}
