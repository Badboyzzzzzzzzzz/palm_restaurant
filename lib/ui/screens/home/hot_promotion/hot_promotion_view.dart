import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'hot_promotion_card.dart';

class BestSeller extends StatelessWidget {
  const BestSeller({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().topSaleFood;
    Widget content;
    switch (products.state) {
      case AsyncValueState.empty:
        content = _buildEmptyState();
        break;
      case AsyncValueState.loading:
        content = _buildLoadingState();
        break;
      case AsyncValueState.error:
        content = _buildErrorState();
        break;
      case AsyncValueState.success:
        if (products.data == null || products.data!.isEmpty) {
          content = _buildEmptyState();
        } else {
          content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 260,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: products.data?.length,
                  itemBuilder: (context, index) =>
                      BestSellerItem(product: products.data![index]),
                ),
              ),
            ],
          );
        }
        break;
    }
    return content;
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 260,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_fire_department_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Hot Promotions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF391713),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for amazing deals!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 260,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFF5D248),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading promotions...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return SizedBox(
      height: 260,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to Load Promotions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

