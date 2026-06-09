class Notification {
  int? id;
  int? type;
  String? title;
  String? content;
  String? img;
  String? time;
  int? read;
  int? noticeType;

  Notification({
    this.id,
    this.type,
    this.title,
    this.content,
    this.img,
    this.time,
    this.read,
    this.noticeType,
  });

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    content = json['content'];
    img = json['img'];
    time = json['time'];
    read = json['read'];
    noticeType = json['noticeType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['title'] = this.title;
    data['content'] = this.content;
    data['img'] = this.img;
    data['time'] = this.time;
    data['read'] = this.read;
    data['noticeType'] = this.noticeType;
    return data;
  }
}
