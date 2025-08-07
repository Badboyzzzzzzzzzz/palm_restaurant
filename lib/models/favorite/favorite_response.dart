// Add a wrapper class to handle the complete API response with pagination
import 'package:palm_ecommerce_app/models/favorite/favorite_data.dart';

class FavouriteResponse {
  bool? success;
  int? status;
  FavouriteData? data;
  String? message;
  String? currency;

  FavouriteResponse(
      {this.success, this.status, this.data, this.message, this.currency});
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavouriteResponse &&
        other.success == success &&
        other.status == status &&
        other.data == data &&
        other.message == message &&
        other.currency == currency;
  }

  @override
  int get hashCode =>
      super.hashCode ^
      success.hashCode ^
      status.hashCode ^
      data.hashCode ^
      message.hashCode ^
      currency.hashCode;
}
