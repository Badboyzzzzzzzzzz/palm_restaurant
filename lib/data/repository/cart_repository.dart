import 'package:palm_ecommerce_app/models/cart/cart.dart';

abstract class CartRepository {
  Future<CartModel?> addToCart(int quantity, String productId);
  Future<CartModel> getCart();
  Future<void> removeFromCart(String productId);
  Future<void> clearCart();
  Future<void> updateCartItem(int qty, String productId);
}
