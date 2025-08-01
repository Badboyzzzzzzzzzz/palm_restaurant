import 'dart:convert';
import 'dart:io';
import 'package:palm_ecommerce_app/data/Network/fetchingdata.dart';
import 'package:palm_ecommerce_app/data/network/api_endpoints.dart';
import 'package:palm_ecommerce_app/data/repository/delivery_adress_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/authentication_api_repository.dart';
import 'package:palm_ecommerce_app/models/delivery.dart';

class DeliveryAddressApiRepository implements DeliveryAddressRepository {
  late AuthenticationApiRepository repository;
  DeliveryAddressApiRepository(this.repository);

  final _baseHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  Map<String, String> _getAuthHeaders(String token) => {
        ..._baseHeaders,
        'Authorization': 'Bearer $token',
      };
  @override
  Future<List<DeliveryAddressModel>> getDeliveryAddresses() async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception('Authentication token is empty');
      }
      final response = await FetchingData.getHeader(
        ApiConstant.getUserLocation,
        _getAuthHeaders(token),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['data'] != null) {
          List<dynamic> addressList = jsonData['data'];
          return addressList
              .map((json) => DeliveryAddressModel.fromJson(json))
              .toList();
        } else if (jsonData is List) {
          return jsonData
              .map((json) => DeliveryAddressModel.fromJson(json))
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to fetch addresses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching addresses: $e');
    }
  }

  @override
  Future<DeliveryAddressModel> addDeliveryAddress(
      DeliveryAddressModel address) async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception('Authentication token is empty');
      }
      List<Map<String, dynamic>> photoData = [];
      if (address.photo != null && address.photo!.isNotEmpty) {
        for (var photo in address.photo!) {
          if (photo.photo != null && photo.photo!.isNotEmpty) {
            try {
              File imageFile = File(photo.photo!);
              if (await imageFile.exists()) {
                List<int> imageBytes = await imageFile.readAsBytes();
                String base64Image = base64Encode(imageBytes);
                photoData.add({'photo': base64Image});
              }
            } catch (e) {
              print('Error processing photo: $e');
            }
          }
        }
      }
      final requestBody = {
        'latitude': address.latitude,
        'longitude': address.longitude,
        'address': address.address,
        'address_type': address.addressType?.addressType,
        'photo': photoData.isNotEmpty ? photoData : null,
        'phone': address.phone,
        'full_name': address.fullName,
      };
      final response = await FetchingData.postHeader(
        ApiConstant.setUserLocation,
        _getAuthHeaders(token),
        requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        print('Server response: $jsonData');

        if (jsonData['data'] != null && jsonData['data'] is Map) {
          return DeliveryAddressModel.fromJson(jsonData['data']);
        } else {
          return address;
        }
      } else {
        final errorBody = response.body;
        print('Server error response: $errorBody');
        throw Exception(
            'Failed to add address: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      throw Exception('Error adding address: $e');
    }
  }

  @override
  Future<DeliveryAddressModel> updateDeliveryAddress(
      DeliveryAddressModel address) async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception('Authentication token is empty');
      }

      final response = await FetchingData.postHeader(
        "api/update-location/${address.id}",
        _getAuthHeaders(token),
        {
          'latitude': address.latitude,
          'longitude': address.longitude,
          'address': address.address,
          'phone': address.phone,
          'full_name': address.fullName,
          'is_active': address.isActive,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['data'] != null) {
          return DeliveryAddressModel.fromJson(jsonData['data']);
        } else {
          return address;
        }
      } else {
        throw Exception('Failed to update address: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating address: $e');
    }
  }

  @override
  Future<void> deleteDeliveryAddress(String id) async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception('Authentication token is empty');
      }

      final response = await FetchingData.postHeader(
        "api/delete-location/$id",
        _getAuthHeaders(token),
        {},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete address: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting address: $e');
    }
  }
}
