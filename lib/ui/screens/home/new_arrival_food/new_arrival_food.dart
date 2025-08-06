import 'dart:async';
import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/ui/provider/product_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/home/new_arrival_food/new_arrival_food_card.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import '../../../../util/data.dart';

class NewArrivalFood extends StatefulWidget {
  const NewArrivalFood({super.key});
  @override
  State<NewArrivalFood> createState() => _HorizontalNewState();
}

class _HorizontalNewState extends State<NewArrivalFood> {
  @override
  void initState() {
    super.initState();
    // Fetch products when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    try {
      final productProvider = context.read<ProductProvider>();
      await productProvider.fetchNewArrivalFood();
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final state = provider.newArrivalFood;

        // Show loading skeleton when loading
        if (state.state == AsyncValueState.loading) {
          return _buildLoadingSkeleton();
        }
        // Show error message when there's an error
        else if (state.state == AsyncValueState.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error to loading product please check your connection!',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          );
        }
        // Show products when data is available
        else if (state.state == AsyncValueState.success &&
            state.data != null &&
            state.data!.isNotEmpty) {
          // Update the listNew in util/data.dart if needed
          if (listNew.isEmpty && state.data!.isNotEmpty) {
            listNew = List.from(state.data!);
          }
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                for (int index = 0;
                    index < state.data!.length && index < 10;
                    index++)
                  NewArrivalFoodCard(
                    product: state.data![index],
                  ),
              ],
            ),
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No products available',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildLoadingSkeleton() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          for (int index = 0; index < 5; index++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 90,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 90,
                    height: 12,
                    color: Colors.grey.shade200,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
