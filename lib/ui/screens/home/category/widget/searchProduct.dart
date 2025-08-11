// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/provider/product_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/home/category/widget/list_view_food_dishes.dart';
import 'package:provider/provider.dart';

class Searchproduct extends StatefulWidget {
  final String categoryId;
  const Searchproduct({super.key, required this.categoryId});
  @override
  State<Searchproduct> createState() => _SearchproductState();
}

class _SearchproductState extends State<Searchproduct> {
  final TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).clearSearchResults();
    });
  }

  @override
  void dispose() {
    _searchQueryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFF5D248),
          leadingWidth: 65,
          leading: Padding(
            padding: const EdgeInsets.only(left: 4.0),
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
          title: SearchField(
            categoryId: widget.categoryId,
            controller: _searchQueryController,
            onSearching: (isSearching) {
              setState(() {
                _isSearching = isSearching;
              });
            },
          ),
          titleSpacing: 0,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                final state = provider.searchFoodDishes;
                if (_isSearching || state.state == AsyncValueState.loading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingAnimationWidget.staggeredDotsWave(
                          color: Theme.of(context).primaryColor,
                          size: 45,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Searching products...',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  );
                }

                if (state.state == AsyncValueState.error) {
                  print('DEBUG: Search error: ${state.error}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 45),
                        const SizedBox(height: 12),
                        Text(
                          'Error: ${state.error}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => provider.fetchSearchFoodDishes(
                              _searchQueryController.text, widget.categoryId),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final results = state.data ?? [];

                if (results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 80,
                          color: Colors.blueGrey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Try using different keywords or browse categories',
                            style: TextStyle(
                              color: Colors.blueGrey[400],
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ViewFoodDishList(
                  products: results,
                  scrollController: _scrollController,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchField extends StatefulWidget {
  final String categoryId;
  final TextEditingController controller;
  final Function(bool isSearching) onSearching;

  const SearchField({
    super.key,
    required this.controller,
    required this.onSearching,
    required this.categoryId,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Timer? _debounce;
  // Increase debounce time to reduce API calls
  final int _debounceTime = 800; // milliseconds

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: widget.controller,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search for products...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                  
                ),
                onChanged: (value) {
                  widget.onSearching(true);
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(Duration(milliseconds: _debounceTime), () {
                    if (value.trim().isNotEmpty) {
                      print("DEBUG: Searching for: $value");
                      // Execute search and keep loading state until complete
                      productProvider
                          .fetchSearchFoodDishes(value, widget.categoryId)
                          .then((_) {
                        print("DEBUG: Search completed for: $value");
                        // Only set isSearching to false after search completes
                        widget.onSearching(false);
                      }).catchError((error) {
                        print("DEBUG: Search error: $error");
                        widget.onSearching(false);
                      });
                    } else {
                      print("DEBUG: Empty search term, clearing results");
                      widget.onSearching(false);
                      productProvider.clearSearchResults();
                    }
                  });
                },
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    print("DEBUG: Submitting search for: $value");
                    // Keep loading state until search completes
                    widget.onSearching(true);
                    productProvider
                        .fetchSearchFoodDishes(value, widget.categoryId)
                        .then((_) {
                      print(
                          "DEBUG: Search submitted and completed for: $value");
                      widget.onSearching(false);
                    }).catchError((error) {
                      print("DEBUG: Search submission error: $error");
                      widget.onSearching(false);
                    });
                  }
                },
              ),
            ),
            if (widget.controller.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  widget.controller.clear();
                  widget.onSearching(false);
                  print("DEBUG: Clearing search results");
                  Provider.of<ProductProvider>(context, listen: false)
                      .clearSearchResults();
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.black54,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
