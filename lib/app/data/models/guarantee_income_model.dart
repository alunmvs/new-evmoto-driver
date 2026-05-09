class GuaranteeIncome {
  int? driverId;
  String? startDate;
  String? endDate;
  List<Daily>? daily;

  GuaranteeIncome({this.driverId, this.startDate, this.endDate, this.daily});

  GuaranteeIncome.fromJson(Map<String, dynamic> json) {
    driverId = json['driverId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    if (json['daily'] != null) {
      daily = <Daily>[];
      json['daily'].forEach((v) {
        daily!.add(new Daily.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driverId'] = this.driverId;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    if (this.daily != null) {
      data['daily'] = this.daily!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Daily {
  String? date;
  List<Periods>? periods;
  List<String?>? logOnlineOffline;
  double? totalDayOrderIncome;
  double? totalDayGuaranteedAmount;
  double? dailyNetGuaranteedIncome;

  Daily({
    this.date,
    this.periods,
    this.logOnlineOffline,
    this.totalDayOrderIncome,
    this.totalDayGuaranteedAmount,
    this.dailyNetGuaranteedIncome,
  });

  Daily.fromJson(Map<String, dynamic> json) {
    totalDayOrderIncome = json['totalDayOrderIncome'];
    totalDayGuaranteedAmount = json['totalDayGuaranteedAmount'];
    dailyNetGuaranteedIncome = json['dailyNetGuaranteedIncome'];
    if (json['logOnlineOffline'] != null) {
      logOnlineOffline = json['logOnlineOffline'];
    }
    if (json['periods'] != null) {
      periods = <Periods>[];
      json['periods'].forEach((v) {
        periods!.add(new Periods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.periods != null) {
      data['periods'] = this.periods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Periods {
  int? foundationId;
  String? startTime;
  String? endTime;
  int? hourType;
  int? onlineDurationMinutes;
  int? requiredOnlineMinutes;
  double? guaranteedAmount;
  double? orderIncome;
  double? netGuaranteedIncome;
  double? amount;
  double? guaranteedAmountPerHour;

  Periods({
    this.foundationId,
    this.startTime,
    this.endTime,
    this.hourType,
    this.onlineDurationMinutes,
    this.requiredOnlineMinutes,
    this.guaranteedAmount,
    this.orderIncome,
    this.netGuaranteedIncome,
    this.amount,
    this.guaranteedAmountPerHour,
  });

  Periods.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    guaranteedAmountPerHour = double.tryParse(
      json['guaranteedAmountPerHour'].toString(),
    );
    foundationId = json['foundationId'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    hourType = json['hourType'];
    onlineDurationMinutes = json['onlineDurationMinutes'];
    requiredOnlineMinutes = json['requiredOnlineMinutes'];
    guaranteedAmount = double.tryParse(json['guaranteedAmount'].toString());
    orderIncome = double.tryParse(json['orderIncome'].toString());
    netGuaranteedIncome = double.tryParse(
      json['netGuaranteedIncome'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['foundationId'] = this.foundationId;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['hourType'] = this.hourType;
    data['onlineDurationMinutes'] = this.onlineDurationMinutes;
    data['requiredOnlineMinutes'] = this.requiredOnlineMinutes;
    data['guaranteedAmount'] = this.guaranteedAmount;
    data['orderIncome'] = this.orderIncome;
    data['netGuaranteedIncome'] = this.netGuaranteedIncome;
    return data;
  }
}
