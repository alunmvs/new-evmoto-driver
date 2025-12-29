class HistoryBalanceRevenue {
  List<Revenue>? revenue;
  double? income;
  double? flow;

  HistoryBalanceRevenue({this.revenue, this.income, this.flow});

  HistoryBalanceRevenue.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      revenue = <Revenue>[];
      json['list'].forEach((v) {
        revenue!.add(new Revenue.fromJson(v));
      });
    }
    income = json['income'];
    flow = json['flow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.revenue != null) {
      data['revenue'] = this.revenue!.map((v) => v.toJson()).toList();
    }
    data['income'] = this.income;
    data['flow'] = this.flow;
    return data;
  }
}

class Revenue {
  int? orderId;
  int? orderType;
  int? payManner;
  int? payType;
  String? payTime;
  double? payMoney;
  double? startMoney;
  double? startMileage;
  double? mileageMoney;
  double? mileageKilometers;
  double? durationMoney;
  double? duration;
  double? waitMoney;
  double? wait;
  double? fastigiumMoney;
  double? longDistanceMoney;
  double? longDistance;
  double? nightMoney;
  double? additionalCharge;
  double? collectionFees;
  Null? subsidy;

  Revenue({
    this.orderId,
    this.orderType,
    this.payManner,
    this.payType,
    this.payTime,
    this.payMoney,
    this.startMoney,
    this.startMileage,
    this.mileageMoney,
    this.mileageKilometers,
    this.durationMoney,
    this.duration,
    this.waitMoney,
    this.wait,
    this.fastigiumMoney,
    this.longDistanceMoney,
    this.longDistance,
    this.nightMoney,
    this.additionalCharge,
    this.collectionFees,
    this.subsidy,
  });

  Revenue.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderType = json['orderType'];
    payManner = json['payManner'];
    payType = json['payType'];
    payTime = json['payTime'];
    payMoney = json['payMoney'];
    startMoney = json['startMoney'];
    startMileage = json['startMileage'];
    mileageMoney = json['mileageMoney'];
    mileageKilometers = json['mileageKilometers'];
    durationMoney = json['durationMoney'];
    duration = json['duration'];
    waitMoney = json['waitMoney'];
    wait = json['wait'];
    fastigiumMoney = json['fastigiumMoney'];
    longDistanceMoney = json['longDistanceMoney'];
    longDistance = json['longDistance'];
    nightMoney = json['nightMoney'];
    additionalCharge = json['additionalCharge'];
    collectionFees = json['collectionFees'];
    subsidy = json['subsidy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderType'] = this.orderType;
    data['payManner'] = this.payManner;
    data['payType'] = this.payType;
    data['payTime'] = this.payTime;
    data['payMoney'] = this.payMoney;
    data['startMoney'] = this.startMoney;
    data['startMileage'] = this.startMileage;
    data['mileageMoney'] = this.mileageMoney;
    data['mileageKilometers'] = this.mileageKilometers;
    data['durationMoney'] = this.durationMoney;
    data['duration'] = this.duration;
    data['waitMoney'] = this.waitMoney;
    data['wait'] = this.wait;
    data['fastigiumMoney'] = this.fastigiumMoney;
    data['longDistanceMoney'] = this.longDistanceMoney;
    data['longDistance'] = this.longDistance;
    data['nightMoney'] = this.nightMoney;
    data['additionalCharge'] = this.additionalCharge;
    data['collectionFees'] = this.collectionFees;
    data['subsidy'] = this.subsidy;
    return data;
  }
}
