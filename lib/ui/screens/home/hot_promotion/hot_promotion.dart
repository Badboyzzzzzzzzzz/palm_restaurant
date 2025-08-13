import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/provider/product_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/home/widget/food_card.dart';
import 'package:palm_ecommerce_app/util/themes.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_app/l10n/app_localizations.dart';

class ViewAllBestSeller extends StatefulWidget {
  const ViewAllBestSeller({super.key});

  @override
  State<ViewAllBestSeller> createState() => _ViewAllBestSellerState();
}

class _ViewAllBestSellerState extends State<ViewAllBestSeller> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchTopSaleFood();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final bestSeller = productProvider.topSaleFood;
    Widget content;
    switch (bestSeller.state) {
      case AsyncValueState.loading:
        content = const Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content =
            const Center(child: Text('Error loading best seller products'));
        break;
      case AsyncValueState.success:
        if (bestSeller.data == null || bestSeller.data!.isEmpty) {
          content = _buildEmptyState();
        } else {
          content = GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: bestSeller.data?.length,
            itemBuilder: (context, index) {
              final product = bestSeller.data?[index];
              if (product == null) {
                return const SizedBox.shrink();
              }
              return FoodCard(
                imageUrl: product.photo?[0].photo ?? '',
                name: product.productNameEn ?? '',
                price: product.salePrice ?? '',
                soldQuantity: product.soldQty ?? '',
                product: product,
              );
            },
          );
        }
        break;
      case AsyncValueState.empty:
        content = const Center(child: Text('No products to display'));
        break;
    }

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with back and title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  Text(
                    AppLocalizations.of(context)?.hotPromotion ??
                        'Hot Promotion',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            // Main white rounded container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'Discover our most popular dishes!',
                          style: TextStyle(
                            color: Color.fromARGB(255, 220, 119, 85),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: content,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
}
