// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/provider/cart_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/checkout/check_out.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:palm_ecommerce_app/l10n/app_localizations.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();

  // Static helper method to format price that can be used by any class
  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).getCart();
    });
  }

  Future<void> _refreshCart() async {
    await Provider.of<CartProvider>(context, listen: false).getCart();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFFFCA48), // Yellow at top
                      const Color.fromARGB(255, 225, 202, 108),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.black87,
                              size: 18,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)?.cart ?? 'My Cart',
                              style: TextStyle(
                                fontSize: 24,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(width: 40),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: RefreshIndicator(
                    onRefresh: _refreshCart,
                    color: const Color(0xFFF5D248),
                    child: _buildCartContent(cartProvider),
                  ),
                ),
              ),
            ],
          ),
          // Fixed bottom section with subtotal, delivery fee, and total
          if (cartProvider.cart.state == AsyncValueState.success &&
              cartProvider.cart.data?.item.isNotEmpty == true)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 56,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckOut(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5D248),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Checkout',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCartContent(CartProvider cartProvider) {
    switch (cartProvider.cart.state) {
      case AsyncValueState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case AsyncValueState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Failed to load cart data',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  cartProvider.getCart();
                },
                child: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
              ),
            ],
          ),
        );
      case AsyncValueState.success:
        final cartItems = cartProvider.cart.data?.item;
        if (cartItems == null || cartItems.isEmpty) {
          return _buildEmptyCartUI();
        }
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Wrap the Text with a Selector to rebuild only when countCart changes
              Selector<CartProvider, int?>(
                selector: (context, provider) => provider.cart.data?.countCart,
                builder: (context, countCart, child) {
                  return Center(
                    child: Text(
                      'You have ${countCart ?? 0} items in your cart',
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Consumer<CartProvider>(
                      key: ValueKey(item.productId),
                      builder: (context, provider, child) {
                        final updatedItem = provider.cart.data?.item.firstWhere(
                          (i) => i.productId == item.productId,
                          orElse: () => item,
                        );
                        return _OrderItem(
                          image: updatedItem?.photo ?? '',
                          title: updatedItem?.productNameEn ?? '',
                          dateTime: DateTime.now().toString(),
                          items: '${updatedItem?.qty ?? '0'} items',
                          price:
                              double.tryParse(updatedItem?.price ?? '0') ?? 0,
                          quantity: int.tryParse(updatedItem?.qty ?? '0') ?? 0,
                          productId: updatedItem?.productId,
                          onDelete: () {
                            provider
                                .removeFromCart(updatedItem?.productId ?? '');
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              // Add padding at the bottom to ensure content isn't hidden behind the fixed bottom section
              SizedBox(height: 220),
            ],
          ),
        );
      case AsyncValueState.empty:
        return _buildEmptyCartUI();
    }
  }

  Widget _buildEmptyCartUI() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart_outlined,
                  size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)?.emptyCart ?? 'Your cart is empty',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final String image;
  final String title;
  final String dateTime;
  final String items;
  final double price;
  final int quantity;
  final String? productId;
  final VoidCallback onDelete;

  const _OrderItem({
    required this.image,
    required this.title,
    required this.dateTime,
    required this.items,
    required this.price,
    required this.quantity,
    required this.onDelete,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    // Format the date string
    String formattedDate = '';
    try {
      final DateTime parsedDate = DateTime.parse(dateTime);
      formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(parsedDate);
    } catch (e) {
      formattedDate = dateTime;
    }
    // Calculate total price based on quantity
    final totalPrice = price * quantity;
    final formattedPrice = CartScreen.formatPrice(totalPrice);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: image.startsWith('http')
              ? Image.network(
                  image,
                  width: 72,
                  height: 108,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 72,
                      height: 108,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                )
              : Image.asset(
                  image,
                  width: 72,
                  height: 108,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 72,
                      height: 108,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF391713),
                    ),
                  ),
                  Text(
                    formattedPrice,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFFFCA48),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Text(
                formattedDate,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF391713),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 5),
                  const SizedBox(width: 5),
                  _QuantitySelector(
                    quantity: quantity,
                    productId: productId,
                  ),
                  _IconButton(
                    icon: Icons.delete_outline,
                    onTap: onDelete,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    items,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF391713),
                    ),
                  ),
                ],
              ),
              Container(
                height: 1,
                color: const Color(0xFFFFD8C7),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: 20,
          weight: 30,
          color: const Color(0xFFFFCA48),
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final String? productId;

  const _QuantitySelector({
    required this.quantity,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13.75),
      ),
      child: Row(
        children: [
          _QuantityButton(
            icon: Icons.remove,
            onTap: () {
              if (productId != null && quantity > 1) {
                final cartProvider =
                    Provider.of<CartProvider>(context, listen: false);
                cartProvider.decreaseQuantity(productId!);
              }
            },
          ),
          const SizedBox(width: 8),
          Text(
            '$quantity',
            style: GoogleFonts.leagueSpartan(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF391713),
            ),
          ),
          const SizedBox(width: 8),
          _QuantityButton(
            icon: Icons.add,
            onTap: () {
              if (productId != null) {
                final cartProvider =
                    Provider.of<CartProvider>(context, listen: false);
                cartProvider.increaseQuantity(productId!);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QuantityButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 24,
          weight: 30,
          color: const Color(0xFFFFCA48),
        ),
      ),
    );
  }
}
