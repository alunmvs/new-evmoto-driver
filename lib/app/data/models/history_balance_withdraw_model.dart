class HistoryBalanceWithdraw {
  String? createTime;
  double? money;
  int? state;

  HistoryBalanceWithdraw({this.createTime, this.money, this.state});

  HistoryBalanceWithdraw.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    money = json['money'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['money'] = this.money;
    data['state'] = this.state;
    return data;
  }
}
