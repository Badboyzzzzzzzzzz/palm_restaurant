import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/ui/provider/cart_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/screens/cart_screen/cart_screen.dart';
import 'package:provider/provider.dart';

class CartIcon extends StatefulWidget {
  final bool isFloating;
  const CartIcon({super.key, this.isFloating = false});

  @override
  State<CartIcon> createState() => _CartIconState();
}

class _CartIconState extends State<CartIcon> {
  @override
  void initState() {
    super.initState();
    // Fetch cart data when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).getCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final numberOfItems = cartProvider.cart;
    Widget content;
    switch (numberOfItems.state) {
      case AsyncValueState.loading:
        content = const CircularProgressIndicator();
      case AsyncValueState.error:
        content = const Text('Error');
      case AsyncValueState.success:
        content = Text(
          numberOfItems.data?.countCart.toString() ?? '0',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        );
      case AsyncValueState.empty:
        content = const Text(
          '0',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        );
    }
    if (widget.isFloating) {
      return Positioned(
        right: 32,
        bottom: 32,
        child: _buildFloatingCartIcon(
            context, cartProvider, content, numberOfItems),
      );
    }
    return Stack(
      children: [
        InkWell(
          onTap: () {
            _navigateToCartScreen(context, cartProvider);
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              color: const Color(0xFFE95322),
              size: 20,
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 5,
          child: Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: Colors.blueAccent,
            ),
            child: content,
          ),
        ),
      ],
    );
  }
  Widget _buildFloatingCartIcon(BuildContext context, CartProvider cartProvider,
      Widget content, AsyncValue cartItems) {
    return Stack(
      children: [
        Material(
          elevation: 4,
          shape: CircleBorder(),
          color: const Color(0xFFFFCA48),
          child: InkWell(
            onTap: () {
              _navigateToCartScreen(context, cartProvider);
            },
            customBorder: CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(16),
              width: 56,
              height: 56,
              child: Image.asset(
                'assets/icons/cart.png',
                color: Colors.black,
              ),
            ),
          ),
        ),
        if (cartItems.data?.countCart != null && cartItems.data!.countCart > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red,
              ),
              child: content,
            ),
          ),
      ],
    );
  }

  void _navigateToCartScreen(BuildContext context, CartProvider cartProvider) {
    cartProvider.getCart();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CartScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          var slideAnimation = Tween(begin: begin, end: end).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          );
          return SlideTransition(
            position: slideAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
