import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/data/repository/category_repository.dart';
import 'package:palm_ecommerce_app/models/category/sub_category.dart';
import 'package:palm_ecommerce_app/models/product/product.dart';
import 'package:palm_ecommerce_app/models/category/main_category.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository categoryRepository;
  CategoryProvider({required this.categoryRepository});

  AsyncValue<List<MainCategoryModel>> _categories = AsyncValue.empty();
  AsyncValue<List<SubCategoryModel>> _subCategories = AsyncValue.empty();
  // AsyncValue<List<ProductDetailModel>> _productsByCategory = AsyncValue.empty();
  AsyncValue<List<ProductDetailModel>> _productsBySubCategory =
      AsyncValue.empty();

  List<MainCategoryModel> _cachedCategories = [];
  Map<String, List<SubCategoryModel>> _cachedSubCategories = {};
  List<ProductDetailModel> _cachedProductsBySubCategory = [];
  //Getters
  AsyncValue<List<MainCategoryModel>> get categories => _categories;
  AsyncValue<List<SubCategoryModel>> get subCategories => _subCategories;
  AsyncValue<List<ProductDetailModel>> get productsBySubCategory =>
      _productsBySubCategory;
  Future<void> fetchCategories() async {
    if (_cachedCategories.isNotEmpty) {
      _categories = AsyncValue.success(_cachedCategories);
      notifyListeners();
    } else {
      _categories = AsyncValue.loading();
      notifyListeners();
    }

    try {
      final categories = await categoryRepository.getCategories();
      _cachedCategories = categories;
      _categories = AsyncValue.success(categories);
    } catch (e) {
      if (_cachedCategories.isNotEmpty) {
        _categories = AsyncValue.success(_cachedCategories);
      } else {
        _categories = AsyncValue.error(e);
      }
    }
    notifyListeners();
  }

  Future<void> fetchSubCategories(String categoryId) async {
    // Return cached data immediately while loading new data
    if (_cachedSubCategories.containsKey(categoryId)) {
      _subCategories = AsyncValue.success(_cachedSubCategories[categoryId]!);
      notifyListeners();
    } else {
      _subCategories = AsyncValue.loading();
      notifyListeners();
    }

    try {
      final subCategories =
          await categoryRepository.getSubCategories(categoryId);
      _cachedSubCategories[categoryId] = subCategories;
      _subCategories = AsyncValue.success(subCategories);
    } catch (e) {
      // If we have cached data, use it on error
      if (_cachedSubCategories.containsKey(categoryId)) {
        _subCategories = AsyncValue.success(_cachedSubCategories[categoryId]!);
      } else {
        _subCategories = AsyncValue.error(e);
      }
    }
    notifyListeners();
  }

  // Future<void> fetchProductsByCategory(String categoryId) async {
  //   // Return cached data immediately while loading new data
  //   if (_cachedProductsByCategory.isNotEmpty) {
  //     _productsByCategory = AsyncValue.success(_cachedProductsByCategory);
  //     notifyListeners();
  //   } else {
  //     _productsByCategory = AsyncValue.loading();
  //     notifyListeners();
  //   }
  //   try {
  //     final products =
  //         await categoryRepository.getProductsByChildCategory(categoryId);
  //     _cachedProductsByCategory = products;
  //     _productsByCategory = AsyncValue.success(products);
  //   } catch (e) {
  //     // If we have cached data, use it on error
  //     if (_cachedProductsByCategory.isNotEmpty) {
  //       _productsByCategory = AsyncValue.success(_cachedProductsByCategory);
  //     } else {
  //       _productsByCategory = AsyncValue.error(e);
  //     }
  //   }
  //   notifyListeners();
  // }

  Future<void> fetchProductsBySubCategory(String subCategoryId) async {
    if (subCategoryId.isEmpty) {
      _productsBySubCategory = AsyncValue.empty();
      notifyListeners();
      return;
    }

    _productsBySubCategory = AsyncValue.loading();
    notifyListeners();

    try {
      final products =
          await categoryRepository.getProductsBySubCategory(subCategoryId);
      _cachedProductsBySubCategory = products;

      if (products.isEmpty) {
        _productsBySubCategory = AsyncValue.empty();
      } else {
        _productsBySubCategory = AsyncValue.success(products);
      }

      debugPrint(
          'Fetched ${products.length} products for subcategory $subCategoryId');
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching products for subcategory $subCategoryId: $e');
      if (_cachedProductsBySubCategory.isNotEmpty) {
        _productsBySubCategory =
            AsyncValue.success(_cachedProductsBySubCategory);
      } else {
        _productsBySubCategory = AsyncValue.error(e);
      }
      notifyListeners();
    }
  }

  // Clear caches when needed (e.g., on logout or force refresh)
  void clearCaches() {
    _cachedCategories = [];
    _cachedSubCategories = {};
    _cachedProductsBySubCategory = [];
  }
}
