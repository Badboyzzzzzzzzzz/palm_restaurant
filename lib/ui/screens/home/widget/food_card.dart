// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/models/product/product.dart';
import 'package:palm_ecommerce_app/ui/screens/home/widget/add_to_cart_button.dart';
import 'package:palm_ecommerce_app/ui/screens/home/widget/food_details.dart';
import 'package:palm_ecommerce_app/util/animation.dart';

class FoodCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String soldQuantity;
  final ProductDetailModel product;

  const FoodCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.soldQuantity,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    // Debug print to verify product data
    print(
        'DEBUG: Building FoodCard for product ID: ${product.productId}, name: $name');

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          AnimationUtils.createBottomToTopRoute(
            FoodDetails(product: product),
          ),
        );
      },
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Food Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print(
                            'DEBUG: Error loading image for product ${product.productId}: $error');
                        return Container(
                          height: 130,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey[500]),
                        );
                      },
                    )
                  : Container(
                      height: 130,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported,
                          color: Colors.grey[500]),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food Name
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$soldQuantity sold',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  // Price and Add to Cart Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$$price',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF5D248),
                        ),
                      ),
                      AddToCartButton(product: product),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
