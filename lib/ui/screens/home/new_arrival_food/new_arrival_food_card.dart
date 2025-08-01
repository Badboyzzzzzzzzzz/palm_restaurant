import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/models/product/product.dart';
import 'package:palm_ecommerce_app/ui/screens/home/widget/add_to_cart_button.dart';
import 'package:palm_ecommerce_app/ui/screens/home/widget/food_details.dart';
import 'package:palm_ecommerce_app/util/animation.dart';

class NewArrivalFoodCard extends StatelessWidget {
  final ProductDetailModel product;
  const NewArrivalFoodCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(AnimationUtils.createBottomToTopRoute(
          FoodDetails(product: product),
        ));
      },
      child: Container(
        height: 140,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 140,
                height: 140,
                color: Colors.grey[200],
                child: product.photo?[0].photo != null
                    ? CachedNetworkImage(
                        imageUrl: product.photo![0].photo!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.broken_image),
                      )
                    : const Icon(Icons.image_not_supported),
              ),
            ),
            const SizedBox(width: 12),

            // Info section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productNameEn ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${product.soldQty} sold',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Color(0xFFF5D248), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        product.avgStar ?? '0.0',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFC9AA05),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.salePrice ?? '0.00'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5D248),
                    ),
                  ),
                ],
              ),
            ),
            // Add to cart button
            AddToCartButton(product: product),
          ],
        ),
      ),
    );
  }
}
