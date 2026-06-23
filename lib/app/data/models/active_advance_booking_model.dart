class ActiveAdvanceBooking {
  int? id;
  int? userId;
  String? startAddress;
  String? startAddressName;
  double? startLon;
  double? startLat;
  String? endAddress;
  String? endAddressName;
  double? endLon;
  double? endLat;
  String? travelTime;
  double? orderMoney;
  int? payType;
  int? payManner;
  int? substitute;
  String? passengers;
  String? passengersPhone;
  String? remark;
  int? state;
  int? orderId;
  int? spawnedOrderState;
  int? driverId;
  String? insertTime;
  int? actorType;
  double? startMoney;
  double? mileageMoney;
  double? durationMoney;
  double? waitMoney;
  double? longDistanceMoney;
  double? nightMoney;
  double? fastigiumMoney;
  double? additionalCharge;
  double? couponMoney;
  double? discountMoney;

  ActiveAdvanceBooking({
    this.id,
    this.userId,
    this.startAddress,
    this.startAddressName,
    this.startLon,
    this.startLat,
    this.endAddress,
    this.endAddressName,
    this.endLon,
    this.endLat,
    this.travelTime,
    this.orderMoney,
    this.payType,
    this.payManner,
    this.substitute,
    this.passengers,
    this.passengersPhone,
    this.remark,
    this.state,
    this.orderId,
    this.spawnedOrderState,
    this.driverId,
    this.insertTime,
    this.actorType,
    this.startMoney,
    this.mileageMoney,
    this.durationMoney,
    this.waitMoney,
    this.longDistanceMoney,
    this.nightMoney,
    this.fastigiumMoney,
    this.additionalCharge,
    this.couponMoney,
    this.discountMoney,
  });

  ActiveAdvanceBooking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    startAddress = json['startAddress'];
    startAddressName = json['startAddressName'];
    startLon = json['startLon'];
    startLat = json['startLat'];
    endAddress = json['endAddress'];
    endAddressName = json['endAddressName'];
    endLon = json['endLon'];
    endLat = json['endLat'];
    travelTime = json['travelTime'];
    orderMoney = json['orderMoney'];
    payType = json['payType'];
    payManner = json['payManner'];
    substitute = json['substitute'];
    passengers = json['passengers'];
    passengersPhone = json['passengersPhone'];
    remark = json['remark'];
    state = json['state'];
    orderId = json['orderId'];
    spawnedOrderState = json['spawnedOrderState'];
    driverId = json['driverId'];
    insertTime = json['insertTime'];
    actorType = json['actorType'];
    startMoney = json['startMoney'];
    mileageMoney = json['mileageMoney'];
    durationMoney = json['durationMoney'];
    waitMoney = json['waitMoney'];
    longDistanceMoney = json['longDistanceMoney'];
    nightMoney = json['nightMoney'];
    fastigiumMoney = json['fastigiumMoney'];
    additionalCharge = json['additionalCharge'];
    couponMoney = json['couponMoney'];
    discountMoney = json['discountMoney'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['startAddress'] = startAddress;
    data['startAddressName'] = startAddressName;
    data['startLon'] = startLon;
    data['startLat'] = startLat;
    data['endAddress'] = endAddress;
    data['endAddressName'] = endAddressName;
    data['endLon'] = endLon;
    data['endLat'] = endLat;
    data['travelTime'] = travelTime;
    data['orderMoney'] = orderMoney;
    data['payType'] = payType;
    data['payManner'] = payManner;
    data['substitute'] = substitute;
    data['passengers'] = passengers;
    data['passengersPhone'] = passengersPhone;
    data['remark'] = remark;
    data['state'] = state;
    data['orderId'] = orderId;
    data['spawnedOrderState'] = spawnedOrderState;
    data['driverId'] = driverId;
    data['insertTime'] = insertTime;
    data['actorType'] = actorType;
    data['startMoney'] = startMoney;
    data['mileageMoney'] = mileageMoney;
    data['durationMoney'] = durationMoney;
    data['waitMoney'] = waitMoney;
    data['longDistanceMoney'] = longDistanceMoney;
    data['nightMoney'] = nightMoney;
    data['fastigiumMoney'] = fastigiumMoney;
    data['additionalCharge'] = additionalCharge;
    data['couponMoney'] = couponMoney;
    data['discountMoney'] = discountMoney;
    return data;
  }
}
