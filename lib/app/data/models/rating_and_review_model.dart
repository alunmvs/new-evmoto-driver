class RatingAndReview {
  double? sumScore;
  List<RatingReview>? ratingReview;

  RatingAndReview({this.sumScore, this.ratingReview});

  RatingAndReview.fromJson(Map<String, dynamic> json) {
    sumScore = json['sumScore'];
    if (json['list'] != null) {
      ratingReview = <RatingReview>[];
      json['list'].forEach((v) {
        ratingReview!.add(new RatingReview.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sumScore'] = this.sumScore;
    if (this.ratingReview != null) {
      data['list'] = this.ratingReview!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RatingReview {
  String? time;
  String? content;
  double? fraction;

  RatingReview({this.time, this.content, this.fraction});

  RatingReview.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    content = json['content'];
    fraction = json['fraction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['content'] = this.content;
    data['fraction'] = this.fraction;
    return data;
  }
}
