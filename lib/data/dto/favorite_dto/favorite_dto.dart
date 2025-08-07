import 'package:palm_ecommerce_app/models/favorite/favourite.dart';
import 'package:palm_ecommerce_app/models/photo.dart';

class FavoriteDto {
  static FavouriteModel fromJson(Map<String, dynamic> json) {
    List<Photo>? photo;
    if (json['photo'] != null) {
      photo = <Photo>[];
      json['photo'].forEach((v) {
        photo!.add(Photo.fromJson(v));
      });
    }
    String soldQty;
    if (json['sold_qty'] == null) {
      soldQty = "0";
    } else {
      soldQty = json['sold_qty'].toString();
    }
    return FavouriteModel(
      productId: json['product_id'],
      productNameEn: json['product_name_en'],
      productNameKh: json['product_name_kh'],
      salePrice: json['sale_price'],
      createdAt: json['created_at'],
      isBest: json['is_best'],
      isSupperHot: json['is_supper_hot'],
      priceAfterPromotion: json['price_after_promotion'],
      promotion: json['promotion'],
      discountPercentage: json['discount_percentage'],
      isNewArrive: json['is_new_arrive'],
      photo: photo,
      isFavourite: json['is_favourite'],
      soldQty: soldQty,
      avgStar: json['avg_star']?.toString(),
      countRate: json['count_rate'],
    );
  }
  static Map<String, dynamic> toJson(FavouriteModel favorite) {
    return {
      'product_id': favorite.productId,
      'product_name_en': favorite.productNameEn,
      'product_name_kh': favorite.productNameKh,
      'sale_price': favorite.salePrice,
      'created_at': favorite.createdAt,
      'is_best': favorite.isBest,
      'is_supper_hot': favorite.isSupperHot,
      'price_after_promotion': favorite.priceAfterPromotion,
      'promotion': favorite.promotion,
      'discount_percentage': favorite.discountPercentage,
      'is_new_arrive': favorite.isNewArrive,
      'photo': favorite.photo?.map((v) => v.toJson()).toList(),
      'is_favourite': favorite.isFavourite,
      'sold_qty': favorite.soldQty,
      'avg_star': favorite.avgStar,
      'count_rate': favorite.countRate,
    };
  }
}
