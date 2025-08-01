import 'package:palm_ecommerce_app/models/category/sub_category.dart';
import 'package:palm_ecommerce_app/models/product/product.dart';
import 'package:palm_ecommerce_app/models/category/main_category.dart';

abstract class CategoryRepository {
  Future<List<MainCategoryModel>> getCategories();
  Future<List<SubCategoryModel>> getSubCategories(String categoryId);
  Future<List<ProductDetailModel>> getProductsBySubCategory(
      String subCategoryId);
  
}
