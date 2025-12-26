class OrderPayment {
  double? orderMoney;
  double? startMileage;
  double? startMoney;
  double? mileageMoney;
  double? mileage;
  double? durationMoney;
  double? duration;
  double? waitMoney;
  double? wait;
  double? longDistanceMoney;
  double? longDistance;
  double? fastigiumMoney;
  double? nightMoney;
  double? additionalCharge;
  double? redPacketMoney;
  double? couponMoney;
  double? discountMoney;
  double? discount;
  double? collectionFees;

  OrderPayment({
    this.orderMoney,
    this.startMileage,
    this.startMoney,
    this.mileageMoney,
    this.mileage,
    this.durationMoney,
    this.duration,
    this.waitMoney,
    this.wait,
    this.longDistanceMoney,
    this.longDistance,
    this.fastigiumMoney,
    this.nightMoney,
    this.additionalCharge,
    this.redPacketMoney,
    this.couponMoney,
    this.discountMoney,
    this.discount,
    this.collectionFees,
  });

  OrderPayment.fromJson(Map<String, dynamic> json) {
    orderMoney = json['orderMoney'];
    startMileage = json['startMileage'];
    startMoney = json['startMoney'];
    mileageMoney = json['mileageMoney'];
    mileage = json['mileage'];
    durationMoney = json['durationMoney'];
    duration = json['duration'];
    waitMoney = json['waitMoney'];
    wait = json['wait'];
    longDistanceMoney = json['longDistanceMoney'];
    longDistance = json['longDistance'];
    fastigiumMoney = json['fastigiumMoney'];
    nightMoney = json['nightMoney'];
    additionalCharge = json['additionalCharge'];
    redPacketMoney = json['redPacketMoney'];
    couponMoney = json['couponMoney'];
    discountMoney = json['discountMoney'];
    discount = json['discount'];
    collectionFees = json['collectionFees'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderMoney'] = this.orderMoney;
    data['startMileage'] = this.startMileage;
    data['startMoney'] = this.startMoney;
    data['mileageMoney'] = this.mileageMoney;
    data['mileage'] = this.mileage;
    data['durationMoney'] = this.durationMoney;
    data['duration'] = this.duration;
    data['waitMoney'] = this.waitMoney;
    data['wait'] = this.wait;
    data['longDistanceMoney'] = this.longDistanceMoney;
    data['longDistance'] = this.longDistance;
    data['fastigiumMoney'] = this.fastigiumMoney;
    data['nightMoney'] = this.nightMoney;
    data['additionalCharge'] = this.additionalCharge;
    data['redPacketMoney'] = this.redPacketMoney;
    data['couponMoney'] = this.couponMoney;
    data['discountMoney'] = this.discountMoney;
    data['discount'] = this.discount;
    data['collectionFees'] = this.collectionFees;
    return data;
  }
}
