import 'package:palm_ecommerce_app/models/photo.dart';

class FavouriteModel {
  String? productId;
  String? productNameEn;
  String? productNameKh;
  String? salePrice;
  String? createdAt;
  int? isBest;
  int? isSupperHot;
  String? priceAfterPromotion;
  String? promotion;
  String? discountPercentage;
  int? isNewArrive;
  List<Photo>? photo;
  int? isFavourite;
  dynamic soldQty; // Changed to dynamic to handle both string and number
  String? avgStar;
  int? countRate;

  FavouriteModel(
      {this.productId,
      this.productNameEn,
      this.productNameKh,
      this.salePrice,
      this.createdAt,
      this.isBest,
      this.isSupperHot,
      this.priceAfterPromotion,
      this.promotion,
      this.discountPercentage,
      this.isNewArrive,
      this.photo,
      this.isFavourite,
      this.soldQty,
      this.avgStar,
      this.countRate});

  FavouriteModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productNameEn = json['product_name_en'];
    productNameKh = json['product_name_kh'];
    salePrice = json['sale_price'];
    createdAt = json['created_at'];
    isBest = json['is_best'];
    isSupperHot = json['is_supper_hot'];
    priceAfterPromotion = json['price_after_promotion'];
    promotion = json['promotion'];
    discountPercentage = json['discount_percentage'];
    isNewArrive = json['is_new_arrive'];
    if (json['photo'] != null) {
      photo = <Photo>[];
      json['photo'].forEach((v) {
        photo!.add(Photo.fromJson(v));
      });
    }
    isFavourite = json['is_favourite'];
    // Handle soldQty which can be a string, number or null
    if (json['sold_qty'] == null) {
      soldQty = "0";
    } else {
      soldQty = json['sold_qty'].toString();
    }
    avgStar = json['avg_star']?.toString();
    countRate = json['count_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name_en'] = productNameEn;
    data['product_name_kh'] = productNameKh;
    data['sale_price'] = salePrice;
    data['created_at'] = createdAt;
    data['is_best'] = isBest;
    data['is_supper_hot'] = isSupperHot;
    data['price_after_promotion'] = priceAfterPromotion;
    data['promotion'] = promotion;
    data['discount_percentage'] = discountPercentage;
    data['is_new_arrive'] = isNewArrive;
    if (photo != null) {
      data['photo'] = photo!.map((v) => v.toJson()).toList();
    }
    data['is_favourite'] = isFavourite;
    data['sold_qty'] = soldQty;
    data['avg_star'] = avgStar;
    data['count_rate'] = countRate;
    return data;
  }
}

// Add a wrapper class to handle the complete API response with pagination
class FavouriteResponse {
  bool? success;
  int? status;
  FavouriteData? data;
  String? message;
  String? currency;

  FavouriteResponse(
      {this.success, this.status, this.data, this.message, this.currency});

  FavouriteResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    data = json['data'] != null ? FavouriteData.fromJson(json['data']) : null;
    message = json['message'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['currency'] = currency;
    return data;
  }
}

class FavouriteData {
  int? currentPage;
  List<FavouriteModel>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  FavouriteData(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  FavouriteData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <FavouriteModel>[];
      json['data'].forEach((v) {
        data!.add(FavouriteModel.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}
