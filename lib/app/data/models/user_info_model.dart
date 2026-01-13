class UserInfo {
  int? id;
  String? avatar;
  String? name;
  String? phone;
  int? sex;
  String? licensePlate;
  String? brand;
  String? carColor;
  int? orderNum;
  double? score;
  double? balance;
  double? activityMoney;
  double? laveActivityMoney;
  double? businessMoney;
  double? laveBusinessMoney;
  String? taxiAptitudeCard;
  String? networkCarlssueDate;
  String? company;
  String? driverContactAddress;
  String? idCard;
  String? idCardImgUrl1;
  String? idCardImgUrl2;
  String? getDriverLicenseDate;
  String? type;
  String? placeOfPractice;
  String? placeOfEmployment;
  String? driveCardImgUrl;
  String? networkCarlssueImg;
  int? language;
  String? referralCode;

  UserInfo({
    this.id,
    this.avatar,
    this.name,
    this.phone,
    this.sex,
    this.licensePlate,
    this.brand,
    this.carColor,
    this.orderNum,
    this.score,
    this.balance,
    this.activityMoney,
    this.laveActivityMoney,
    this.businessMoney,
    this.laveBusinessMoney,
    this.taxiAptitudeCard,
    this.networkCarlssueDate,
    this.company,
    this.driverContactAddress,
    this.idCard,
    this.idCardImgUrl1,
    this.idCardImgUrl2,
    this.getDriverLicenseDate,
    this.type,
    this.placeOfPractice,
    this.placeOfEmployment,
    this.driveCardImgUrl,
    this.networkCarlssueImg,
    this.language,
    this.referralCode,
  });

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    name = json['name'];
    phone = json['phone'];
    sex = json['sex'];
    licensePlate = json['licensePlate'];
    brand = json['brand'];
    carColor = json['carColor'];
    orderNum = json['orderNum'];
    score = json['score'];
    balance = json['balance'];
    activityMoney = json['activityMoney'];
    laveActivityMoney = json['laveActivityMoney'];
    businessMoney = json['businessMoney'];
    laveBusinessMoney = json['laveBusinessMoney'];
    taxiAptitudeCard = json['taxiAptitudeCard'];
    networkCarlssueDate = json['networkCarlssueDate'];
    company = json['company'];
    driverContactAddress = json['driverContactAddress_'];
    idCard = json['idCard'];
    idCardImgUrl1 = json['idCardImgUrl1'];
    idCardImgUrl2 = json['idCardImgUrl2'];
    getDriverLicenseDate = json['getDriverLicenseDate'];
    type = json['type'];
    placeOfPractice = json['placeOfPractice'];
    placeOfEmployment = json['placeOfEmployment'];
    driveCardImgUrl = json['driveCardImgUrl'];
    networkCarlssueImg = json['networkCarlssueImg'];
    language = json['language'];
    referralCode = json['referralCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['sex'] = this.sex;
    data['licensePlate'] = this.licensePlate;
    data['brand'] = this.brand;
    data['carColor'] = this.carColor;
    data['orderNum'] = this.orderNum;
    data['score'] = this.score;
    data['balance'] = this.balance;
    data['activityMoney'] = this.activityMoney;
    data['laveActivityMoney'] = this.laveActivityMoney;
    data['businessMoney'] = this.businessMoney;
    data['laveBusinessMoney'] = this.laveBusinessMoney;
    data['taxiAptitudeCard'] = this.taxiAptitudeCard;
    data['networkCarlssueDate'] = this.networkCarlssueDate;
    data['company'] = this.company;
    data['driverContactAddress_'] = this.driverContactAddress;
    data['idCard'] = this.idCard;
    data['idCardImgUrl1'] = this.idCardImgUrl1;
    data['idCardImgUrl2'] = this.idCardImgUrl2;
    data['getDriverLicenseDate'] = this.getDriverLicenseDate;
    data['type'] = this.type;
    data['placeOfPractice'] = this.placeOfPractice;
    data['placeOfEmployment'] = this.placeOfEmployment;
    data['driveCardImgUrl'] = this.driveCardImgUrl;
    data['networkCarlssueImg'] = this.networkCarlssueImg;
    data['language'] = this.language;
    data['referralCode'] = this.referralCode;
    return data;
  }
}
