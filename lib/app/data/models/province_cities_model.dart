class ProvinceCities {
  int? id;
  String? name;
  List<Child>? child;

  ProvinceCities({this.id, this.name, this.child});

  ProvinceCities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['child'] != null) {
      child = <Child>[];
      json['child'].forEach((v) {
        child!.add(new Child.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.child != null) {
      data['child'] = this.child!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Child {
  int? id;
  String? name;
  Null? child;

  Child({this.id, this.name, this.child});

  Child.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    child = json['child'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['child'] = this.child;
    return data;
  }
}
