import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/models/banner.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/provider/product_provider.dart';
import 'package:provider/provider.dart';

class SlideShowDiscountFood extends StatefulWidget {
  const SlideShowDiscountFood({super.key});

  @override
  State<SlideShowDiscountFood> createState() => _SlideShowDiscountFoodState();
}

class _SlideShowDiscountFoodState extends State<SlideShowDiscountFood> {
  int _current = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchSlideShow();
    });
  }

  @override
  Widget build(BuildContext context) {
    final slideShow = context.watch<ProductProvider>().slideShow;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSlideShow(slideShow),
        const SizedBox(height: 10),
        _buildIndicators(slideShow),
      ],
    );
  }

  Widget _buildSlideShow(AsyncValue<List<BannerModel>> slideShow) {
    switch (slideShow.state) {
      case AsyncValueState.loading:
        return _buildPlaceholder();
      case AsyncValueState.error:
        return _buildError();
      case AsyncValueState.empty:
        return _buildEmpty();
      case AsyncValueState.success:
        final banners = slideShow.data ?? [];
        return CarouselSlider.builder(
          itemCount: banners.length,
          options: CarouselOptions(
            height: 210,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 8),
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: (index, _) => setState(() => _current = index),
          ),
          itemBuilder: (context, index, _) {
            final banner = banners[index];
            return Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF5D248), Color(0xFFFFE082)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Left side text
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner.title ?? 'Special Offer',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Limited Time Only!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6D3A),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              textStyle: const TextStyle(fontSize: 14),
                              elevation: 2,
                            ),
                            onPressed: () {},
                            child: const Text("Order Now"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Right side image
                  Expanded(
                    flex: 5,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: banner.photo != null && banner.photo!.isNotEmpty
                          ? Image.network(
                              banner.photo!,
                              fit: BoxFit.cover,
                              height: double.infinity,
                              errorBuilder: (_, __, ___) => _buildImageError(),
                            )
                          : _buildImageError(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
    }
  }

  Widget _buildPlaceholder() => Container(
        height: 210,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );

  Widget _buildError() => Container(
        height: 210,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Icon(Icons.error_outline, size: 40, color: Colors.red),
        ),
      );

  Widget _buildEmpty() => Container(
        height: 210,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text('No banners available',
              style: TextStyle(color: Colors.grey)),
        ),
      );

  Widget _buildImageError() => Container(
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported,
            color: Colors.black54, size: 40),
      );

  Widget _buildIndicators(AsyncValue<List<BannerModel>> slideShow) {
    final banners = slideShow.data ?? [];
    if (banners.isEmpty || slideShow.state != AsyncValueState.success) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(banners.length, (index) {
        final isActive = _current == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: isActive ? 10 : 8,
          width: isActive ? 10 : 8,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFF6D3A) : const Color(0xFFFFE082),
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
        );
      }),
    );
  }
}
