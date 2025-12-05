class VehicleStatistics {
  String? licensePlate;
  String? brand;
  int? dayNum;
  int? mouthNum;
  int? score;
  int? activity;
  int? work;

  VehicleStatistics({
    this.licensePlate,
    this.brand,
    this.dayNum,
    this.mouthNum,
    this.score,
    this.activity,
    this.work,
  });

  VehicleStatistics.fromJson(Map<String, dynamic> json) {
    licensePlate = json['licensePlate'];
    brand = json['brand'];
    dayNum = json['dayNum'];
    mouthNum = json['mouthNum'];
    score = json['score'];
    activity = json['activity'];
    work = json['work'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['licensePlate'] = this.licensePlate;
    data['brand'] = this.brand;
    data['dayNum'] = this.dayNum;
    data['mouthNum'] = this.mouthNum;
    data['score'] = this.score;
    data['activity'] = this.activity;
    data['work'] = this.work;
    return data;
  }
}
