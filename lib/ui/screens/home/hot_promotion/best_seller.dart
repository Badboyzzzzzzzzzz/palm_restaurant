import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'best_seller_item.dart';

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
        content = Center(child: Text('no products found'));
        break;
      case AsyncValueState.loading:
        content = const Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content = Center(child: Text('Error loading products'));
        break;
      case AsyncValueState.success:
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
    return content;
  }
}
