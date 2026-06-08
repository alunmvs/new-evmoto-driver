class OrderPendingDispatch {
  int? startTime;
  int? endTime;
  Order? order;

  OrderPendingDispatch({this.startTime, this.endTime, this.order});

  OrderPendingDispatch.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
}

class Order {
  int? orderId;
  int? orderType;
  int? type;
  int? state;
  int? reservation;
  String? insertTime;
  String? travelTime;
  String? travelTime1;
  String? lineShiftTime;
  String? arriveTime;
  double? startLon;
  double? startLat;
  String? startAddress;
  String? startAddressName;
  String? startCity;
  double? endLon;
  double? endLat;
  String? endAddress;
  String? endAddressName;
  String? endCity;
  int? driverId;
  String? driverAvatar;
  String? driverName;
  String? licensePlate;
  String? brand;
  String? vehicleType;
  String? carColor;
  double? score;
  String? orderNum;
  int? historyNum;
  String? driverPhone;
  double? cancelPayMoney;
  int? cancelId;
  double? orderMoney;
  double? startMileage;
  double? startMoney;
  double? mileage;
  double? mileageMoney;
  double? duration;
  double? durationMoney;
  double? wait;
  double? waitMoney;
  double? longDistance;
  double? longDistanceMoney;
  double? travelMoney;
  double? fastigiumMoney;
  double? nightMoney;
  double? additionalCharge;
  double? collectionFees;
  double? collectionFeesAll;
  double? redPacketMoney;
  double? couponMoney;
  double? discount;
  double? discountMoney;
  int? payManner;
  int? payType;
  double? payMoney;
  double? tipMoney;
  int? orderScore;
  String? evaluate;
  int? device;
  int? peopleNumber;
  String? seatNumber;
  int? cancelUserType;
  String? cancelUser;
  double? cancelMoney;
  String? cancelReason;
  String? cancelRemark;
  String? remark;
  String? cargoNumber;
  String? cargoName;
  String? user;
  String? nickName;
  String? phone;
  String? emergencyCall;
  int? driverConfirm;
  int? userId;
  String? userHeadImg;
  double? platformFee;

  Order({
    this.orderId,
    this.orderType,
    this.type,
    this.state,
    this.reservation,
    this.insertTime,
    this.travelTime,
    this.travelTime1,
    this.lineShiftTime,
    this.arriveTime,
    this.startLon,
    this.startLat,
    this.startAddress,
    this.startAddressName,
    this.startCity,
    this.endLon,
    this.endLat,
    this.endAddress,
    this.endAddressName,
    this.endCity,
    this.driverId,
    this.driverAvatar,
    this.driverName,
    this.licensePlate,
    this.brand,
    this.vehicleType,
    this.carColor,
    this.score,
    this.orderNum,
    this.historyNum,
    this.driverPhone,
    this.cancelPayMoney,
    this.cancelId,
    this.orderMoney,
    this.startMileage,
    this.startMoney,
    this.mileage,
    this.mileageMoney,
    this.duration,
    this.durationMoney,
    this.wait,
    this.waitMoney,
    this.longDistance,
    this.longDistanceMoney,
    this.travelMoney,
    this.fastigiumMoney,
    this.nightMoney,
    this.additionalCharge,
    this.collectionFees,
    this.collectionFeesAll,
    this.redPacketMoney,
    this.couponMoney,
    this.discount,
    this.discountMoney,
    this.payManner,
    this.payType,
    this.payMoney,
    this.tipMoney,
    this.orderScore,
    this.evaluate,
    this.device,
    this.peopleNumber,
    this.seatNumber,
    this.cancelUserType,
    this.cancelUser,
    this.cancelMoney,
    this.cancelReason,
    this.cancelRemark,
    this.remark,
    this.cargoNumber,
    this.cargoName,
    this.user,
    this.nickName,
    this.phone,
    this.emergencyCall,
    this.driverConfirm,
    this.userId,
    this.userHeadImg,
    this.platformFee,
  });

  Order.fromJson(Map<String, dynamic> json) {
    reservation = json['reservation'];
    orderId = json['orderId'];
    orderType = json['orderType'];
    type = json['type'];
    state = json['state'];
    insertTime = json['insertTime'];
    travelTime = json['travelTime'];
    travelTime1 = json['travelTime1'];
    lineShiftTime = json['lineShiftTime'];
    arriveTime = json['arriveTime'];
    startLon = json['startLon'];
    startLat = json['startLat'];
    startAddress = json['startAddress'];
    startAddressName = json['startAddressName'];
    startCity = json['startCity'];
    endLon = json['endLon'];
    endLat = json['endLat'];
    endAddress = json['endAddress'];
    endAddressName = json['endAddressName'];
    endCity = json['endCity'];
    driverId = json['driverId'];
    driverAvatar = json['driverAvatar'];
    driverName = json['driverName'];
    licensePlate = json['licensePlate'];
    brand = json['brand'];
    vehicleType = json['vehicleType'];
    carColor = json['carColor'];
    score = json['score'];
    orderNum = json['orderNum'];
    historyNum = json['historyNum'];
    driverPhone = json['driverPhone'];
    cancelPayMoney = json['cancelPayMoney'];
    cancelId = json['cancelId'];
    orderMoney = json['orderMoney'];
    startMileage = json['startMileage'];
    startMoney = json['startMoney'];
    mileage = json['mileage'];
    mileageMoney = json['mileageMoney'];
    duration = json['duration'];
    durationMoney = json['durationMoney'];
    wait = json['wait'];
    waitMoney = json['waitMoney'];
    longDistance = json['longDistance'];
    longDistanceMoney = json['longDistanceMoney'];
    travelMoney = json['travelMoney'];
    fastigiumMoney = json['fastigiumMoney'];
    nightMoney = json['nightMoney'];
    additionalCharge = json['additionalCharge'];
    collectionFees = json['collectionFees'];
    collectionFeesAll = json['collectionFeesAll'];
    redPacketMoney = json['redPacketMoney'];
    couponMoney = json['couponMoney'];
    discount = json['discount'];
    discountMoney = json['discountMoney'];
    payManner = json['payManner'];
    payType = json['payType'];
    payMoney = json['payMoney'];
    tipMoney = json['tipMoney'];
    orderScore = json['orderScore'];
    evaluate = json['evaluate'];
    device = json['device'];
    peopleNumber = json['peopleNumber'];
    seatNumber = json['seatNumber'];
    cancelUserType = json['cancelUserType'];
    cancelUser = json['cancelUser'];
    cancelMoney = json['cancelMoney'];
    cancelReason = json['cancelReason'];
    cancelRemark = json['cancelRemark'];
    remark = json['remark'];
    cargoNumber = json['cargoNumber'];
    cargoName = json['cargoName'];
    user = json['user'];
    nickName = json['nickName'];
    phone = json['phone'];
    emergencyCall = json['emergencyCall'];
    driverConfirm = json['driverConfirm'];
    userId = json['userId'];
    userHeadImg = json['userHeadImg'];
    platformFee = json['platformFee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderType'] = this.orderType;
    data['type'] = this.type;
    data['state'] = this.state;
    data['insertTime'] = this.insertTime;
    data['travelTime_'] = this.travelTime;
    data['travelTime'] = this.travelTime;
    data['travelTime1'] = this.travelTime1;
    data['lineShiftTime'] = this.lineShiftTime;
    data['arriveTime'] = this.arriveTime;
    data['startLon'] = this.startLon;
    data['startLat'] = this.startLat;
    data['startAddress'] = this.startAddress;
    data['startAddressName'] = this.startAddressName;
    data['startCity'] = this.startCity;
    data['endLon'] = this.endLon;
    data['endLat'] = this.endLat;
    data['endAddress'] = this.endAddress;
    data['endAddressName'] = this.endAddressName;
    data['endCity'] = this.endCity;
    data['driverId'] = this.driverId;
    data['driverAvatar'] = this.driverAvatar;
    data['driverName'] = this.driverName;
    data['licensePlate'] = this.licensePlate;
    data['brand'] = this.brand;
    data['vehicleType'] = this.vehicleType;
    data['carColor'] = this.carColor;
    data['score'] = this.score;
    data['orderNum'] = this.orderNum;
    data['historyNum'] = this.historyNum;
    data['driverPhone'] = this.driverPhone;
    data['cancelPayMoney'] = this.cancelPayMoney;
    data['cancelId'] = this.cancelId;
    data['orderMoney'] = this.orderMoney;
    data['startMileage'] = this.startMileage;
    data['startMoney'] = this.startMoney;
    data['mileage'] = this.mileage;
    data['mileageMoney'] = this.mileageMoney;
    data['duration'] = this.duration;
    data['durationMoney'] = this.durationMoney;
    data['wait'] = this.wait;
    data['waitMoney'] = this.waitMoney;
    data['longDistance'] = this.longDistance;
    data['longDistanceMoney'] = this.longDistanceMoney;
    data['travelMoney'] = this.travelMoney;
    data['fastigiumMoney'] = this.fastigiumMoney;
    data['nightMoney'] = this.nightMoney;
    data['additionalCharge'] = this.additionalCharge;
    data['collectionFees'] = this.collectionFees;
    data['collectionFeesAll'] = this.collectionFeesAll;
    data['redPacketMoney'] = this.redPacketMoney;
    data['couponMoney'] = this.couponMoney;
    data['discount'] = this.discount;
    data['discountMoney'] = this.discountMoney;
    data['payManner'] = this.payManner;
    data['payType'] = this.payType;
    data['payMoney'] = this.payMoney;
    data['tipMoney'] = this.tipMoney;
    data['orderScore'] = this.orderScore;
    data['evaluate'] = this.evaluate;
    data['device'] = this.device;
    data['peopleNumber'] = this.peopleNumber;
    data['seatNumber'] = this.seatNumber;
    data['cancelUserType'] = this.cancelUserType;
    data['cancelUser'] = this.cancelUser;
    data['cancelMoney'] = this.cancelMoney;
    data['cancelReason'] = this.cancelReason;
    data['cancelRemark'] = this.cancelRemark;
    data['remark'] = this.remark;
    data['cargoNumber'] = this.cargoNumber;
    data['cargoName'] = this.cargoName;
    data['user'] = this.user;
    data['nickName'] = this.nickName;
    data['phone'] = this.phone;
    data['emergencyCall'] = this.emergencyCall;
    data['driverConfirm'] = this.driverConfirm;
    data['userId'] = this.userId;
    data['userHeadImg'] = this.userHeadImg;
    data['platformFee'] = this.platformFee;
    return data;
  }
}
