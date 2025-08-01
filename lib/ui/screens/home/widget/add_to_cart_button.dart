// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/models/product/product.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_app/ui/provider/cart_provider.dart';

class AddToCartButton extends StatefulWidget {
  final ProductDetailModel product;

  const AddToCartButton({
    super.key,
    required this.product,
  });

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isAdding = false;
  bool _showCheck = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showCheck = false;
          _isAdding = false;
        });
        _animationController.reset();
      } else if (status == AnimationStatus.forward) {
        setState(() {
          _showCheck = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  void _addToCart(String productId) {
    if (_isAdding) return;

    setState(() {
      _isAdding = true;
    });

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    // Add to cart with quantity 1
    cartProvider.addToCart(1, widget.product.productId ?? '').then((_) {
      // Start animation
      _animationController.forward();
    }).catchError((error) {
      // Handle error
      setState(() {
        _isAdding = false;
      });
      // You could show a snackbar or toast here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to add item to cart: ${error.toString()}')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _addToCart(widget.product.productId ?? ''),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: _showCheck ? Colors.green : const Color(0xFF2FD180),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: _isAdding
              ? _showCheck
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : const SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
              : const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 16,
                ),
        ),
      ),
    );
  }
}
