class GuaranteeIncomeProgressBar {
  int? id;
  int? ensureIncomeId;
  String? startTime;
  String? endTime;
  int? onLineTime;
  double? amount;
  String? createTime;
  int? hourType;
  int? onlineDurationMinutes;

  GuaranteeIncomeProgressBar({
    this.id,
    this.ensureIncomeId,
    this.startTime,
    this.endTime,
    this.onLineTime,
    this.amount,
    this.createTime,
    this.hourType,
    this.onlineDurationMinutes,
  });

  GuaranteeIncomeProgressBar.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ensureIncomeId = json['ensureIncomeId'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    onLineTime = json['onLineTime'];
    amount = json['amount'];
    createTime = json['createTime'];
    hourType = json['hourType'];
    onlineDurationMinutes = json['onlineDurationMinutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['onlineDurationMinutes'] = this.onlineDurationMinutes;
    data['id'] = this.id;
    data['ensureIncomeId'] = this.ensureIncomeId;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['onLineTime'] = this.onLineTime;
    data['amount'] = this.amount;
    data['createTime'] = this.createTime;
    data['hourType'] = this.hourType;
    return data;
  }
}
