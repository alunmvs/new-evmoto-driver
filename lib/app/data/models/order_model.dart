import 'package:new_evmoto_driver/app/data/models/order_user_model.dart';

class Order {
  int? id;
  int? type;
  String? name;
  String? time;
  String? placementLon;
  String? placementLat;
  String? startAddress;
  String? startLon;
  String? startLat;
  String? endAddress;
  String? endLon;
  String? endLat;
  int? state;
  String? user;
  String? cargoNumber;
  String? cargoName;
  double? ordersMileage;
  double? passengersFrom;
  double? orderMoney;
  double? totalOrderCost;
  OrderUser? orderUser;
  int? historyNum;

  Order({
    this.id,
    this.type,
    this.name,
    this.time,
    this.placementLon,
    this.placementLat,
    this.startAddress,
    this.startLon,
    this.startLat,
    this.endAddress,
    this.endLon,
    this.endLat,
    this.state,
    this.user,
    this.cargoNumber,
    this.cargoName,
    this.ordersMileage,
    this.passengersFrom,
    this.orderMoney,
    this.totalOrderCost,
    this.orderUser,
    this.historyNum,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    time = json['time'];
    placementLon = json['placementLon'];
    placementLat = json['placementLat'];
    startAddress = json['startAddress'];
    startLon = json['startLon'];
    startLat = json['startLat'];
    endAddress = json['endAddress'];
    endLon = json['endLon'];
    endLat = json['endLat'];
    state = json['state'];
    user = json['user'];
    cargoNumber = json['cargoNumber'];
    cargoName = json['cargoName'];
    ordersMileage = json['ordersMileage'];
    passengersFrom = json['passengersFrom'];
    orderMoney = json['orderMoney'];
    totalOrderCost = json['totalOrderCost'];
    orderUser = json['orderUser'];
    historyNum = json['historyNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['time'] = this.time;
    data['placementLon'] = this.placementLon;
    data['placementLat'] = this.placementLat;
    data['startAddress'] = this.startAddress;
    data['startLon'] = this.startLon;
    data['startLat'] = this.startLat;
    data['endAddress'] = this.endAddress;
    data['endLon'] = this.endLon;
    data['endLat'] = this.endLat;
    data['state'] = this.state;
    data['user'] = this.user;
    data['cargoNumber'] = this.cargoNumber;
    data['cargoName'] = this.cargoName;
    data['ordersMileage'] = this.ordersMileage;
    data['passengersFrom'] = this.passengersFrom;
    data['orderMoney'] = this.orderMoney;
    data['totalOrderCost'] = this.totalOrderCost;
    data['orderUser'] = this.orderUser;
    data['historyNum'] = this.historyNum;
    return data;
  }
}
