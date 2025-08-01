import 'package:palm_ecommerce_app/models/category/child_category.dart';

class ChildCategoryDto {
  static ChildCategoryModel fromJson(Map<String, dynamic> json) {
    return ChildCategoryModel(
      id: json['id'] as String? ?? '',
      productTypeId: json['product_type_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameKh: json['name_kh'] as String? ?? '',
      photo: json['photo'] as String? ?? '',
      subCategoryId: json['sub_category_id'] as String? ?? '',
    );
  }
  static Map<String, dynamic> toJson(ChildCategoryModel model) {
    return {
      'id': model.id,
      'product_type_id': model.productTypeId,
      'name': model.name,
      'name_kh': model.nameKh,
      'photo': model.photo,
      'sub_category_id': model.subCategoryId,
    };
  }
}
