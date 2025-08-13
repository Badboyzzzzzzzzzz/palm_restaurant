import 'package:palm_ecommerce_app/models/banner.dart';
import 'package:palm_ecommerce_app/models/product/product.dart';

abstract class ProductRepository {
  Future<List<ProductDetailModel>> getProducts();
  Future<List<ProductDetailModel>> superHotPromotion();
  Future<List<ProductDetailModel>> getNewArrivalFood();
  Future<List<ProductDetailModel>> getRelatedProduct(String productId);
  Future<List<ProductDetailModel>> searchFoodDishes(
      String productName, String categoryId);
  Future<List<BannerModel>> getBannerSlideShow();
}
