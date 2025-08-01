// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/models/product/product.dart';
import 'package:palm_ecommerce_app/ui/screens/home/category/widget/list_view_food_dishes.dart';
import 'package:palm_ecommerce_app/ui/screens/home/widget/food_card.dart';
import 'package:palm_ecommerce_app/ui/screens/home/widget/food_details.dart';

class CategoryProductGrid extends StatelessWidget {
  final List<ProductDetailModel> products;
  final bool isGridView;
  const CategoryProductGrid({
    super.key,
    required this.products,
    this.isGridView = true,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${products.length} Dishes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF391713),
                  letterSpacing: 0.3,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFFF5D248).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isGridView ? Icons.grid_view : Icons.list,
                      size: 16,
                      color: Color(0xFFF5D248),
                    ),
                    SizedBox(width: 4),
                    Text(
                      isGridView ? 'Grid' : 'List',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFF5D248),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: products.isEmpty
                ? _buildEmptyState()
                : isGridView
                    ? _FoodGridItem(products: products)
                    : ViewFoodDishList(products: products),
          ),
        ],
      ),
    );
  }
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No products available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try selecting a different category',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
class _FoodGridItem extends StatelessWidget {
  final List<ProductDetailModel> products;
  const _FoodGridItem({required this.products});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final hasPhotos = product.photo != null && product.photo!.isNotEmpty;
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FoodDetails(product: product)));
          },
          child: FoodCard(
            product: product,
            imageUrl: hasPhotos ? product.photo![0].photo ?? '' : '',
            name: product.productNameEn ?? '',
            price: product.salePrice ?? '',
            soldQuantity: product.soldQty ?? '',
          ),
        );
      },
    );
  }
}
