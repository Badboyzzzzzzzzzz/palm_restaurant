import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/data/repository/cart_repository.dart';
import 'package:palm_ecommerce_app/models/cart/cart.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'dart:async';

class CartProvider extends ChangeNotifier {
  final CartRepository repository;
  CartProvider({required this.repository});

  AsyncValue<CartModel> _cart = AsyncValue.empty();
  AsyncValue<List<CartProductItem>> _cartItems = AsyncValue.empty();
  bool get isLoading => _cartItems.state == AsyncValueState.loading;

  // Getters
  AsyncValue<CartModel> get cart => _cart;
  AsyncValue<List<CartProductItem>> get cartItems => _cartItems;

  Future<void> getCart() async {
    _cart = AsyncValue.loading();
    notifyListeners();
    try {
      final cart = await repository.getCart();
      // Check if the cart is empty (no items) and handle appropriately
      if (cart.item.isEmpty) {
        _cart = AsyncValue.empty();
      } else {
        _cart = AsyncValue.success(cart);
      }
      notifyListeners();
    } catch (e) {
      // Check if the error message contains indicators that it's just an empty cart
      String errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('empty') ||
          errorMsg.contains('no items') ||
          errorMsg.contains('not found')) {
        // This is likely just an empty cart situation
        _cart = AsyncValue.empty();
      } else {
        // This is a genuine error (network, server, etc.)
        _cart = AsyncValue.error(e);
      }
      notifyListeners();
    }
  }

  Future<void> addToCart(int quantity, String productId) async {
    final previousCart = _cart;
    try {
      if (_cart.data != null) {
        final currentItems = _cart.data!.item;
        final existingItemIndex =
            currentItems.indexWhere((item) => item.productId == productId);

        List<CartProductItem> updatedItems;
        if (existingItemIndex != -1) {
          updatedItems = List<CartProductItem>.from(currentItems);
          final currentQty =
              int.parse(updatedItems[existingItemIndex].qty ?? '0');
          final newQty = currentQty + quantity;
          updatedItems[existingItemIndex] =
              updatedItems[existingItemIndex].copyWith(qty: newQty.toString());
        } else {
          final newItem = CartProductItem(
            productId: productId,
            qty: quantity.toString(),
          );
          updatedItems = List<CartProductItem>.from(currentItems)..add(newItem);
        }

        final newCount = updatedItems.length;
        final updatedCart = _cart.data!.copyWith(
          item: updatedItems,
          countCart: newCount,
        );
        _cart = AsyncValue.success(updatedCart);
        _cartItems = AsyncValue.success(updatedItems);
        notifyListeners();
      } else {}
      await repository.addToCart(quantity, productId);
      try {
        final cart = await repository.getCart();
        if (cart.item.isEmpty) {
          _cart = AsyncValue.empty();
        } else {
          _cart = AsyncValue.success(cart);
          _cartItems = AsyncValue.success(cart.item);
        }
        notifyListeners();
      } catch (refreshError) {
        print('Error refreshing cart after add: $refreshError');
      }
    } catch (e) {
      _cart = previousCart;
      notifyListeners();
      print('Error adding item to cart: $e');
    }
  }

  Future<void> clearCart() async {
    _cartItems = AsyncValue.loading();
    _cart = AsyncValue.loading();
    notifyListeners();
    try {
      await repository.clearCart();
      // Set cart to empty state directly
      _cart = AsyncValue.empty();
      _cartItems = AsyncValue.empty();
      notifyListeners();
    } catch (e) {
      _cartItems = AsyncValue.error(e);
      _cart = AsyncValue.error(e);
      notifyListeners();
    }
  }

  Future<void> removeFromCart(String productId) async {
    final previousCart = _cart;
    if (_cart.data != null) {
      final updatedItems = _cart.data!.item
          .where((item) => item.productId != productId)
          .toList();
      final newCount = updatedItems.length;
      final updatedCart = _cart.data!.copyWith(
        item: updatedItems,
        countCart: newCount,
      );
      if (updatedItems.isEmpty) {
        _cart = AsyncValue.empty();
      } else {
        _cart = AsyncValue.success(updatedCart);
      }
      notifyListeners();
    }
    try {
      await repository.removeFromCart(productId);
    } catch (e) {
      _cart = previousCart;
      notifyListeners();
      print('Error removing item from cart: $e');
    }
  }

  Future<void> updateCartItem(int qty, String productId) async {
    if (_cart.data == null) return;

    final previousCart = _cart;
    try {
      final currentItems = _cart.data!.item;
      final productIndex =
          currentItems.indexWhere((item) => item.productId == productId);

      if (productIndex != -1) {
        final updatedItems = List<CartProductItem>.from(currentItems);
        updatedItems[productIndex] =
            updatedItems[productIndex].copyWith(qty: qty.toString());

        final updatedCart = _cart.data!.copyWith(item: updatedItems);
        _cart = AsyncValue.success(updatedCart);
        notifyListeners();

        await repository.updateCartItem(qty, productId);
      }
    } catch (e) {
      _cart = previousCart;
      notifyListeners();

      print('Error updating cart item: $e');
    }
  }

  Future<void> updateCartItemAlternative(int qty, String productId) async {
    if (_cart.data == null) return;

    final previousCart = _cart;

    try {
      final currentItems = _cart.data!.item;
      final productIndex =
          currentItems.indexWhere((item) => item.productId == productId);

      if (productIndex != -1) {
        final updatedItems = List<CartProductItem>.from(currentItems);
        updatedItems[productIndex] =
            updatedItems[productIndex].copyWith(qty: qty.toString());

        final updatedCart = _cart.data!.copyWith(item: updatedItems);
        _cart = AsyncValue.success(updatedCart);
        notifyListeners();

        await repository.updateCartItem(qty, productId);
      }
    } catch (e) {
      _cart = previousCart;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> increaseQuantity(String productId) async {
    if (_cart.data == null) return;

    final previousCart = _cart;

    try {
      final currentItems = _cart.data!.item;
      final productIndex =
          currentItems.indexWhere((item) => item.productId == productId);

      if (productIndex != -1) {
        final currentQty = int.parse(currentItems[productIndex].qty ?? '0');
        final newQty = currentQty + 1;
        final updatedItems = List<CartProductItem>.from(currentItems);
        updatedItems[productIndex] =
            updatedItems[productIndex].copyWith(qty: newQty.toString());
        final updatedCart = _cart.data!.copyWith(item: updatedItems);
        _cart = AsyncValue.success(updatedCart);
        notifyListeners();
        await updateCartItemAlternative(newQty, productId);
      }
    } catch (e) {
      _cart = previousCart;
      notifyListeners();
      print('Error increasing quantity: $e');
    }
  }

  Future<void> decreaseQuantity(String productId) async {
    if (_cart.data == null) return;

    final previousCart = _cart;

    try {
      final currentItems = _cart.data!.item;
      final productIndex =
          currentItems.indexWhere((item) => item.productId == productId);

      if (productIndex != -1) {
        final currentQty = int.parse(currentItems[productIndex].qty ?? '0');

        if (currentQty > 1) {
          final newQty = currentQty - 1;

          final updatedItems = List<CartProductItem>.from(currentItems);
          updatedItems[productIndex] =
              updatedItems[productIndex].copyWith(qty: newQty.toString());
          final updatedCart = _cart.data!.copyWith(item: updatedItems);
          _cart = AsyncValue.success(updatedCart);
          notifyListeners();

          await updateCartItemAlternative(newQty, productId);
        } else {
          await removeFromCart(productId);
        }
      }
    } catch (e) {
      _cart = previousCart;
      notifyListeners();
      print('Error decreasing quantity: $e');
    }
  }
}
