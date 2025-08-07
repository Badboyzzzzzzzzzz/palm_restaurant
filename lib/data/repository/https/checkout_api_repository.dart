import 'dart:convert';
import 'package:palm_ecommerce_app/data/Network/fetchingdata.dart';
import 'package:palm_ecommerce_app/data/dto/checkout_dto/checkout_dto.dart';
import 'package:palm_ecommerce_app/data/network/api_endpoints.dart';
import 'package:palm_ecommerce_app/data/repository/checkout_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/authentication_api_repository.dart';
import 'package:palm_ecommerce_app/models/checkout/checkout.dart';
import 'package:palm_ecommerce_app/models/params/checkout_params.dart';

class CheckoutApiRepository implements CheckoutRepository {
  late AuthenticationApiRepository repository;
  CheckoutApiRepository() {
    repository = AuthenticationApiRepository();
  }
  final _baseHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  Map<String, String> _getAuthHeaders(String token) => {
        ..._baseHeaders,
        'Authorization': 'Bearer $token',
      };

  @override
  Future<CheckoutModel> getCheckoutInfo({
    bool? isPickUp,
  }) async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception('Authentication token is empty');
      }
      final queryParams = {
        'is_buy_now': '0',
        'is_recheck_out': '0',
        'branch_id': 'PALM-00060001',
        'is_pick_up': isPickUp.toString(),
      };
      final response = await FetchingData.getDataPar(
        ApiConstant.checkoutInfo,
        queryParams,
        _getAuthHeaders(token),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get checkout info: ${response.body}');
      }
      final Map<String, dynamic> data = json.decode(response.body);
      final checkoutModel = CheckoutDto.fromJson(data['data']);
      return checkoutModel;
    } catch (e) {
      print('Error getting checkout info: $e');
      throw Exception('Error getting checkout info: $e');
    }
  }
  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception('Authentication token is empty');
      }
      final response = await FetchingData.getHeader(
        ApiConstant.paymentMethod,
        _getAuthHeaders(token),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to get payment methods: ${response.body}');
      }
      final data = json.decode(response.body);
      if (data is! List) {
        if (data is Map && data.containsKey('data') && data['data'] is List) {
          return (data['data'] as List)
              .map((item) => PaymentMethodModel.fromJson(item))
              .toList();
        }
        throw Exception('Invalid payment methods response format');
      }

      print("DEBUG: Data is a List, length: ${data.length}");
      return data.map((item) => PaymentMethodModel.fromJson(item)).toList();
    } catch (e) {
      print('DEBUG: Error fetching payment methods: $e');
      throw Exception('Error fetching payment methods: $e');
    }
  }

  @override
  Future<void> checkout({
    CheckoutParams? checkoutParams,
  }) async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception('Authentication token is empty');
      }
      final checkoutParamsJson = {
        'address_id': checkoutParams?.addressId,
        'paymant_method': checkoutParams?.paymentMethod,
        'branch_id': checkoutParams?.branchId,
        'is_pick_up': checkoutParams?.isPickUp,
        'is_buy_now': checkoutParams?.isBuyNow,
        'is_recheck_out': checkoutParams?.isRecheckOut,
      };
      print('DEBUG: Sending checkout params: $checkoutParamsJson');
      final response = await FetchingData.postHeader(
        ApiConstant.checkout,
        _getAuthHeaders(token),
        checkoutParamsJson,
      );
      print('Checkout response: ${response.statusCode} - ${response.body}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Checkout failed');
      }
      return;
    } catch (e) {
      print('Error during checkout: $e');
      throw Exception('Error during checkout: $e');
    }
  }
}
