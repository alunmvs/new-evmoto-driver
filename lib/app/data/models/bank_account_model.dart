class BankAccount {
  int? id;
  String? bank;
  String? bankCode;
  String? name;
  String? code;
  int? driverId;
  int? insertTime;

  BankAccount({
    this.id,
    this.bank,
    this.bankCode,
    this.name,
    this.code,
    this.driverId,
    this.insertTime,
  });

  BankAccount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bank = json['bank'];
    bankCode = json['bankCode'];
    name = json['name'];
    code = json['code'];
    driverId = json['driverId'];
    insertTime = json['insertTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bank'] = this.bank;
    data['bankCode'] = this.bankCode;
    data['name'] = this.name;
    data['code'] = this.code;
    data['driverId'] = this.driverId;
    data['insertTime'] = this.insertTime;
    return data;
  }
}
