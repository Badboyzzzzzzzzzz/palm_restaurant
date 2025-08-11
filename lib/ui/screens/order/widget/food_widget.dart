// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/models/order/order.dart';
import 'package:palm_ecommerce_app/ui/screens/order/widget/my_order_detail.dart';
import 'package:palm_ecommerce_app/util/animation.dart';
import 'package:palm_ecommerce_app/util/themes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:palm_ecommerce_app/ui/widget/loading_widget.dart';
import 'package:intl/intl.dart';

class FoodWidget extends StatelessWidget {
  final String orderId;
  final List<OrderPhoto> orderPhoto;
  final double price;
  final String deliveryStatus;
  final String orderStatus;
  final String date;
  final int itemCount;
  final VoidCallback? onCancelPressed;
  final bool isAssetImage;
  const FoodWidget({
    super.key,
    required this.orderId,
    required this.orderPhoto,
    required this.price,
    required this.deliveryStatus,
    required this.orderStatus,
    required this.date,
    required this.itemCount,
    this.onCancelPressed,
    this.isAssetImage = false,
  });
  String _formatDate(String dateStr) {
    try {
      final DateTime parsedDate = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(parsedDate);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          AnimationUtils.createBottomToTopRoute(
            MyOrderDetail(orderId: orderId),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColorWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: primaryBackgroundColor,
                ),
                const SizedBox(width: 8),
                Text(
                  "Items Ordered $itemCount",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(date),
                  style: regularText14.copyWith(
                    color: blackColor,
                  ),
                ),
                const Spacer(),
                Text(
                  orderStatus,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 1,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: orderPhoto.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 100,
                          child: ClipRRect(
                            
                            borderRadius: BorderRadius.circular(12),
                            child: isAssetImage
                                ? Image.asset(
                                    orderPhoto[index].photo ?? '',
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: orderPhoto[index].photo ?? '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        LoadingWidget(
                                      isImage: true,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/images/place.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$${price.toStringAsFixed(2)}",
                        style: semiBoldText20.copyWith(
                          color: primaryBackgroundColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        deliveryStatus,
                        style: regularText14.copyWith(
                          color: primaryBackgroundColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (orderStatus.toLowerCase() == "to pay")
                        AnimatedCancelButton(onPressed: onCancelPressed),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedCancelButton extends StatefulWidget {
  final VoidCallback? onPressed;
  const AnimatedCancelButton({super.key, this.onPressed});

  @override
  State<AnimatedCancelButton> createState() => _AnimatedCancelButtonState();
}

class _AnimatedCancelButtonState extends State<AnimatedCancelButton>
    with SingleTickerProviderStateMixin {
  final bool _isPressed = false;
  bool _isLoading = false;
  late AnimationController _loadingController;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _spinnerScaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _buttonScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 2,
      ),
    ]).animate(_loadingController);

    _spinnerScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _loadingController,
        curve: const Interval(0.0, 0.5),
      ),
    );
  }
  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      _loadingController.forward();
      // Simulate loading for 2 seconds before calling the actual onPressed
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          _loadingController.reverse().then((_) {
            setState(() {
              _isLoading = false;
            });
            if (widget.onPressed != null) {
              widget.onPressed!();
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _loadingController,
      builder: (context, child) {
        return GestureDetector(
          onTap: _handleTap,
          child: Transform.scale(
            scale: _isLoading
                ? _buttonScaleAnimation.value
                : (_isPressed ? 0.97 : 1.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryBackgroundColor,
                    primaryBackgroundColor.withRed(220)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: primaryBackgroundColor.withOpacity(0.3),
                    blurRadius: _isPressed ? 4 : 8,
                    spreadRadius: _isPressed ? 0 : 2,
                    offset: Offset(0, _isPressed ? 1 : 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading
                      ? Transform.scale(
                          scale: _spinnerScaleAnimation.value,
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                  const SizedBox(width: 6),
                  Text(
                    _isLoading ? "Cancelling..." : "Cancel Order",
                    style: mediumText14.copyWith(
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
