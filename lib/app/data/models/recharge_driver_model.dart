class RechargeDriver {
  String? redirectUrl;
  String? orderId;

  RechargeDriver({this.redirectUrl, this.orderId});

  RechargeDriver.fromJson(Map<String, dynamic> json) {
    redirectUrl = json['redirect_url'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['redirect_url'] = this.redirectUrl;
    data['order_id'] = this.orderId;
    return data;
  }
}
