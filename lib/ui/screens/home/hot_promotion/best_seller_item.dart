// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:palm_ecommerce_app/models/product/product.dart';
import 'package:palm_ecommerce_app/util/animation.dart';
import '../widget/food_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_add_to_cart_button/flutter_add_to_cart_button.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_app/ui/provider/cart_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/favorite_provider.dart';

class BestSellerItem extends StatefulWidget {
  final ProductDetailModel product;
  const BestSellerItem({super.key, required this.product});

  @override
  State<BestSellerItem> createState() => _BestSellerItemState();
}

class _BestSellerItemState extends State<BestSellerItem> {
  AddToCartButtonStateId stateId = AddToCartButtonStateId.idle;
  int quantity = 1;
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.product.isFavourite == 1;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final favoriteProvider =
            Provider.of<FavoriteProvider>(context, listen: false);
        final isInFavorites =
            favoriteProvider.isProductFavorited(widget.product.productId ?? '');
        if (isInFavorites != isFavourite && mounted) {
          setState(() {
            isFavourite = isInFavorites;
          });
        }
      },
    );
  }

  void addToFavorite() async {
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    await favoriteProvider.addToFavorite(widget.product.productId ?? '');
    await favoriteProvider.getFavoriteProducts();
    if (isFavourite != !isFavourite && mounted) {
      setState(() {
        isFavourite = !isFavourite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          AnimationUtils.createBottomToTopRoute(
            FoodDetails(product: widget.product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 16.0),
        width: 160, // Increased width for better visibility
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Food Image with Hero animation
                Hero(
                  tag: "food-${widget.product.productId}",
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.product.photo?[0].photo ?? '',
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CupertinoActivityIndicator()),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.restaurant,
                            size: 40, color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                // Discount badge (if price after promotion is available)
                if (widget.product.priceAfterPromotion != null &&
                    widget.product.priceAfterPromotion != "0" &&
                    widget.product.priceAfterPromotion !=
                        widget.product.salePrice)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'SALE',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Favorite icon
                Positioned(
                  top: 10,
                  right: 10,
                  child: Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, child) {
                      final productId = widget.product.productId ?? '';
                      final isFavorited =
                          favoriteProvider.isProductFavorited(productId);
                      final isRecentlyToggled = favoriteProvider
                          .recentlyToggledProductIds
                          .contains(productId);
                      return GestureDetector(
                        onTap: () {
                          addToFavorite();
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: isRecentlyToggled
                              ? const CupertinoActivityIndicator(
                                  radius: 8,
                                  color: Colors.red,
                                )
                              : Icon(
                                  isFavorited
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorited ? Colors.red : Colors.grey,
                                  size: 18,
                                ),
                        ),
                      );
                    },
                  ),
                ),

                // Rating stars if available
                if (widget.product.avgStar != null &&
                    widget.product.avgStar != "0")
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            widget.product.avgStar ?? '0',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Food details
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12.0, vertical: 8.0), // Reduced vertical padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name with ellipsis for long names
                  Text(
                    widget.product.productNameEn ?? 'Unknown',
                    maxLines: 1, // Reduced from 2 to 1 line
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Brand name if available
                  if (widget.product.brandName != null &&
                      widget.product.brandName!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        widget.product.brandName ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),

                  // Sold quantity badge
                  if (widget.product.soldQty != null &&
                      widget.product.soldQty != "0")
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.product.soldQty} sold',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Price row with original and discounted price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\$${widget.product.salePrice}',
                        style: TextStyle(
                          color: Color(0xFFFFCA48),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      if (widget.product.priceAfterPromotion != null &&
                          widget.product.priceAfterPromotion != "0" &&
                          widget.product.priceAfterPromotion !=
                              widget.product.salePrice)
                        Text(
                          '\$${widget.product.priceAfterPromotion}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 33,
              child: AddToCartButton(
                trolley: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 16,
                ),
                text: const Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                check: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
                borderRadius: BorderRadius.circular(15),
                backgroundColor: const Color(0xFFF5D248),
                onPressed: (id) {
                  if (id == AddToCartButtonStateId.idle) {
                    setState(() {
                      stateId = AddToCartButtonStateId.loading;
                    });
                    final productCartProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    productCartProvider
                        .addToCart(quantity, widget.product.productId ?? '')
                        .then((_) {
                      setState(() {
                        stateId = AddToCartButtonStateId.done;
                      });
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() {
                            stateId = AddToCartButtonStateId.idle;
                          });
                        }
                      });
                    }).catchError((error) {
                      setState(() {
                        stateId = AddToCartButtonStateId.idle;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to add to cart: $error'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    });
                  } else if (id == AddToCartButtonStateId.done) {
                    setState(() {
                      stateId = AddToCartButtonStateId.idle;
                    });
                  }
                },
                stateId: stateId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
