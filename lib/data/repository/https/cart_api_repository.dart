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

      final Map<String, dynamic> responseData = json.decode(response.body);
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

      if (response.statusCode != 200) {
        throw Exception('Failed to get cart: ${response.body}');
      }
      if (response.body.isEmpty) {
        print('CartApiRepository: Empty response body');
        return CartDto.fromJson({'item': []});
      }

      Map<String, dynamic> responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        print('CartApiRepository: JSON parsing error: $e');
        print('CartApiRepository: Raw response: ${response.body}');
        return CartDto.fromJson({'item': []});
      }
      Map<String, dynamic> cartData;
      if (responseData.containsKey('data')) {
        print('CartApiRepository: Found nested data field');
        cartData = responseData['data'];
      } else {
        print('CartApiRepository: Using top-level response data');
        cartData = responseData;
      }

      if (!cartData.containsKey('item') || cartData['item'] == null) {
        cartData['item'] = [];
      }
      return CartDto.fromJson(cartData);
    } catch (e) {
      print('CartApiRepository: Error getting cart: $e');
      return CartDto.fromJson({'item': []});
    }
  }
  @override
  Future<void> clearCart() async {
    try {
      final token = await repository.getCurrentToken();
      final headers = _getAuthHeaders(token);
      final response = await FetchingData.deleteCart(
        ApiConstant.clearCart,
        {},
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
      print('Update cart response status: ${response.statusCode}');
      print('Update cart response body: ${response.body}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to update cart item: ${response.body}');
      }
    } catch (e) {
      print('Error updating cart item: $e');
      throw Exception('Error updating cart item: $e');
    }
  }
}
