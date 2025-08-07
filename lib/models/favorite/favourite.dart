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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouriteModel &&
          runtimeType == other.runtimeType &&
          productId == other.productId &&
          productNameEn == other.productNameEn &&
          productNameKh == other.productNameKh &&
          salePrice == other.salePrice &&
          createdAt == other.createdAt &&
          isBest == other.isBest &&
          isSupperHot == other.isSupperHot &&
          priceAfterPromotion == other.priceAfterPromotion &&
          promotion == other.promotion &&
          discountPercentage == other.discountPercentage &&
          isNewArrive == other.isNewArrive &&
          photo == other.photo &&
          isFavourite == other.isFavourite &&
          soldQty == other.soldQty &&
          avgStar == other.avgStar &&
          countRate == other.countRate;
  @override
  int get hashCode =>
      super.hashCode ^
      productId.hashCode ^
      productNameEn.hashCode ^
      productNameKh.hashCode ^
      salePrice.hashCode ^
      createdAt.hashCode ^
      isBest.hashCode ^
      isSupperHot.hashCode ^
      priceAfterPromotion.hashCode ^
      promotion.hashCode ^
      discountPercentage.hashCode ^
      isNewArrive.hashCode ^
      photo.hashCode ^
      isFavourite.hashCode ^
      soldQty.hashCode ^
      avgStar.hashCode ^
      countRate.hashCode;
}


