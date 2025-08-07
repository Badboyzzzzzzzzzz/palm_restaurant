import 'dart:convert';
import 'package:palm_ecommerce_app/data/network/api_endpoints.dart';
import 'package:palm_ecommerce_app/data/network/fetchingdata.dart';
import 'package:palm_ecommerce_app/data/repository/https/authentication_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/payment_method_repository.dart';
import 'package:palm_ecommerce_app/models/checkout/checkout.dart';
import 'package:palm_ecommerce_app/models/waiting_payment.dart';

class PaymentMethodApiRepository implements PaymentMethodRepository {
  final AuthenticationApiRepository repository;
  PaymentMethodApiRepository(this.repository);
  final _baseHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  Map<String, String> _getAuthHeaders(String token) => {
        ..._baseHeaders,
        'Authorization': 'Bearer $token',
      };
  @override
  Future<WaitingPayment> waitingForPayment() async {
    try {
      final token = await repository.getCurrentToken();
      print(
          "DEBUG: Token for waitingForPayment: ${token.isNotEmpty ? 'Available' : 'Empty'}");

      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }

      print(
          "DEBUG: Calling waitingForPayment API at: ${ApiConstant.waitingForPayment}");
      final response = await FetchingData.getDataPar(
        ApiConstant.waitingForPayment,
        {'branch_id': 'PALM-00060001'},
        _getAuthHeaders(token),
      );

      print("DEBUG: waitingForPayment response status: ${response.statusCode}");
      print("DEBUG: waitingForPayment response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("DEBUG: waitingForPayment parsed JSON: $jsonData");

        if (jsonData['data'] == null) {
          print("DEBUG: waitingForPayment data is null");
          throw Exception('No waiting payment data available');
        }

        return WaitingPayment.fromJson(jsonData['data']);
      } else {
        print(
            "DEBUG: waitingForPayment failed with status: ${response.statusCode}");
        throw Exception('Failed to fetch waiting for payment');
      }
    } catch (e) {
      print("DEBUG: Exception in waitingForPayment: $e");
      rethrow;
    }
  }

  // @override
  // Future<CheckoutABAModel> getKhqrDeeplink({required String orderId}) async {
  //   try {
  //     final token = await repository.getCurrentToken();
  //     print(
  //         "DEBUG: Token for KHQR deeplink: ${token.isNotEmpty ? 'Available' : 'Empty'}");

  //     if (token.isEmpty) {
  //       throw Exception(
  //           'No authentication token available. Please login first.');
  //     }
    
  //     final response = await FetchingData.getDataPar(
  //       ApiConstant.getKhqrDeeplink,
  //       {'order_id': orderId},
  //       _getAuthHeaders(token),
  //     );

  //     print("DEBUG: KHQR deeplink response status: ${response.statusCode}");
  //     print("DEBUG: KHQR deeplink response body: ${response.body}");

  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(response.body);
  //       print("DEBUG: KHQR deeplink parsed JSON: $jsonData");

  //       if (jsonData['success'] == true &&
  //           jsonData['status'] == 200 &&
  //           jsonData['data'] != null) {
  //         print("DEBUG: Using standard response format for KHQR");
  //         try {
  //           if (jsonData['data']['lifetime'] != null) {
  //             print(
  //                 "DEBUG: lifetime field type: ${jsonData['data']['lifetime'].runtimeType}, value: ${jsonData['data']['lifetime']}");
  //           }

  //           return CheckoutABAModel.fromJson(jsonData['data']);
  //         } catch (e) {
  //           print("DEBUG: Error parsing CheckoutABAModel: $e");
  //           final sanitizedData = Map<String, dynamic>.from(jsonData['data']);
  //           if (sanitizedData['lifetime'] != null) {
  //             if (sanitizedData['lifetime'] is! int) {
  //               try {
  //                 sanitizedData['lifetime'] =
  //                     int.parse(sanitizedData['lifetime'].toString());
  //               } catch (_) {
  //                 sanitizedData['lifetime'] = 180;
  //               }
  //             }
  //           } else {
  //             sanitizedData['lifetime'] = 180;
  //           }
  //           return CheckoutABAModel.fromJson(sanitizedData);
  //         }
  //       } else if (jsonData['data'] != null) {
  //         print("DEBUG: Using legacy response format for KHQR");
  //         try {
  //           if (jsonData['data']['lifetime'] != null) {
  //             print(
  //                 "DEBUG: lifetime field type: ${jsonData['data']['lifetime'].runtimeType}, value: ${jsonData['data']['lifetime']}");
  //           }

  //           return CheckoutABAModel.fromJson(jsonData['data']);
  //         } catch (e) {
  //           print("DEBUG: Error parsing CheckoutABAModel: $e");
  //           final sanitizedData = Map<String, dynamic>.from(jsonData['data']);
  //           if (sanitizedData['lifetime'] != null) {
  //             if (sanitizedData['lifetime'] is! int) {
  //               try {
  //                 sanitizedData['lifetime'] =
  //                     int.parse(sanitizedData['lifetime'].toString());
  //               } catch (_) {
  //                 sanitizedData['lifetime'] = 180;
  //               }
  //             }
  //           } else {
  //             sanitizedData['lifetime'] = 180;
  //           }
  //           return CheckoutABAModel.fromJson(sanitizedData);
  //         }
  //       } else {
  //         print("DEBUG: Invalid response format for KHQR: $jsonData");
  //         throw Exception('Invalid response format for KHQR deeplink');
  //       }
  //     } else {
  //       print(
  //           "DEBUG: Failed to get KHQR deeplink with status: ${response.statusCode}");
  //       throw Exception('Failed to get KHQR deeplink');
  //     }
  //   } catch (e) {
  //     print("DEBUG: Exception in getKhqrDeeplink: $e");
  //     rethrow;
  //   }
  // }

  @override
  Future<CheckTransactionModel> checkTransaction(
      {required String orderId}) async {
    try {
      final token = await repository.getCurrentToken();

      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }

      final response = await FetchingData.getDataPar(
        ApiConstant.checkTransaction,
        {'order_id': orderId},
        _getAuthHeaders(token),
      );
      print(
          'DEBUG: Response status code of checkTransaction  : ${response.statusCode}');
      print('DEBUG: Response body of checkTransaction : ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('DEBUG: Parsed JSON data: $jsonData');

        if (jsonData['success'] == true &&
            jsonData['status'] == 200 &&
            jsonData['data'] != null) {
          print('DEBUG: Using standard response format');
          return CheckTransactionModel.fromJson(jsonData['data']);
        } else if (jsonData['data'] != null) {
          print('DEBUG: Using legacy response format');
          return CheckTransactionModel.fromJson(jsonData['data']);
        } else {
          print('DEBUG: Using direct response format');
          return CheckTransactionModel.fromJson(jsonData);
        }
      } else {
        print('DEBUG: API request failed with status: ${response.statusCode}');
        throw Exception('Failed to check transaction status');
      }
    } catch (e) {
      print('DEBUG: Exception in checkTransaction: $e');
      rethrow;
    }
  }
}
