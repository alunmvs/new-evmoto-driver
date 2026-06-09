class GuaranteeIncomeApproval {
  int? approvalStatus;
  String? guaranteedIncomeDate;
  List<Intervals>? intervals;
  double? orderIncome;
  double? totalGuaranteedIncome;
  int? approvedTime;
  String? ruleName;
  int? id;
  double? subsidyAmount;
  String? statusLabel;

  GuaranteeIncomeApproval({
    this.approvalStatus,
    this.guaranteedIncomeDate,
    this.intervals,
    this.orderIncome,
    this.totalGuaranteedIncome,
    this.approvedTime,
    this.ruleName,
    this.id,
    this.subsidyAmount,
    this.statusLabel,
  });

  GuaranteeIncomeApproval.fromJson(Map<String, dynamic> json) {
    approvalStatus = json['approvalStatus'];
    guaranteedIncomeDate = json['guaranteedIncomeDate'];
    if (json['intervals'] != null) {
      intervals = <Intervals>[];
      json['intervals'].forEach((v) {
        intervals!.add(new Intervals.fromJson(v));
      });
    }
    orderIncome = json['orderIncome'];
    totalGuaranteedIncome = json['totalGuaranteedIncome'];
    approvedTime = json['approvedTime'];
    ruleName = json['ruleName'];
    id = json['id'];
    subsidyAmount = json['subsidyAmount'];
    statusLabel = json['statusLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['approvalStatus'] = this.approvalStatus;
    data['guaranteedIncomeDate'] = this.guaranteedIncomeDate;
    if (this.intervals != null) {
      data['intervals'] = this.intervals!.map((v) => v.toJson()).toList();
    }
    data['orderIncome'] = this.orderIncome;
    data['totalGuaranteedIncome'] = this.totalGuaranteedIncome;
    data['approvedTime'] = this.approvedTime;
    data['ruleName'] = this.ruleName;
    data['id'] = this.id;
    data['subsidyAmount'] = this.subsidyAmount;
    data['statusLabel'] = this.statusLabel;
    return data;
  }
}

class Intervals {
  String? startTime;
  String? endTime;
  double? earnedMoney;
  double? amountPerHour;

  Intervals({
    this.startTime,
    this.endTime,
    this.earnedMoney,
    this.amountPerHour,
  });

  Intervals.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    earnedMoney = json['earnedMoney'];
    amountPerHour = json['amountPerHour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['earnedMoney'] = this.earnedMoney;
    data['amountPerHour'] = this.amountPerHour;
    return data;
  }
}
