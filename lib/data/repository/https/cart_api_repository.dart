import 'package:palm_ecommerce_app/data/dto/cart_dto/cart_dto.dart';
import 'package:palm_ecommerce_app/data/network/api_endpoints.dart';
import 'package:palm_ecommerce_app/data/network/fetchingdata.dart';
import 'package:palm_ecommerce_app/data/repository/authentication_repository.dart';
import 'package:palm_ecommerce_app/data/repository/cart_repository.dart';
import 'package:palm_ecommerce_app/models/cart/cart.dart';
import 'dart:convert';

class CartApiRepository extends CartRepository {
  late AuthenticationRepository repository;

  final _baseHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Map<String, String> _getAuthHeaders(String token) => {
        ..._baseHeaders,
        'Authorization': 'Bearer $token',
      };

  @override
  Future<CartModel?> addToCart(int quantity, String productId) async {
    try {
      print(
          'Attempting to add product $productId with quantity $quantity to cart');
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        print('Authentication token is empty');
        throw Exception('Authentication token is empty');
      }

      final headers = _getAuthHeaders(token);
      final body = {
        'qty': quantity.toString(),
        'product_id': productId,
        'branch_id': 'PALM-00060001',
        'packaging_id': '1',
        'packaging_qty': '0',
        'packaging_note': '',
      };

      print('Sending add to cart request with body: $body');
      final response = await FetchingData.postHeader(
        ApiConstant.addToCart,
        headers,
        body,
      );

      print('Add to cart response status: ${response.statusCode}');
      print('Add to cart response body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to add item to cart: ${response.body}');
      }
      Map<String, dynamic> responseData;
      try {
        String cleanBody = _cleanJsonString(response.body);
        if (cleanBody.isEmpty) {
          print('Add to cart: Empty response after cleaning');
          return null;
        }
        responseData = json.decode(cleanBody);
      } catch (e) {
        print('Add to cart: JSON parsing error: $e');
        print('Add to cart: Raw response: "${response.body}"');

        String? extractedJson = _extractJsonFromResponse(response.body);
        if (extractedJson != null) {
          try {
            responseData = json.decode(extractedJson);
            print('Add to cart: Successfully extracted JSON from response');
          } catch (extractError) {
            print('Add to cart: Failed to parse extracted JSON: $extractError');
            return null;
          }
        } else {
          throw Exception('Invalid JSON response: $e');
        }
      }

      if (responseData.containsKey('data')) {
        return CartDto.fromJson(responseData);
      }
      return null;
    } catch (e) {
      print('Error adding to cart: $e');
      throw Exception('Error adding to cart: $e');
    }
  }

  @override
  Future<CartModel> getCart() async {
    try {
      final token = await repository.getCurrentToken();
      final headers = _getAuthHeaders(token);
      print('CartApiRepository: Fetching cart...');
      final response = await FetchingData.getDataPar(
        ApiConstant.getCart,
        {
          'branch_id': 'PALM-00060001',
        },
        headers,
      );
      print('CartApiRepository: Response status: ${response.statusCode}');
      print('CartApiRepository: Response body: ${response.body}');
      print(
          'CartApiRepository: Content-Type: ${response.headers['content-type']}');

      if (response.statusCode != 200) {
        throw Exception('Failed to get cart: ${response.body}');
      }

      if (response.body.isEmpty) {
        print('CartApiRepository: Empty response body');
        return CartDto.fromJson({'item': []});
      }
      String? contentType = response.headers['content-type'];
      if (contentType != null && !contentType.contains('application/json')) {
        print(
            'CartApiRepository: Non-JSON response detected. Content-Type: $contentType');
        print('CartApiRepository: Response body: ${response.body}');
        return CartDto.fromJson({'item': []});
      }
      Map<String, dynamic> responseData;
      try {
        // Clean and validate response body before parsing
        String cleanBody = _cleanJsonString(response.body);
        if (cleanBody.isEmpty) {
          print('CartApiRepository: Empty response after cleaning');
          return CartDto.fromJson({'item': []});
        }
        responseData = json.decode(cleanBody);
      } catch (e) {
              String? extractedJson = _extractJsonFromResponse(response.body);
        if (extractedJson != null) {
          try {
            responseData = json.decode(extractedJson);
          } catch (extractError) {
         
            return CartDto.fromJson({'item': []});
          }
        } else {
          return CartDto.fromJson({'item': []});
        }
      }
      Map<String, dynamic> cartData;
      if (responseData.containsKey('data')) {
        cartData = responseData['data'];
      } else {
        cartData = responseData;
      }

      if (!cartData.containsKey('item') || cartData['item'] == null) {
        cartData['item'] = [];
      }
      return CartDto.fromJson(cartData);
    } catch (e) {
      return CartDto.fromJson({'item': []});
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      final token = await repository.getCurrentToken();
      final headers = _getAuthHeaders(token);
      final response = await FetchingData.getData(
        ApiConstant.clearCart,
        headers,
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to clear cart: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error clearing cart: $e');
    }
  }

  @override
  Future<void> removeFromCart(String productId) async {
    try {
      final token = await repository.getCurrentToken();
      final headers = _getAuthHeaders(token);

      final response = await FetchingData.deleteCart(
        ApiConstant.removeCartItem,
        {'product_id': productId, 'branch_id': 'PALM-00060001'},
        headers,
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to remove item from cart: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error removing item from cart: $e');
    }
  }

  @override
  Future<void> updateCartItem(int qty, String productId) async {
    try {
      print('Attempting to update product $productId with quantity $qty');
      final token = await repository.getCurrentToken();
      final headers = _getAuthHeaders(token);
      final body = {
        "qty": qty.toString(),
        "product_id": productId,
        "branch_id": 'PALM-00060001',
      };
      print('Sending update cart request with body: $body');
      final response = await FetchingData.updateCartQuantity(
        ApiConstant.updateCartItem,
        headers,
        body,
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to update cart item: ${response.body}');
      }

      // Validate response if it contains content
      if (response.body.isNotEmpty) {
        String? contentType = response.headers['content-type'];
        if (contentType != null && contentType.contains('application/json')) {
          try {
            String cleanBody = _cleanJsonString(response.body);
            if (cleanBody.isNotEmpty) {
              json.decode(
                  cleanBody); // Just validate, don't need to use the result
              print('Update cart: Valid JSON response received');
            }
          } catch (e) {
            print('Update cart: Invalid JSON in response: $e');
            // Don't throw error for update operations, just log it
          }
        }
      }
    } catch (e) {
      throw Exception('Error updating cart item: $e');
    }
  }

  /// Helper method to clean JSON string by removing invalid characters
  String _cleanJsonString(String jsonString) {
    if (jsonString.isEmpty) return jsonString;

    // Remove BOM (Byte Order Mark) if present
    if (jsonString.startsWith('\uFEFF')) {
      jsonString = jsonString.substring(1);
    }

    jsonString = jsonString.trim();

    // Remove any null characters or other control characters
    jsonString = jsonString.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');

    return jsonString;
  }

  /// Helper method to extract JSON from mixed content (HTML + JSON)
  String? _extractJsonFromResponse(String responseBody) {
    try {
      // Look for JSON patterns in the response

      // Pattern 1: JSON wrapped in HTML or text
      RegExp jsonPattern = RegExp(r'\{.*\}', dotAll: true);
      Match? match = jsonPattern.firstMatch(responseBody);
      if (match != null) {
        String potentialJson = match.group(0)!;
        // Try to parse it to verify it's valid JSON
        try {
          json.decode(potentialJson);
          return potentialJson;
        } catch (e) {
          print('CartApiRepository: Extracted text is not valid JSON: $e');
        }
      }

      int startIndex = responseBody.indexOf('{');
      int endIndex = responseBody.lastIndexOf('}');

      if (startIndex >= 0 && endIndex > startIndex) {
        String potentialJson = responseBody.substring(startIndex, endIndex + 1);
        try {
          json.decode(potentialJson);
          return potentialJson;
        } catch (e) {
          print('CartApiRepository: Extracted substring is not valid JSON: $e');
        }
      }

      return null;
    } catch (e) {
      print('CartApiRepository: Error extracting JSON: $e');
      return null;
    }
  }
}
