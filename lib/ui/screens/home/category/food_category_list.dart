// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/ui/provider/category_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/home/category/category_body.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/util/animation.dart';

class FoodCategory extends StatefulWidget {
  final Function(String) onCategorySelected;
  const FoodCategory({
    super.key,
    required this.onCategorySelected,
  });
  @override
  State<FoodCategory> createState() => _FoodCategoryState();
}

class _FoodCategoryState extends State<FoodCategory> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subCategoryId = context.watch<CategoryProvider>().subCategories;

    return Consumer<CategoryProvider>(
      builder: (context, provider, _) {
        final state = provider.categories;
        if (state.state == AsyncValueState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == AsyncValueState.error) {
          return Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Error loading categories. Please check your connection!',
                style: TextStyle(color: Colors.black, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () =>
                    Provider.of<CategoryProvider>(context, listen: false)
                        .fetchCategories(),
                icon: Icon(Icons.refresh),
                label: Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ));
        } else if (state.state == AsyncValueState.success &&
            state.data != null) {
          final categories = state.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              if (subCategoryId.data != null &&
                  subCategoryId.state == AsyncValueState.success &&
                  index < subCategoryId.data!.length) {}

              return GestureDetector(
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    widget.onCategorySelected(category.id);
                  });
                  Navigator.of(context).push(
                    AnimationUtils.createBottomToTopRoute(
                      CategoryBody(
                        categoryId: category.id,
                        categoryName: category.mainCategoryName,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 90,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade100,
                            ),
                            child: category.photo.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      category.photo,
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                              Icons.category,
                                              color: Colors.grey),
                                    ),
                                  )
                                : Icon(
                                    Icons.category,
                                    color: Colors.grey,
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: Text(
                            category.mainCategoryName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No categories found.'));
        }
      },
    );
  }
}
