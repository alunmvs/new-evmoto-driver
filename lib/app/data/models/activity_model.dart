class Activity {
  int? id;
  String? activityTime;
  List<GuaranteeSubsidy>? guaranteeSubsidy;

  Activity({this.id, this.activityTime, this.guaranteeSubsidy});

  Activity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    activityTime = json['activityTime'];
    if (json['guaranteeSubsidy'] != null) {
      guaranteeSubsidy = <GuaranteeSubsidy>[];
      json['guaranteeSubsidy'].forEach((v) {
        guaranteeSubsidy!.add(new GuaranteeSubsidy.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['activityTime'] = this.activityTime;
    if (this.guaranteeSubsidy != null) {
      data['guaranteeSubsidy'] = this.guaranteeSubsidy!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class GuaranteeSubsidy {
  String? content;
  String? carryOut;

  GuaranteeSubsidy({this.content, this.carryOut});

  GuaranteeSubsidy.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    carryOut = json['carryOut'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['carryOut'] = this.carryOut;
    return data;
  }
}
