// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/util/themes.dart';

class SlideShowDiscountFood extends StatefulWidget {
  const SlideShowDiscountFood({super.key});

  @override
  State<SlideShowDiscountFood> createState() => _SlideShowDiscountFoodState();
}

class _SlideShowDiscountFoodState extends State<SlideShowDiscountFood> {
  int _current = 0;
  final List<Map<String, dynamic>> discountData = const [
    {
      'offer': '30% OFF',
      'description': 'Experience our delicious new dish',
      'image': 'assets/images/food1.png', // Replace with your image
    },
    {
      'offer': 'BUY 1 GET 1',
      'description': 'On all pizzas',
      'image': 'assets/images/food3.png',
    },
    {
      'offer': 'SAVE \$10',
      'description': 'On orders over \$50',
      'image': 'assets/images/food4.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 150,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 10),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 0.95,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: discountData.map((item) {
              return Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Color(0xFFF5D248),
                  borderRadius: BorderRadius.circular(18.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.18),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['description'],
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              item['offer'],
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24.0),
                                border:
                                    Border.all(color: Colors.black12, width: 1),
                              ),
                              child: InkWell(
                                onTap: () {
                                  // Add your order action here
                                },
                                borderRadius: BorderRadius.circular(24.0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0, vertical: 8.0),
                                  child: Text(
                                    'Order Now',

                                    style: TextStyle(
                                      color: blackColor,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Right side with food image
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(18.0),
                          bottomRight: Radius.circular(18.0),
                        ),
                        child: Image.asset(
                          item['image'],
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 150,
                              width: double.infinity,
                              color: primaryBackgroundColor,
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.black54,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Custom indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(discountData.length, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4),
                height: 6,
                width: _current == index ? 24 : 12,
                decoration: BoxDecoration(
                  color:
                      _current == index ? Color(0xFFFF6D3A) : Color(0xFFFFE082),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
