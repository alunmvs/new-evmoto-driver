class SocketOrderStatusData {
  int? orderType;
  int? orderId;
  int? state;
  int? time;
  String? travelTime;

  SocketOrderStatusData({
    this.orderType,
    this.orderId,
    this.state,
    this.time,
    this.travelTime,
  });

  SocketOrderStatusData.fromJson(Map<String, dynamic> json) {
    orderType = json['orderType'];
    orderId = json['orderId'];
    state = json['state'];
    time = json['time'];
    travelTime = json['travelTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderType'] = this.orderType;
    data['orderId'] = this.orderId;
    data['state'] = this.state;
    data['time'] = this.time;
    data['travelTime'] = this.travelTime;
    return data;
  }
}
