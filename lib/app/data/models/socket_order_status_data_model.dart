class SocketOrderStatusData {
  int? orderType;
  int? orderId;
  int? state;
  int? time;
  String? travelTime;
  int? payType;

  SocketOrderStatusData({
    this.orderType,
    this.orderId,
    this.state,
    this.time,
    this.travelTime,
    this.payType,
  });

  SocketOrderStatusData.fromJson(Map<String, dynamic> json) {
    orderType = int.tryParse(
      (json['orderType'] ?? json['order_type']).toString(),
    );
    orderId = int.tryParse((json['orderId'] ?? json['order_id']).toString());
    state = int.tryParse(json['state'].toString());
    time = int.tryParse(json['time'].toString());
    travelTime = json['travelTime'] ?? json['travel_time'];
    payType = int.tryParse(
      (json['payType'] ?? json['pay_type']).toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderType'] = this.orderType;
    data['orderId'] = this.orderId;
    data['state'] = this.state;
    data['time'] = this.time;
    data['travelTime'] = this.travelTime;
    data['payType'] = this.payType;
    return data;
  }
}
