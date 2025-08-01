import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/provider/favorite_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/favorite/widget/food_favorite_card.dart';
import 'package:provider/provider.dart';

class FavoriteScreenBody extends StatefulWidget {
  const FavoriteScreenBody({super.key});
  @override
  State<FavoriteScreenBody> createState() => _FavoriteScreenBodyState();
}

class _FavoriteScreenBodyState extends State<FavoriteScreenBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoriteProvider>(context, listen: false)
          .getFavoriteProducts();
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final favoriteResponse = context.watch<FavoriteProvider>().favoriteProducts;
    final products = favoriteResponse.data?.data?.data ?? [];
    Widget content;
    switch (favoriteResponse.state) {
      case AsyncValueState.loading:
        content = const Center(child: SpinKitWave(color: Colors.grey));
        break;
      case AsyncValueState.error:
        content = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                favoriteResponse.error.toString().contains('Please login')
                    ? 'Please login to view favorites'
                    : 'Error loading favorites',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              if (favoriteResponse.error.toString().contains('Please login'))
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: const Text('Login'),
                )
              else
                TextButton(
                  onPressed: () =>
                      context.read<FavoriteProvider>().getFavoriteProducts(),
                  child: const Text('Retry'),
                )
            ],
          ),
        );
        break;
      case AsyncValueState.success:
        if (products.isEmpty) {
          content = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Items you favorite will appear here',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          );
        } else {
          content = ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return FoodFavoriteCard(products: products[index]);
            },
          );
        }
        break;
      case AsyncValueState.empty:
        content = const Center(
            child: Text(
          'Do not have any favorite please add some',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ));
        break;
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top,
        ),
        child: content,
      ),
    );
  }
}
