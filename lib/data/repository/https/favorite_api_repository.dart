import 'dart:convert';

import 'package:palm_ecommerce_app/data/Network/fetchingdata.dart';
import 'package:palm_ecommerce_app/data/dto/favorite_dto/favorite_dto.dart';
import 'package:palm_ecommerce_app/data/dto/favorite_dto/favorite_response_dto.dart';
import 'package:palm_ecommerce_app/data/network/api_endpoints.dart';
import 'package:palm_ecommerce_app/data/repository/favorite_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/authentication_api_repository.dart';
import 'package:palm_ecommerce_app/models/favorite/favorite_response.dart';
import 'package:palm_ecommerce_app/models/favorite/favourite.dart';

class FavoriteApiRepository implements FavoriteRepository {
  final AuthenticationApiRepository repository;
  FavoriteApiRepository(this.repository);
  final _baseHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  Map<String, String> _getAuthHeaders(String token) => {
        ..._baseHeaders,
        'Authorization': 'Bearer $token',
      };
  @override
  Future<FavouriteModel> addToFavorites({required String productId}) async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }
      final params = {
        'product_id': productId,
        'branch_id': 'PALM-00060001',
      };
      final response = await FetchingData.postHeader(
        ApiConstant.addToFavorite,
        _getAuthHeaders(token),
        params,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return FavoriteDto.fromJson(responseData);
      } else {
        throw Exception('Failed to add item to favorites: ${response.body}');
      }
    } catch (e) {
      print('Error adding to favorites: $e');
      throw Exception('Error adding to favorites: $e');
    }
  }

  @override
  Future<FavouriteResponse> getFavoriteProducts() async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }
      final param = {
        'branch_id': 'PALM-00060001',
        'page': '1',
      };
      final response = await FetchingData.getDataPar(
        ApiConstant.getFavoriteProducts,
        param,
        _getAuthHeaders(token),
      );
      print('response favorite: ${response.body}');
      print('response favorite: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch favorite products: ${response.body}');
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      return FavoriteResponseDto.fromJson(responseData);
    } catch (e) {
      print('Error fetching favorite products: $e');
      throw Exception('Error fetching favorite products: $e');
    }
  }
}
