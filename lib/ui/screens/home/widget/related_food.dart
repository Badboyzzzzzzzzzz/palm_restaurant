// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:palm_ecommerce_app/models/product/product.dart';
import 'package:palm_ecommerce_app/ui/provider/product_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/home/widget/food_details.dart';
import 'package:palm_ecommerce_app/util/animation.dart';
import 'package:provider/provider.dart';
import '../../../provider/async_values.dart';

class RelatedProduct extends StatefulWidget {
  final String pID;
  const RelatedProduct({super.key, required this.pID});
  @override
  State<RelatedProduct> createState() => _RelatedProductState();
}

class _RelatedProductState extends State<RelatedProduct> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      Provider.of<ProductProvider>(context, listen: false)
          .fetchRelatedProduct(widget.pID);
    }
  }

  @override
  void dispose() {
    Provider.of<ProductProvider>(context, listen: false).clearRelatedProducts();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final relatedProductState = provider.relatedProduct;
        print(
            'Number of related products: ${relatedProductState.data?.length}');
        Widget content;
        switch (relatedProductState.state) {
          case AsyncValueState.loading:
            content = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.blueGrey,
                  size: 45.00,
                )),
                const SizedBox(
                  height: 12,
                ),
                const Text('Loading...',
                    style: TextStyle(color: Colors.blueGrey))
              ],
            );
            break;
          case AsyncValueState.error:
            content = Center(
              child: Text(
                'Failed to load related products',
                style: TextStyle(color: Colors.grey),
              ),
            );
            break;
          case AsyncValueState.success:
            content = SizedBox(
              height: 160.0,
              child: ListView.builder(
                itemCount: relatedProductState.data?.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final product = relatedProductState.data?[index];
                  return FoodRelated(
                    product: product,
                  );
                },
              ),
            );
            break;
          case AsyncValueState.empty:
            content = Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.grey),
              ),
            );
            break;
        }
        return content;
      },
    );
  }
}

class FoodRelated extends StatelessWidget {
  final ProductDetailModel? product;

  const FoodRelated({
    super.key,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(AnimationUtils.createBottomToTopRoute(
                  FoodDetails(product: product!)));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Product image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: product?.photo?[0].photo != null
                          ? CachedNetworkImage(
                              imageUrl: product?.photo?[0].photo ?? '',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.image_not_supported),
                            ),
                    ),
                  ),
                  // Product name
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      product?.productNameEn ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Product price
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      '\$${product?.salePrice ?? ''}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC9AA05),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
