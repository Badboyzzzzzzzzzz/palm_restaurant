// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/models/product/product.dart';
import 'package:palm_ecommerce_app/ui/provider/cart_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/favorite_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/home/widget/related_food.dart';
import 'package:palm_ecommerce_app/ui/widget/bottomNavigator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_add_to_cart_button/flutter_add_to_cart_button.dart';

class FoodDetails extends StatefulWidget {
  final ProductDetailModel product;
  const FoodDetails({super.key, required this.product});

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails>
    with SingleTickerProviderStateMixin {
  int quantity = 1;
  bool isFavourite = false;
  AddToCartButtonStateId stateId = AddToCartButtonStateId.idle;

  late AnimationController _favoriteAnimController;
  late Animation<double> _favoriteScaleAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    print('FoodDetails initState');
    print('Product ID: ${widget.product.productId}');
    print('Product Name: ${widget.product.productNameEn}');
    print('Product Price: ${widget.product.salePrice}');
    print('Product Photos: ${widget.product.photo?.length}');
    print('Full product object: $widget.product');
    isFavourite = widget.product.isFavourite == 1;

    // Initialize animation controller for favorite button
    _favoriteAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _favoriteScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
        parent: _favoriteAnimController, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final favoriteProvider =
          Provider.of<FavoriteProvider>(context, listen: false);
      final isInFavorites =
          favoriteProvider.isProductFavorited(widget.product.productId ?? '');
      if (isInFavorites != isFavourite && mounted) {
        setState(() {
          isFavourite = isInFavorites;
        });
      }
    });
  }

  @override
  void dispose() {
    _favoriteAnimController.dispose();
    super.dispose();
  }

  void _toggleFavorite(BuildContext context) async {
    if (_isAnimating) return;
    _isAnimating = true;
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    setState(() {
      isFavourite = !isFavourite;
    });
    _favoriteAnimController.reset();
    _favoriteAnimController.forward().then((_) {
      _isAnimating = false;
    });
    try {
      await favoriteProvider.addToFavorite(widget.product.productId ?? '');
      await favoriteProvider.getFavoriteProducts();
    } catch (e) {
      if (mounted) {
        setState(() {
          isFavourite = !isFavourite;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update favorites: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isInFavorites =
        favoriteProvider.isProductFavorited(widget.product.productId ?? '');
    if (isInFavorites != isFavourite && !_isAnimating) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            isFavourite = isInFavorites;
          });
        }
      });
    }
    final product = widget.product;
    final imageUrl = product.photo;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.45;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFD21B), Color(0xD9D3D0DE)],
          ),
        ),
        child: Stack(
          children: [
            // Food image as background
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: imageHeight,
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl[0].photo ?? '',
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/food_details/burger_main.png',
                      fit: BoxFit.cover,
                    ),
            ),
            // Optionally, add a gradient overlay for readability
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: imageHeight,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.15),
                      Colors.transparent,
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Top app bar with back button and home icon
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
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
                    // Home button
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BottomNavBar())),
                      child: Container(
                        width: 40.0,
                        height: 40.0,
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
                          Icons.home,
                          color: Colors.black87,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Favorite button at bottom right of image
            Positioned(
              top: 100,
              right: 20,
              child: AnimatedBuilder(
                animation: _favoriteScaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _favoriteScaleAnimation.value,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _toggleFavorite(context),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                scale: animation, child: child);
                          },
                          child: Icon(
                            isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            key: ValueKey<bool>(isFavourite),
                            color: isFavourite ? Colors.red : Colors.grey,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // White container with details
            Positioned(
              top: imageHeight - 30,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 24),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Rating and price row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Rating container
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF9D84C4),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Color(0xFFFFD700), size: 20),
                                      const SizedBox(width: 4),
                                      Text(
                                        (product.avgStar != null)
                                            ? double.tryParse(product.avgStar!)
                                                    ?.toStringAsFixed(2) ??
                                                '0.00'
                                            : '0.00',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Price
                                Text(
                                  '\$${product.salePrice}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFC9AA05),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                            // Product name
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    product.productNameEn ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF462B96),
                                        shape: BoxShape.circle,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (quantity > 1) {
                                            setState(() {
                                              quantity--;
                                            });
                                          }
                                        },
                                        child: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(
                                        '$quantity',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF462B96),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF462B96),
                                        shape: BoxShape.circle,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            quantity++;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Product description
                            Text(
                              product.note ?? '',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF727272),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Related food section
                            const Text(
                              'Related Food',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF454545),
                              ),
                            ),

                            const SizedBox(height: 10),
                            // Related food items with fixed height
                            SizedBox(
                              height: 160,
                              child:
                                  RelatedProduct(pID: product.productId ?? ''),
                            ),

                            // Add extra space at bottom for button
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Add to cart button - positioned at the bottom
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 50,
                    child: AddToCartButton(
                      trolley: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      text: const Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      check: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      backgroundColor: const Color(0xFFF5D248),
                      onPressed: (id) {
                        if (id == AddToCartButtonStateId.idle) {
                          // Handle logic when pressed on idle state
                          setState(() {
                            stateId = AddToCartButtonStateId.loading;
                          });

                          // Debug prints before adding to cart
                          print(
                              'Adding to cart: Product ID: ${widget.product.productId}');
                          print('Adding to cart: Quantity: $quantity');

                          // Add the product to the cart
                          final productCartProvider =
                              Provider.of<CartProvider>(context, listen: false);
                          productCartProvider
                              .addToCart(
                                  quantity, widget.product.productId ?? '')
                              .then((_) {
                            // Debug print on success
                            print('Successfully added to cart');

                            // Change to done state after successful addition
                            setState(() {
                              stateId = AddToCartButtonStateId.done;
                            });
                            // Auto reset to idle state after 2 seconds
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) {
                                setState(() {
                                  stateId = AddToCartButtonStateId.idle;
                                });
                              }
                            });
                          }).catchError((error) {
                            // Debug print on error
                            print('Error adding to cart: $error');

                            // Change back to idle state if there's an error
                            setState(() {
                              stateId = AddToCartButtonStateId.idle;
                            });

                            // Show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to add to cart: $error'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          });
                        } else if (id == AddToCartButtonStateId.done) {
                          // Reset to idle state when clicked on done state
                          setState(() {
                            stateId = AddToCartButtonStateId.idle;
                          });
                        }
                      },
                      stateId: stateId,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
