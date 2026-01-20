class HistoryBalanceWithdraw {
  String? createTime;
  double? money;
  double? adminFee;
  int? state;
  String? remark;
  String? accountHolderName;
  String? accountNumber;
  String? bankCode;

  HistoryBalanceWithdraw({
    this.createTime,
    this.money,
    this.state,
    this.adminFee,
    this.accountHolderName,
    this.accountNumber,
    this.bankCode,
  });

  HistoryBalanceWithdraw.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    money = json['money'];
    state = json['state'];
    adminFee = json['adminFee'];
    remark = json['remark'];
    accountHolderName = json['accountHolderName'];
    accountNumber = json['accountNumber'];
    bankCode = json['bankCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['money'] = this.money;
    data['state'] = this.state;
    data['adminFee'] = this.adminFee;
    data['remark'] = this.remark;
    data['accountHolderName'] = this.accountHolderName;
    data['accountNumber'] = this.accountNumber;
    data['bankCode'] = this.bankCode;
    return data;
  }
}
