import 'package:flutter/foundation.dart';
import 'package:palm_ecommerce_app/data/repository/product_repository.dart';
import 'package:palm_ecommerce_app/models/product/product.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository repository;

  AsyncValue<List<ProductDetailModel>> _products = AsyncValue.empty();
  AsyncValue<ProductDetailModel?> _selectedProduct = AsyncValue.empty();
  AsyncValue<List<ProductDetailModel>> _newArrivalFood = AsyncValue.empty();
  AsyncValue<List<ProductDetailModel>> _topSaleFood = AsyncValue.empty();
  AsyncValue<List<ProductDetailModel>> _relatedProduct = AsyncValue.empty();
  AsyncValue<List<ProductDetailModel>> _searchFoodDishes = AsyncValue.empty();
  ProductProvider({required this.repository});
  //Catch
  List<ProductDetailModel> _cachedProduct = [];
  List<ProductDetailModel> _cachedNewArrivalFood = [];
  List<ProductDetailModel> _cachedTopSaleFood = [];
  List<ProductDetailModel> _cachedRelatedProduct = [];
  List<ProductDetailModel> _cachedSearchFoodDishes = [];

  // Getters
  AsyncValue<List<ProductDetailModel>> get products => _products;
  AsyncValue<ProductDetailModel?> get selectedProduct => _selectedProduct;
  AsyncValue<List<ProductDetailModel>> get newArrivalFood => _newArrivalFood;
  AsyncValue<List<ProductDetailModel>> get topSaleFood => _topSaleFood;
  AsyncValue<List<ProductDetailModel>> get relatedProduct => _relatedProduct;
  AsyncValue<List<ProductDetailModel>> get searchFoodDishes =>
      _searchFoodDishes;
  bool get isLoading => _products.state == AsyncValueState.loading;

  Future<void> fetchProducts() async {
    _products = AsyncValue.loading();
    notifyListeners();
    try {
      final products = await repository.getProducts();
      _cachedProduct = products;
      _products = AsyncValue.success(_cachedProduct);
    } catch (e) {
      _products = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> fetchNewArrivalFood() async {
    _newArrivalFood = AsyncValue.loading();
    notifyListeners();
    try {
      final newArrivalFood = await repository.getNewArrivalFood();
      _cachedNewArrivalFood = newArrivalFood;
      _newArrivalFood = AsyncValue.success(_cachedNewArrivalFood);
    } catch (e) {
      _newArrivalFood = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> fetchTopSaleFood() async {
    // Return cached data immediately if available
    if (_cachedTopSaleFood.isNotEmpty) {
      _topSaleFood = AsyncValue.success(_cachedTopSaleFood);
      notifyListeners();
    } else {
      _topSaleFood = AsyncValue.loading();
      notifyListeners();
    }

    try {
      final topSaleFood = await repository.superHotPromotion();
      _cachedTopSaleFood = topSaleFood;
      _topSaleFood = AsyncValue.success(topSaleFood);
    } catch (e) {
      // If we have cached data, use it on error
      if (_cachedTopSaleFood.isNotEmpty) {
        _topSaleFood = AsyncValue.success(_cachedTopSaleFood);
      } else {
        _topSaleFood = AsyncValue.error(e);
      }
    }
    notifyListeners();
  }

  Future<void> fetchRelatedProduct(String productId) async {
    // Return cached data immediately if available
    if (_cachedRelatedProduct.isNotEmpty) {
      _relatedProduct = AsyncValue.success(_cachedRelatedProduct);
      notifyListeners();
    } else {
      _relatedProduct = AsyncValue.loading();
      notifyListeners();
    }

    try {
      final relatedProduct = await repository.getRelatedProduct(productId);
      print('Number of related : ${relatedProduct.length}');
      _cachedRelatedProduct = relatedProduct;
      _relatedProduct = AsyncValue.success(relatedProduct);
    } catch (e) {
      // If we have cached data, use it on error
      if (_cachedRelatedProduct.isNotEmpty) {
        _relatedProduct = AsyncValue.success(_cachedRelatedProduct);
      } else {
        _relatedProduct = AsyncValue.error(e);
      }
    }
    notifyListeners();
  }

  Future<void> fetchSearchFoodDishes(
      String searchFood, String categoryId) async {
    _searchFoodDishes = AsyncValue.loading();
    notifyListeners();
    try {
      final searchFoodDishes =
          await repository.searchFoodDishes(searchFood, categoryId);
      _cachedSearchFoodDishes = searchFoodDishes;
      _searchFoodDishes = AsyncValue.success(_cachedSearchFoodDishes);
    } catch (e) {
      _searchFoodDishes = AsyncValue.error(e);
    }
    notifyListeners();
  }
  void clearSelectedProduct() {
    _selectedProduct = AsyncValue.empty();
    notifyListeners();
  }

  void clearProducts() {
    _products = AsyncValue.empty();
    notifyListeners();
  }

  void clearRelatedProducts() {
    _relatedProduct = AsyncValue.empty();
    _cachedRelatedProduct = [];
    notifyListeners();
  }

  void clearSearchResults() {
    _searchFoodDishes = AsyncValue.empty();
    _cachedSearchFoodDishes = [];
    notifyListeners();
  }
}
