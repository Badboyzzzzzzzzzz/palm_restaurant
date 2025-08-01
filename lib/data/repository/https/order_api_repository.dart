import 'dart:convert';
import 'dart:async';

import 'package:palm_ecommerce_app/data/network/api_endpoints.dart';
import 'package:palm_ecommerce_app/data/network/fetchingdata.dart';
import 'package:palm_ecommerce_app/data/repository/https/authentication_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/order_repository.dart';
import 'package:palm_ecommerce_app/models/order/order.dart';

class OrderApiRepository extends OrderRepository {
  final AuthenticationApiRepository repository;
  OrderApiRepository(this.repository);
  final _baseHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  Map<String, String> _getAuthHeaders(String token) => {
        ..._baseHeaders,
        'Authorization': 'Bearer $token',
      };

  @override
  Future<List<OrderModel>> getOrders(String processStatusId) async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }
      final param = {'process_status': processStatusId};
      final headers = _getAuthHeaders(token);
      final response = await FetchingData.getDataPar(
        ApiConstant.getOrders,
        param,
        headers,
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        if (jsonResponse['data'] == null) {
          return [];
        }
        List<dynamic> ordersList;
        if (jsonResponse['data'] is List) {
          ordersList = jsonResponse['data'];
        } else if (jsonResponse['data'] is Map &&
            jsonResponse['data']['data'] is List) {
          ordersList = jsonResponse['data']['data'];
        } else {
          return [];
        }

        final List<OrderModel> orders =
            ordersList.map((e) => OrderModel.fromJson(e)).toList();
        return orders;
      }
      if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      }
      throw Exception('Failed to load orders: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to get orders: $e');
    }
  }

  @override
  Future<OrderDetailModel?> getOrderDetails(String orderId) async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }
      final response = await FetchingData.getHeader(
        '${ApiConstant.orderDetail}/$orderId',
        _getAuthHeaders(token),
      );
      if (response.statusCode == 200) {
        try {
          final jsonResponse =
              json.decode(response.body) as Map<String, dynamic>;
          final orderDetail = OrderDetailModel.fromJson(jsonResponse['data']);
          return orderDetail;
        } catch (parseError) {
          throw Exception('Failed to parse order details: $parseError');
        }
      }
      if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      }
      throw Exception(
          'Failed to get order details: ${response.statusCode} - ${response.body}');
    } catch (e) {
      throw Exception('Failed to get order details: $e');
    }
  }

  @override
  Future<List<TrackingStatusModel>> getOrderStatus() async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }
      final response = await FetchingData.getData(
        ApiConstant.orderListByStatus,
        _getAuthHeaders(token),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        if (jsonResponse['data'] == null) {
          return [];
        }
        List<dynamic> statusList;
        if (jsonResponse['data'] is List) {
          statusList = jsonResponse['data'];
        } else if (jsonResponse['data'] is Map &&
            jsonResponse['data']['data'] is List) {
          statusList = jsonResponse['data']['data'];
        } else {
          return [];
        }
        final List<TrackingStatusModel> orderStatus =
            statusList.map((e) => TrackingStatusModel.fromJson(e)).toList();
        return orderStatus;
      }
      if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      }
      throw Exception('Failed to load order status: ${response.statusCode}');
    } catch (e) {
      print('DEBUG: Error getting order status: $e');
      throw Exception('Failed to get order status: $e');
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }
      final cancelParam = {'order_id': orderId, 'reason_id': '4'};

      print('DEBUG: Canceling order: $orderId');

      final response = await FetchingData.postHeader(
        ApiConstant.cancelOrder.replaceFirst('/', ''),
        _getAuthHeaders(token),
        cancelParam,
      ).timeout(const Duration(seconds: 15));

      print('DEBUG: Cancel order response status: ${response.statusCode}');
      print('DEBUG: Cancel order response body: ${response.body}');
      if (response.statusCode == 200) {
        print('DEBUG: Order canceled successfully');
        return;
      } else {
        print('DEBUG: Failed to cancel order: ${response.statusCode}');
        throw Exception('Failed to cancel order: ${response.statusCode}');
      }
    } on TimeoutException {
      print('DEBUG: Cancel order request timed out');
      throw Exception('Request timed out. Please try again later.');
    } catch (e) {
      print('DEBUG: Error canceling order: $e');
      throw Exception('Failed to cancel order: $e');
    }
  }

  @override
  Future<void> reviewOrder(
      String orderId, String productId, String rating, String comment) async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }

      final reviewParam = {
        'booking_id': orderId,
        'product_id': productId,
        'star_rate': rating,
        'comment': comment,
      };

      print(
          'DEBUG: Submitting review for order: $orderId, product: $productId');

      final response = await FetchingData.postHeader(
        ApiConstant.reviewProduct,
        _getAuthHeaders(token),
        reviewParam,
      ).timeout(const Duration(seconds: 15));

      print('DEBUG: Review response status: ${response.statusCode}');
      print('DEBUG: Review response body: ${response.body}');

      if (response.statusCode == 200) {
        print('DEBUG: Review submitted successfully');
        return;
      } else {
        print('DEBUG: Failed to submit review: ${response.statusCode}');
        throw Exception(
            'Failed to review order: ${response.statusCode} - ${response.body}');
      }
    } on TimeoutException {
      print('DEBUG: Review submission timed out');
      throw Exception('Request timed out. Please try again later.');
    } catch (e) {
      print('DEBUG: Error submitting review: $e');
      throw Exception('Failed to submit review: $e');
    }
  }
}
