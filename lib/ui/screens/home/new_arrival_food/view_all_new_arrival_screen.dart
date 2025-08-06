import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_app/ui/provider/product_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/screens/home/widget/food_card.dart';
import 'package:palm_ecommerce_app/util/themes.dart';
import 'package:palm_ecommerce_app/l10n/app_localizations.dart';

class NewArrivalScreen extends StatefulWidget {
  const NewArrivalScreen({super.key});
  @override
  State<NewArrivalScreen> createState() => _NewArrivalScreenState();
}

class _NewArrivalScreenState extends State<NewArrivalScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch new arrival food products when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchNewArrivalFood();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        'New Arrival Food: ${context.read<ProductProvider>().newArrivalFood.data?.length}');
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
                    AppLocalizations.of(context)?.newArrival ?? 'New Arrival',
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
                          'Check out our latest dishes!',
                          style: TextStyle(
                            color: Color.fromARGB(255, 220, 119, 85),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Consumer<ProductProvider>(
                          builder: (context, provider, child) {
                            final products = provider.newArrivalFood;
                            switch (products.state) {
                              case AsyncValueState.loading:
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );

                              case AsyncValueState.error:
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                          'Failed to load new arrival products',
                                          style: TextStyle(color: Colors.grey)),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () =>
                                            provider.fetchNewArrivalFood(),
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                );

                              case AsyncValueState.success:
                                final items = products.data!;
                                if (items.isEmpty) {
                                  return const Center(
                                    child: Text(
                                        'No new arrival products available',
                                        style: TextStyle(color: Colors.grey)),
                                  );
                                }

                                return GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.78,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    final product = items[index];
                                    return FoodCard(
                                      product: product,
                                      imageUrl: product.photo?[0].photo ?? '',
                                      name: product.productNameEn ?? '',
                                      price: product.salePrice ?? '',
                                      soldQuantity: product.soldQty ?? '',
                                    );
                                  },
                                );

                              case AsyncValueState.empty:
                                return const Center(
                                  child: Text('No products to display',
                                      style: TextStyle(color: Colors.grey)),
                                );
                            }
                          },
                        ),
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
}
