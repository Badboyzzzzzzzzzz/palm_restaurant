import 'dart:convert';

import 'package:palm_ecommerce_app/data/network/api_endpoints.dart';
import 'package:palm_ecommerce_app/data/network/fetchingdata.dart';
import 'package:palm_ecommerce_app/data/repository/bakong_repository.dart';
import 'package:flutter/material.dart';

class BakongApiRepository implements BakongRepository {
  final _baseHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  Map<String, String> _getAuthHeaders(String token) => {
        ..._baseHeaders,
        'Authorization': 'Bearer $token',
      };
  @override
  Future<bool> verifyMd5(String md5) async {
    try {
      debugPrint('Verifying payment with MD5: $md5');
      debugPrint('Using endpoint: ${ApiConstant.verifyBakongPayment}');
      debugPrint('Using token: ${ApiConstant.token}');

      final response = await FetchingData.postHeaderMd5(
        ApiConstant.verifyBakongPayment,
        _getAuthHeaders(ApiConstant.token),
        md5,
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['responseCode'] == 0) {
          return true;
        }
        return false;
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed: Invalid or expired token');
      } else {
        throw Exception('API error: Status code ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error verifying MD5: $e');
      throw Exception('Error verifying payment: $e');
    }
  }
}
