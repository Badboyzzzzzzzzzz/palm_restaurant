import 'package:palm_ecommerce_app/models/photo.dart';

class ProductDetailModel {
  String? productId;
  String? productNameEn;
  String? salePrice;
  String? productTypeId;
  String? unitId;
  String? note;
  String? inventoryTypeId;
  String? brandId;
  String? length;
  String? manufacture;
  String? madein;
  String? madeYear;
  String? grade;
  String? childCategoryId;
  dynamic productView;
  String? colorId;
  String? sizeId;
  String? video;
  String? brandName;
  List<Photo>? photo;
  int? isFavourite;
  String? soldQty;
  String? avgStar;
  int? endingStock;
  dynamic color;
  dynamic size;
  String? stock;
  String? priceAfterPromotion;
  List<MediaItem>? mediaItems;

  ProductDetailModel(
      {this.productId,
      this.productNameEn,
      this.salePrice,
      this.productTypeId,
      this.unitId,
      this.note,
      this.inventoryTypeId,
      this.brandId,
      this.length,
      this.manufacture,
      this.madein,
      this.madeYear,
      this.grade,
      this.childCategoryId,
      this.productView,
      this.colorId,
      this.sizeId,
      this.video,
      this.brandName,
      this.photo,
      this.isFavourite,
      this.soldQty,
      this.avgStar,
      this.endingStock,
      this.color,
      this.stock,
      this.priceAfterPromotion,
      this.size,
      this.mediaItems});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productNameEn = json['product_name_en'];
    salePrice = json['sale_price'];
    productTypeId = json['product_type_id'];
    unitId = json['unit_id'];
    note = json['note'];
    inventoryTypeId = json['inventory_type_id'];
    brandId = json['brand_id'];
    length = json['length'];
    manufacture = json['manufacture'];
    madein = json['madein'];
    madeYear = json['madeYear'];
    grade = json['grade'];
    childCategoryId = json['Child_category_id'];
    productView = json['product_view']?.toString();
    colorId = json['color_id'];
    sizeId = json['size_id'];
    video = json['video'];
    brandName = json['brand_name'];
    if (json['photo'] != null) {
      photo = <Photo>[];
      json['photo'].forEach((v) {
        photo!.add(Photo.fromJson(v));
      });
    } else {
      photo = <Photo>[];
    }
    isFavourite = json['is_favourite'] is int
        ? json['is_favourite']
        : int.tryParse(json['is_favourite']?.toString() ?? '0');
    soldQty = json['sold_qty']?.toString();
    avgStar = json['avg_star']?.toString();
    endingStock = json['ending_stock'] is int
        ? json['ending_stock']
        : int.tryParse(json['ending_stock']?.toString() ?? '0');
    color = json['color'];
    size = json['size'];
    stock = json['stock'];
    priceAfterPromotion = json["price_after_promotion"] ?? "0";
    if (json['media_items'] != null) {
      mediaItems = <MediaItem>[];
      json['media_items'].forEach((v) {
        mediaItems!.add(new MediaItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name_en'] = productNameEn;
    data['sale_price'] = salePrice;
    data['product_type_id'] = productTypeId;
    data['unit_id'] = unitId;
    data['note'] = note;
    data['inventory_type_id'] = inventoryTypeId;
    data['brand_id'] = brandId;
    data['length'] = length;
    data['manufacture'] = manufacture;
    data['madein'] = madein;
    data['madeYear'] = madeYear;
    data['grade'] = grade;
    data['Child_category_id'] = childCategoryId;
    data['product_view'] = productView;
    data['color_id'] = colorId;
    data['size_id'] = sizeId;
    data['video'] = video;
    data['brand_name'] = brandName;
    if (photo != null) {
      data['photo'] = photo!.map((v) => v.toJson()).toList();
    }
    data['is_favourite'] = isFavourite;
    data['sold_qty'] = soldQty;
    data['avg_star'] = avgStar;
    data['ending_stock'] = endingStock;
    data['color'] = color;
    data['size'] = size;
    data['stock'] = stock;
    data["price_after_promotion"] = priceAfterPromotion;
    if (mediaItems != null) {
      data['media_items'] = mediaItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MediaItem {
  String url = "";
  String type = "";
  bool? isDisplay = false;

  MediaItem({required this.url, required this.type, this.isDisplay});

  MediaItem.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    type = json['type'];
    isDisplay = json['is_display'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['type'] = type;
    data['is_display'] = isDisplay;
    return data;
  }
}

class OrderProductModel {
  String? productId;
  String? productNameEn;
  String? note;
  String? colorId;
  String? sizeId;
  String? unitPrice;
  String? qty;
  String? isReviewed;
  String? photo;
  String? color;
  String? size;
  String? packagingId;
  String? packagingNote;
  String? packagingQty;

  OrderProductModel(
      {this.productId,
      this.productNameEn,
      this.note,
      this.colorId,
      this.sizeId,
      this.unitPrice,
      this.qty,
      this.isReviewed,
      this.photo,
      this.color,
      this.size,
      this.packagingId,
      this.packagingNote,
      this.packagingQty});

  OrderProductModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to String
    String? toStringValue(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    productId = toStringValue(json['product_id']);
    productNameEn = toStringValue(json['product_name_en']);
    note = toStringValue(json['note']);
    colorId = toStringValue(json['color_id']);
    sizeId = toStringValue(json['size_id']);
    unitPrice = toStringValue(json['unit_price']);
    qty = toStringValue(json['qty']);
    isReviewed = toStringValue(json['is_reviewed']);
    photo = toStringValue(json['photo']);
    color = toStringValue(json['color']);
    size = toStringValue(json['size']);
    packagingId = toStringValue(json['packaging_id']);
    packagingNote = toStringValue(json['packaging_note']);
    packagingQty = toStringValue(json['packaging_qty']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name_en'] = productNameEn;
    data['note'] = note;
    data['color_id'] = colorId;
    data['size_id'] = sizeId;
    data['unit_price'] = unitPrice;
    data['qty'] = qty;
    data['is_reviewed'] = isReviewed;
    data['photo'] = photo;
    data['color'] = color;
    data['size'] = size;
    data['packaging_id'] = packagingId;
    data['packaging_note'] = packagingNote;
    data['packaging_qty'] = packagingQty;
    return data;
  }
}
