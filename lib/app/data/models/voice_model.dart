class Voice {
  int? id;
  int? voiceType;
  String? url;

  Voice({this.id, this.voiceType, this.url});

  Voice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    voiceType = json['voiceType'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['voiceType'] = this.voiceType;
    data['url'] = this.url;
    return data;
  }
}
