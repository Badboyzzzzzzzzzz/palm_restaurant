import 'package:palm_ecommerce_app/models/cart/cart.dart';
import 'package:palm_ecommerce_app/data/dto/cart_item_dto.dart';

class CartDto {
  static CartModel fromJson(Map<String, dynamic> json) {
    // Handle case when 'item' is null or not an array
    final itemJson = json['item'];
    List<CartProductItem> items = [];

    if (itemJson != null && itemJson is List) {
      items = itemJson
          .map<CartProductItem>((x) => CartItemDto.fromJson(x))
          .toList();
    }

    return CartModel(
      item: items,
      countCart: json['count_cart'] ?? 0,
      totalPrice: json['total_price'] ?? '0',
    );
  }

  static Map<String, dynamic> toJson(CartModel cart) {
    return {
      'item': cart.item.map((x) => CartItemDto.toJson(x)).toList(),
      'count_cart': cart.countCart,
      'total_price': cart.totalPrice,
    };
  }
}
