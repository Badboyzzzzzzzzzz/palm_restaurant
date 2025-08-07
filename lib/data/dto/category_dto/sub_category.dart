import 'package:palm_ecommerce_app/models/category/sub_category.dart';

class SubCategoryDTO {
  static SubCategoryModel fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      subId: json['sub_id'],
      subCategoryName: json['sub_category_name'],
      mainCategoryId: json['main_category_id'],
      productTypeId: json['product_type_id'],
      productCategId: json['product_categ_id'],
      productTypeEn: json['product_type_en'],
      photo: json['photo'],
    );
  }

  static Map<String, dynamic> toJson(SubCategoryModel subCategory) {
    return {
      'sub_id': subCategory.subId,
      'sub_category_name': subCategory.subCategoryName,
      'main_category_id': subCategory.mainCategoryId,
      'product_type_id': subCategory.productTypeId,
      'product_categ_id': subCategory.productCategId,
      'product_type_en': subCategory.productTypeEn,
      'photo': subCategory.photo,
    };
  }
}
