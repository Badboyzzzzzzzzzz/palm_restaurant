import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:palm_ecommerce_app/data/dto/category_dto/main_category_dto.dart';
import 'package:palm_ecommerce_app/data/dto/category_dto/sub_category.dart';
import 'package:palm_ecommerce_app/data/network/api_endpoints.dart';
import 'package:palm_ecommerce_app/data/network/fetchingdata.dart';
import 'package:palm_ecommerce_app/data/repository/category_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/authentication_api_repository.dart';
import 'package:palm_ecommerce_app/models/category/sub_category.dart';
import 'package:palm_ecommerce_app/models/product/product.dart';
import 'package:palm_ecommerce_app/models/category/main_category.dart';

class CategoryApiRepository extends CategoryRepository {
  static final _logger = Logger('CategoryApiRepository');
  late AuthenticationApiRepository repository;
  final _baseHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  List<MainCategoryModel>? _categoriesCache;
  final Map<String, List<SubCategoryModel>> _subCategoriesCache = {};
  final List<ProductDetailModel> _productsByCategoryCache = [];
  CategoryApiRepository(this.repository);

  Map<String, String> _getAuthHeaders(String token) => {
        ..._baseHeaders,
        'Authorization': 'Bearer $token',
      };
  @override
  Future<List<MainCategoryModel>> getCategories() async {
    if (_categoriesCache != null) {
      _logger.fine('Returning cached categories');
      return _categoriesCache!;
    }
    _logger.info('Fetching categories from API');
    final token = await repository.getCurrentToken();
    if (token.isEmpty) {
      throw Exception('No authentication token available. Please login first.');
    }
    final response = await FetchingData.getData(
      ApiConstant.mainCategory,
      _getAuthHeaders(token),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      final data = jsonResponse['data'] as List<dynamic>?;
      if (data == null) return [];
      _categoriesCache = data.map((cat) => CategoryDTO.fromJson(cat)).toList();
      return _categoriesCache!;
    }
    throw Exception('Failed to load categories: ${response.statusCode}');
  }

  @override
  Future<List<SubCategoryModel>> getSubCategories(String mainCategoryId) async {
    if (_subCategoriesCache.containsKey(mainCategoryId)) {
      _logger.fine('Returning cached subcategories for $mainCategoryId');
      return _subCategoriesCache[mainCategoryId]!;
    }
    try {
      _logger.info('Fetching subcategories for $mainCategoryId from API');
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }
      final response = await FetchingData.getData(
        ApiConstant.subCategories,
        _getAuthHeaders(token),
      );
      _logger.fine('Sub-categories response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonResponse['data'] as List<dynamic>?;

        if (data == null) return [];
        final subcategories = data
            .map((item) => SubCategoryDTO.fromJson(item))
            .where((sub) => sub.mainCategoryId == mainCategoryId)
            .toList();
        _subCategoriesCache[mainCategoryId] = subcategories;
        return subcategories;
      }
      if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      }

      throw Exception('Failed to load sub-categories: ${response.statusCode}');
    } catch (e) {
      _logger.severe('Error fetching sub-categories: $e');
      rethrow;
    }
  }

  @override
  Future<List<ProductDetailModel>> getProductsBySubCategory(
      String subCategoryId) async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }
      final params = {
        'branch_id': 'PALM-00060001',
        'sub_category_id': subCategoryId,
        'company_id': 'PALM-0006',
        'sort': '1',
      };
      final response = await FetchingData.getDataPar(
        ApiConstant.getProductsBySubCategory,
        params,
        _getAuthHeaders(token),
      );
      print('Category data response: ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        if (jsonResponse['data'] == null) {
          _logger.warning('No data field found in new arrival response');
          return [];
        }
        List<dynamic> productsList;
        if (jsonResponse['data'] is List) {
          productsList = jsonResponse['data'];
        } else if (jsonResponse['data'] is Map &&
            jsonResponse['data']['data'] is List) {
          productsList = jsonResponse['data']['data'];
          print(
              'DEBUG: Raw products list from API: ${productsList.length} items');
          print(
              'DEBUG: First few product IDs: ${productsList.take(3).map((p) => p['product_id']).toList()}');
        } else {
          return [];
        }
        final subCategoryProducts = <ProductDetailModel>[];
        for (var item in productsList) {
          try {
            subCategoryProducts.add(ProductDetailModel.fromJson(item));
          } catch (e) {
            _logger.warning('Error parsing product: $e');
            print('DEBUG: Error parsing product: $e');
            print(
                'DEBUG: Problematic fields in item: ${_identifyProblematicFields(item)}');
          }
        }
        print(
            'DEBUG: Successfully parsed ${subCategoryProducts.length} products out of ${productsList.length}');
        return subCategoryProducts;
      }
      throw Exception('Failed to load products: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching products by sub-category: $e');
    }
  }

  void clearCaches() {
    _categoriesCache = null;
    _subCategoriesCache.clear();
    _productsByCategoryCache.clear();
  }

  String _identifyProblematicFields(Map<String, dynamic> item) {
    final fieldTypes = <String, String>{};
    item.forEach((key, value) {
      fieldTypes[key] = '${value.runtimeType}';
    });
    return fieldTypes.toString();
  }
}
