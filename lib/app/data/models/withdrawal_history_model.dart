class WithdrawalHistory {
  String? createTime;
  double? money;
  String? remark;
  int? state;

  WithdrawalHistory({this.createTime, this.money, this.remark, this.state});

  WithdrawalHistory.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    money = json['money'];
    remark = json['remark'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['money'] = this.money;
    data['remark'] = this.remark;
    data['state'] = this.state;
    return data;
  }
}
