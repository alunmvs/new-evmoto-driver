class CouponIncome {
  int? driverId;
  String? startDate;
  String? endDate;
  List<Daily>? daily;

  CouponIncome({this.driverId, this.startDate, this.endDate, this.daily});

  CouponIncome.fromJson(Map<String, dynamic> json) {
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
  List<Orders>? orders;
  double? totalOrderIncome;
  double? totalCouponIncome;
  double? totalCashIncome;
  String? orderTime;
  String? startAddressName;
  String? endAddressName;

  Daily({
    this.date,
    this.orders,
    this.totalOrderIncome,
    this.totalCouponIncome,
    this.totalCashIncome,
    this.startAddressName,
    this.endAddressName,
  });

  Daily.fromJson(Map<String, dynamic> json) {
    orderTime = json['order_time'];
    startAddressName = json['start_address_name'];
    endAddressName = json['end_address_name'];
    date = json['date'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
    totalOrderIncome = double.tryParse(json['totalOrderIncome'].toString());
    totalCouponIncome = double.tryParse(json['totalCouponIncome'].toString());
    totalCashIncome = double.tryParse(json['totalCashIncome'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    data['totalOrderIncome'] = this.totalOrderIncome;
    data['totalCouponIncome'] = this.totalCouponIncome;
    data['totalCashIncome'] = this.totalCashIncome;
    return data;
  }
}

class Orders {
  int? orderId;
  double? orderIncome;
  double? couponIncome;
  double? cashIncome;

  Orders({this.orderId, this.orderIncome, this.couponIncome, this.cashIncome});

  Orders.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderIncome = json['orderIncome'];
    couponIncome = json['couponIncome'];
    cashIncome = json['cashIncome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderIncome'] = this.orderIncome;
    data['couponIncome'] = this.couponIncome;
    data['cashIncome'] = this.cashIncome;
    return data;
  }
}
