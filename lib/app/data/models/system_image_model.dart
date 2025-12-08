class SystemImage {
  int? id;
  int? type;
  int? usePort;
  String? name;
  String? url;

  SystemImage({this.id, this.type, this.usePort, this.name, this.url});

  SystemImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    usePort = json['usePort'];
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['usePort'] = this.usePort;
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}
