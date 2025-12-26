class RegisteredDriver {
  int? id;
  int? status;
  int? isBind;

  RegisteredDriver({this.id, this.status, this.isBind});

  RegisteredDriver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    isBind = json['isBind'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['isBind'] = this.isBind;
    return data;
  }
}
