class HistoryBalanceRecharge {
  int? id;
  String? name;
  double? amount;
  String? paymentMethod;

  HistoryBalanceRecharge({this.id, this.name, this.amount});

  HistoryBalanceRecharge.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
    paymentMethod = json['paymentMethod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['amount'] = this.amount;
    return data;
  }
}
