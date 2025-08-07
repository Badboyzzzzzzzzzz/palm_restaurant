import 'package:palm_ecommerce_app/models/category/main_category.dart';

class CategoryDTO {
  // Convert Category model to JSON
  static Map<String, dynamic> toJson(MainCategoryModel category) {
    return {
      'id': category.id,
      'inventroyTypeKh':category.inventroyTypeKh,
      'photo': category.photo,
      'inventroyTypeK':category.inventroyType,
      'mainCategoryName': category.mainCategoryName,
    };
  }
  // Create Category model from JSON
  static MainCategoryModel fromJson(Map<String, dynamic> json) {
    return MainCategoryModel(
      id: json['id'].toString(),
      inventroyTypeKh: json['inventroyTypeKh'] ?? '',
      photo: json['photo'] ?? '',
      inventroyType: json['inventroyType'] ?? '',
      mainCategoryName: json['main_category_name'] ?? '',
    );
  }
}
