import 'package:palm_ecommerce_app/models/category/main_category.dart';
import 'package:palm_ecommerce_app/models/product/product.dart';
import 'package:palm_ecommerce_app/models/category/sub_category.dart';

abstract class ProductRepository {
  Future<List<ProductDetailModel>> getProducts();
  Future<List<ProductDetailModel>> superHotPromotion();
  Future<List<SubCategoryModel>> getSubCategory(String categoryId);
  Future<List<MainCategoryModel>> getCategoryProduct();
  Future<List<ProductDetailModel>> getNewArrivalFood();
  Future<List<ProductDetailModel>> getRelatedProduct(String productId);
  Future<List<ProductDetailModel>> searchFoodDishes(
      String productName, String categoryId);
}
