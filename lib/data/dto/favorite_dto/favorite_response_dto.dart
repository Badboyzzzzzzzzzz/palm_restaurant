import 'package:palm_ecommerce_app/data/dto/favorite_dto/favorite_data_dto.dart';
import 'package:palm_ecommerce_app/models/favorite/favorite_response.dart';

class FavoriteResponseDto {
  static FavouriteResponse fromJson(Map<String, dynamic> json) {
    return FavouriteResponse(
      success: json['success'],
      status: json['status'],
      data:
          json['data'] != null ? FavoriteDataDto.fromJson(json['data']) : null,
      message: json['message'],
      currency: json['currency'],
    );
  }

  static Map<String, dynamic> toJson(FavouriteResponse favor) {
    return {
      'success': favor.success,
      'status': favor.status,
      'data': favor.data != null ? FavoriteDataDto.toJson(favor.data!) : null,
      'message': favor.message,
      'currency': favor.currency,
    };
  }
}
