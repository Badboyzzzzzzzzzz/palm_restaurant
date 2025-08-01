// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:palm_ecommerce_app/models/favorite/favourite.dart';
import 'package:palm_ecommerce_app/models/product/product.dart';
import 'package:palm_ecommerce_app/ui/provider/favorite_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/home/widget/food_details.dart';
import 'package:palm_ecommerce_app/util/animation.dart';
import 'package:provider/provider.dart';

class FoodFavoriteCard extends StatelessWidget {
  final FavouriteModel products;
  final ScrollController? scrollController;
  const FoodFavoriteCard({
    super.key,
    required this.products,
    this.scrollController,
  });
  void _toggleFavorite(BuildContext context) async {
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);

    try {
      await favoriteProvider.addToFavorite(products.productId ?? '');
      await favoriteProvider.getFavoriteProducts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update favorites: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.of(context).push(
                AnimationUtils.createBottomToTopRoute(
                  FoodDetails(
                      product: ProductDetailModel(
                    productId: products.productId ?? '',
                    productNameEn: products.productNameEn ?? '',
                    salePrice: products.salePrice ?? '',
                    photo: products.photo ?? [],
                    isFavourite: products.isFavourite ?? 0,
                  )),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: CachedNetworkImage(
                          imageUrl: products.photo != null &&
                                  products.photo!.isNotEmpty &&
                                  products.photo![0].photo != null
                              ? products.photo![0].photo!
                              : '',
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: Icon(Icons.image_not_supported,
                                color: Colors.grey[400], size: 32),
                          ),
                        )),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                products.productNameEn ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF391713),
                                ),
                                maxLines: 1,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleFavorite(context),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  products.isFavourite == 1
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: products.isFavourite == 1
                                      ? Colors.red
                                      : Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Color(0xFFF5D248),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  products.avgStar ?? '0.0',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${products.countRate ?? 0}+ Rating)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '\$${products.salePrice ?? '0.00'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF5D248),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
