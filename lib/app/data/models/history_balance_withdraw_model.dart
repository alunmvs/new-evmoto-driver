class HistoryBalanceWithdraw {
  String? createTime;
  double? money;
  double? adminFee;
  int? state;
  String? remark;

  HistoryBalanceWithdraw({this.createTime, this.money, this.state});

  HistoryBalanceWithdraw.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    money = json['money'];
    state = json['state'];
    adminFee = json['adminFee'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['money'] = this.money;
    data['state'] = this.state;
    data['adminFee'] = this.adminFee;
    data['remark'] = this.remark;
    return data;
  }
}
