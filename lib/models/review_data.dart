import 'package:palm_ecommerce_app/models/photo.dart';

class ReviewDataModel {
  String? avgStar;
  GroubByStarRate? groubByStarRate;
  List<CustomerReview> customerReview = [];

  ReviewDataModel({this.avgStar, this.groubByStarRate, this.customerReview = const []});

  ReviewDataModel.fromJson(Map<dynamic, dynamic> json) {
    avgStar = json['avg_star'];
    groubByStarRate = json['groub_by_star_rate'] != null
        ?  GroubByStarRate.fromJson(json['groub_by_star_rate']) : null;

    print("my customer ${json["customer_review"]}");
    if (json['customer_review'] != null) {
      customerReview = <CustomerReview>[];
      json['customer_review']["data"].forEach((v) {
        customerReview.add( CustomerReview.fromJson(v));
      });
    }
  }
}

class GroubByStarRate {
  String? s1;
  String? s2;
  String? s3;
  String? s4;
  String? s5;

  GroubByStarRate({this.s1, this.s2, this.s3, this.s4, this.s5});

  GroubByStarRate.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
    s5 = json['5'];
  }
}

class CustomerReview {
  String? name;
  String? productId;
  String? starQty;
  String? userId;
  String? comment;
  String? createAt;
  String? id;
  List<Photo>? photo;

  CustomerReview(
      {this.name,
      this.productId,
      this.createAt,
      this.starQty,
      this.userId,
      this.comment,
      this.id,
      this.photo});

  CustomerReview.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    productId = json['product_id'];
    starQty = json['star_qty'];
    createAt=json['created_at'];
    userId = json['user_id'];
    comment = json['comment'];
    id = json['id'];
    if (json['photo'] != null) {
      photo = <Photo>[];
      json['photo'].forEach((v) {
        photo!.add(Photo.fromJson(v));
      });
    }
  }
}
