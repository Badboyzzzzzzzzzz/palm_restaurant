import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:palm_ecommerce_app/data/network/api_endpoints.dart';
import 'package:palm_ecommerce_app/data/network/fetchingdata.dart';
import 'package:palm_ecommerce_app/data/repository/https/authentication_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/product_repository.dart';
import 'package:palm_ecommerce_app/models/banner.dart';
import 'package:palm_ecommerce_app/models/product/product.dart';

class ProductApiRepository implements ProductRepository {
  static final _logger = Logger('ProductApiRepository');
  late AuthenticationApiRepository repository;
  final _baseHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  final Map<String, ProductDetailModel> _productCache = {};
  Map<String, String> _getAuthHeaders(String token) => {
        ..._baseHeaders,
        'Authorization': 'Bearer $token',
      };

  @override
  Future<List<ProductDetailModel>> getProducts() async {
    if (_productCache.isNotEmpty) {
      return _productCache.values.toList();
    }
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }
      final response = await FetchingData.getData(
        ApiConstant.products,
        _getAuthHeaders(token),
      );
      _logger.fine('Products response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final products = _parseProductsList(jsonResponse);
        for (var product in products) {
          _productCache[product.productId ?? ''] = product;
        }
        return products;
      }
      if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      }
      throw Exception('Failed to load products: ${response.statusCode}');
    } catch (e) {
      _logger.severe('Error fetching products: $e');
      rethrow;
    }
  }

  @override
  Future<List<ProductDetailModel>> getRelatedProduct(String productId) async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }

      final queryParams = {
        'company_id': 'PALM-0006',
        'branch_id': 'PALM-00060001',
        'product_id': productId
      };
      _logger.fine('Fetching related products for product ID: $productId');
      final response = await FetchingData.getDataPar(
        ApiConstant.getRelateFood,
        queryParams,
        _getAuthHeaders(token),
      );

      _logger.fine('Related product response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final products = _parseProductsList(jsonResponse);
        return products;
      }

      _logger
          .warning('Failed to load related products: ${response.statusCode}');
      _logger.warning('Error response: ${response.body}');
      throw Exception(
          'Failed to load related products: ${response.statusCode}');
    } catch (e) {
      _logger.severe('Error fetching related products: $e');
      rethrow;
    }
  }

  @override
  Future<List<ProductDetailModel>> superHotPromotion() async {
    final token = await repository.getCurrentToken();
    if (token.isEmpty) {
      throw Exception('No authentication token available. Please login first.');
    }
    final response = await FetchingData.getData(
      ApiConstant.superHotPromotion,
      _getAuthHeaders(token),
    );
    _logger.fine('Products response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      final products = _parseProductsList(jsonResponse);
      for (var product in products) {
        _productCache[product.productId ?? ''] = product;
      }
      return products;
    }
    if (response.statusCode == 401) {
      throw Exception('Authentication failed. Please login again.');
    }
    throw Exception('Failed to load products: ${response.statusCode}');
  }

  List<ProductDetailModel> _parseProductsList(
      Map<String, dynamic> jsonResponse) {
    _logger.fine('Parsing products from response: $jsonResponse');
    final jsonData = jsonResponse['data'];
    if (jsonData == null) {
      _logger.warning('No data field found in response');
      return [];
    }

    List<dynamic> productsList;
    if (jsonData is List) {
      productsList = jsonData;
    } else if (jsonData is Map) {
      productsList = jsonData['data'] as List? ?? [];
    } else {
      _logger.warning('Unexpected data format: $jsonData');
      return [];
    }

    _logger.fine('Found ${productsList.length} products to parse');
    final products = productsList
        .map((product) => ProductDetailModel.fromJson(product))
        .toList();
    _logger.fine('Successfully parsed ${products.length} products');
    return products;
  }

  void clearCache() {
    _productCache.clear();
  }

  @override
  Future<List<ProductDetailModel>> searchFoodDishes(
      String productName, String categoryId) async {
    try {
      if (productName.trim().isEmpty) {
        return [];
      }
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }

      final params = {
        'word': productName,
        'branch_id': 'PALM-00060001',
        'company_id': 'PALM-0006',
        'category_id': categoryId,
      };
      _logger.fine('Sending search request with params: $params');
      print('DEBUG SEARCH: Sending search with word="$productName"');
      final response = await FetchingData.postHeader(
          ApiConstant.searchFoodDishes, _getAuthHeaders(token), params);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        _logger.fine('Search response: $jsonResponse');

        if (jsonResponse['success'] != true) {
          throw Exception(
              'API returned error: ${jsonResponse['message'] ?? 'Unknown error'}');
        }
        final data = jsonResponse['data'] as Map<String, dynamic>;
        final productsData = data['data'] as List<dynamic>;

        if (productsData.isEmpty) {
          return [];
        }
        return productsData
            .map((item) => ProductDetailModel.fromJson(item))
            .toList();
      }
      _logger.warning('Search failed with status: ${response.statusCode}');
      _logger.warning('Response body: ${response.body}');
      throw Exception('Failed to load products: ${response.statusCode}');
    } catch (e) {
      _logger.severe('Error in search: $e');
      throw Exception('SEARCH Error: $e');
    }
  }

  @override
  Future<List<ProductDetailModel>> getNewArrivalFood() async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }
      final response = await FetchingData.getData(
        ApiConstant.newArrivalProduct,
        _getAuthHeaders(token),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        _logger.fine('New arrival products response: $jsonResponse');
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
        } else {
          return [];
        }
        final products = <ProductDetailModel>[];
        for (var item in productsList) {
          try {
            products.add(ProductDetailModel.fromJson(item));
          } catch (e) {
            _logger.warning('Error parsing new arrival product: $e');
          }
        }
        return products;
      }
      throw Exception(
          'Failed to load new arrival products: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching new arrival food: $e');
    }
  }

  @override
  Future<List<BannerModel>> getBannerSlideShow() async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }
      final response = await FetchingData.getData(
        ApiConstant.bannerSlideShow,
        _getAuthHeaders(token),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        _logger.fine('Banner slideshow response: $jsonResponse');
        if (jsonResponse['data'] == null) {
          _logger.warning('No data field found in banner slideshow response');
          return [];
        }
        List<dynamic> bannersList;
        if (jsonResponse['data'] is List) {
          bannersList = jsonResponse['data'];
        } else if (jsonResponse['data'] is Map &&
            jsonResponse['data']['data'] is List) {
          bannersList = jsonResponse['data']['data'];
        } else {
          return [];
        }
        final banners = <BannerModel>[];
        for (var item in bannersList) {
          try {
            banners.add(BannerModel.fromJson(item));
          } catch (e) {
            _logger.warning('Error parsing banner slideshow item: $e');
          }
        }
        return banners;
      }
      throw Exception(
          'Failed to load banner slideshow: ${response.statusCode}');
    } catch (e) {
      _logger.severe('Error fetching banner slideshow: $e');
      throw Exception('Error fetching banner slideshow: $e');
    }
  }
}
