import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/provider/product_provider.dart';
import 'package:provider/provider.dart';
import '../../widget/food_card.dart';

class FoodRecommend extends StatefulWidget {
  const FoodRecommend({super.key});

  @override
  State<FoodRecommend> createState() => _FoodRecommendState();
}

class _FoodRecommendState extends State<FoodRecommend> {
  @override
  void initState() {
    super.initState();
    // Fetch top selling food products when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchTopSaleFood();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.read<ProductProvider>();
    final bestSeller = productProvider.topSaleFood;
    Widget content;
    switch (bestSeller.state) {
      case AsyncValueState.loading:
        content = const Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content = const Center(child: Text('Error'));
        break;
      case AsyncValueState.success:
        // Calculate how many items to show (limit to 4 to avoid overflow)
        final itemCount = bestSeller.data != null
            ? (bestSeller.data!.length > 4 ? 4 : bestSeller.data!.length)
            : 0;

        content = Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75, // Adjusted for better card proportions
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final food = bestSeller.data?[index];
              if (food == null) return SizedBox.shrink();

              return FoodCard(
                product: food,
                imageUrl: food.photo?[0].photo ?? '',
                name: food.productNameEn ?? '',
                price: food.salePrice ?? '',
                soldQuantity: food.soldQty ?? '',
              );
            },
          ),
        );
        break;
      case AsyncValueState.empty:
        content = const Center(child: Text('Empty'));
        break;
    }

    return content;
  }
}
