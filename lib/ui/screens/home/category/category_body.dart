// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/ui/provider/category_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/home/widget/cart_icon.dart';
import 'package:palm_ecommerce_app/ui/screens/home/widget/notification_icon.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_app/ui/screens/home/category/widget/category_product_grid.dart';
import 'package:palm_ecommerce_app/ui/screens/home/category/widget/category_all_filter.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/screens/home/category/widget/searchProduct.dart';

class CategoryBody extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryBody({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryBody> createState() => _CategoryBodyState();
}

class _CategoryBodyState extends State<CategoryBody>
    with SingleTickerProviderStateMixin {
  int _selectedCategoryIndex = 0; // Default to first subcategory
  String _selectedSubcategoryId = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isGridView = true; // Toggle between grid and list view

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      categoryProvider.fetchSubCategories(widget.categoryId).then((_) {
        if (categoryProvider.subCategories.data != null &&
            categoryProvider.subCategories.data!.isNotEmpty) {
          setState(() {
            _selectedCategoryIndex = 0;
            _selectedSubcategoryId =
                categoryProvider.subCategories.data![0].subId ?? '';
          });
          categoryProvider
              .fetchProductsBySubCategory(_selectedSubcategoryId)
              .then((_) {
            print(
                'DEBUG: Fetched ${categoryProvider.productsBySubCategory.data?.length} products for subcategory $_selectedSubcategoryId');
            if (categoryProvider.productsBySubCategory.data != null) {
              final productIds = categoryProvider.productsBySubCategory.data!
                  .map((p) => p.productId)
                  .toList();
              print('DEBUG: Product IDs: $productIds');
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    print("main category id ${widget.categoryId}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          _buildSubcategoryFilter(categoryProvider),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildProductGrid(categoryProvider),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CartIcon(isFloating: true),
            SizedBox(
              height: 8,
            ),
            FloatingActionButton(
              backgroundColor: Color(0xFFF5D248),
              onPressed: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
              child: Icon(
                _isGridView ? Icons.view_list : Icons.grid_view,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoryFilter(CategoryProvider categoryProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AllCategoryFilter(
            subCategories: categoryProvider.subCategories.data ?? [],
            selectedCategoryIndex: _selectedCategoryIndex,
            onCategoryIndexSelected: (index) {
              setState(() {
                _selectedCategoryIndex = index;
                final subCategories = categoryProvider.subCategories.data ?? [];
                if (index >= 0 && index < subCategories.length) {
                  _selectedSubcategoryId = subCategories[index].subId ?? '';
                  _animationController.reset();
                  categoryProvider
                      .fetchProductsBySubCategory(_selectedSubcategoryId)
                      .then((_) {
                    _animationController.forward();
                    print(
                        'DEBUG: Selected subcategory $index with ID $_selectedSubcategoryId');
                    print(
                        'DEBUG: Fetched ${categoryProvider.productsBySubCategory.data?.length} products');
                  });
                }
              });
            },
            onCategoryIdSelected: (subCategoryId) {
              print('Selected category ID: $subCategoryId');
              setState(() {
                _selectedSubcategoryId = subCategoryId;
              });
              _animationController.reset();
              categoryProvider
                  .fetchProductsBySubCategory(subCategoryId)
                  .then((_) {
                _animationController.forward();
                print('DEBUG: Selected category with ID $subCategoryId');
                print(
                    'DEBUG: Fetched ${categoryProvider.productsBySubCategory.data?.length} products');
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(CategoryProvider categoryProvider) {
    if (categoryProvider.productsBySubCategory.state ==
        AsyncValueState.loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFF5D248),
            ),
            SizedBox(height: 16),
            Text(
              'Loading products...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    if (categoryProvider.productsBySubCategory.state == AsyncValueState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[400],
              size: 60,
            ),
            SizedBox(height: 16),
            Text(
              'Error loading products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[400],
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${categoryProvider.productsBySubCategory.error}',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                categoryProvider
                    .fetchProductsBySubCategory(_selectedSubcategoryId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5D248),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Try Again'),
            ),
          ],
        ),
      );
    }
    if (categoryProvider.productsBySubCategory.state == AsyncValueState.empty ||
        categoryProvider.productsBySubCategory.data == null ||
        categoryProvider.productsBySubCategory.data!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              color: Colors.grey[400],
              size: 60,
            ),
            SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try selecting a different category',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    final products = categoryProvider.productsBySubCategory.data ?? [];
    return CategoryProductGrid(
      products: products,
      isGridView: _isGridView,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF5D248), // Yellow at top
            Color(0xFFD3D0DE),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black87,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.categoryName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                NotificationIcon(),
              ],
            ),
            SizedBox(height: 20),
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Searchproduct(
              categoryId: widget.categoryId,
            ),
          ),
        );
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(
              Icons.search_outlined,
              color: Color(0xFFF5D248),
              size: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: IgnorePointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  enabled: false, // Prevents keyboard from showing up
                ),
              ),
            ),
            Container(
              width: 1,
              height: 30,
              color: Colors.grey[300],
            ),
            IconButton(
              icon: Icon(
                Icons.filter_list,
                color: Color(0xFFF5D248),
              ),
              onPressed: () {
                // Show filter options
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => _buildFilterBottomSheet(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Options',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Sort By',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              _filterChip('Price: Low to High'),
              _filterChip('Price: High to Low'),
              _filterChip('Popularity'),
              _filterChip('Newest First'),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF5D248),
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'Apply Filters',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey[200],
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: TextStyle(fontSize: 14),
    );
  }
}
