// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/ui/provider/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/screens/order/widget/review_dialog.dart';

class TrackingStep {
  final String title;
  final bool isCompleted;
  final IconData icon;

  TrackingStep({
    required this.title,
    required this.isCompleted,
    required this.icon,
  });
}

class MyOrderDetail extends StatefulWidget {
  final String orderId;
  const MyOrderDetail({super.key, required this.orderId});

  @override
  State<MyOrderDetail> createState() => _MyOrderDetailState();
}

class _MyOrderDetailState extends State<MyOrderDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = context.read<OrderProvider>();
      orderProvider.getOrderDetails(widget.orderId);
      orderProvider.getOrderStatus(); // Load order status list
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final orderDetail = orderProvider.orderDetails.data;
    final orderStatusList = orderProvider.orderStatus.data ?? [];

    // Define tracking steps dynamically based on order status
    List<TrackingStep> trackingSteps = [];

    // Default icons for different steps
    final Map<String, IconData> statusIcons = {
      'To Pay': Icons.receipt_outlined,
      'Confirmed': Icons.inventory_2_outlined,
      'Shipping': Icons.local_shipping_outlined,
      'Delivered': Icons.delivery_dining_outlined,
      'To Review': Icons.rate_review_outlined,
    };
    final List<String> keyStatusIds = ['1', '2', '3', '4', '5'];
    if (orderDetail != null && orderStatusList.isNotEmpty) {
      final currentStatusId = orderDetail.processStatusId?.toString() ?? '';
      final filteredStatusList = orderStatusList
          .where((status) => keyStatusIds.contains(status.statusProcessId))
          .toList();
      filteredStatusList.sort((a, b) {
        final aId = int.tryParse(a.statusProcessId ?? '0') ?? 0;
        final bId = int.tryParse(b.statusProcessId ?? '0') ?? 0;
        return aId.compareTo(bId);
      });
      for (var status in filteredStatusList) {
        final statusId = status.statusProcessId ?? '';
        final statusName = status.statusProcessEn ?? 'Unknown';
        final isCompleted = int.tryParse(statusId) != null &&
            int.tryParse(currentStatusId) != null &&
            int.parse(statusId) <= int.parse(currentStatusId);
        trackingSteps.add(
          TrackingStep(
            title: statusName,
            isCompleted: isCompleted,
            icon: statusIcons[statusName] ?? Icons.circle_outlined,
          ),
        );
      }
      if (trackingSteps.length < 5) {
        if (currentStatusId == '4' && trackingSteps.length < 5) {
          trackingSteps.add(
            TrackingStep(
              title: 'To Review',
              isCompleted: false,
              icon: Icons.rate_review_outlined,
            ),
          );
        }
        while (trackingSteps.length < 5) {
          trackingSteps.add(
            TrackingStep(
              title: 'Future Step',
              isCompleted: false,
              icon: Icons.circle_outlined,
            ),
          );
        }
      }

      if (trackingSteps.length > 5) {
        trackingSteps = trackingSteps.sublist(0, 5);
      }
    } else {
      trackingSteps = [
        TrackingStep(
          title: 'To Pay',
          isCompleted: true,
          icon: Icons.receipt_outlined,
        ),
        TrackingStep(
          title: 'Confirmed',
          isCompleted: true,
          icon: Icons.inventory_2_outlined,
        ),
        TrackingStep(
          title: 'Shipping',
          isCompleted: true,
          icon: Icons.local_shipping_outlined,
        ),
        TrackingStep(
          title: 'Delivered',
          isCompleted: true,
          icon: Icons.delivery_dining_outlined,
        ),
        TrackingStep(
          title: 'To Review',
          isCompleted: false,
          icon: Icons.rate_review_outlined,
        ),
      ];
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFCA48),
        elevation: 0,
        centerTitle: true,
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
        title: const Text(
          'Order Detail',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: orderProvider.orderDetails.state == AsyncValueState.loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFCA48)))
          : orderDetail == null
              ? const Center(child: Text('No order details found'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Tracking Section
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.local_shipping_outlined,
                                  color: const Color(0xFFFFCA48),
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Tracking Your Order',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Tracking Steps
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:
                                  List.generate(trackingSteps.length, (index) {
                                final step = trackingSteps[index];
                                return Expanded(
                                  child: Column(
                                    children: [
                                      // Circle with icon
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: step.isCompleted
                                              ? const Color(0xFFFFCA48)
                                              : Colors.grey[300],
                                        ),
                                        child: Icon(
                                          step.icon,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        step.title,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: step.isCompleted
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: step.isCompleted
                                              ? Colors.black87
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                            // Connecting lines between circles
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Row(
                                children: List.generate(
                                    trackingSteps.length - 1, (index) {
                                  return Expanded(
                                    child: Container(
                                      height: 2,
                                      color:
                                          trackingSteps[index + 1].isCompleted
                                              ? const Color(0xFFF5D248)
                                              : Colors.grey[300],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                      if (orderDetail.deliveryAddress != null)
                        // Delivery Address Section
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Color(0xFFFFCA48),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Delivery Address',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.home,
                                      color: Color(0xFFFFCA48),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      orderDetail.deliveryAddress?.address ??
                                          '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 8),

                      // Items in Order Section
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Color(0xFFFFCA48),
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Item Your Order',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${orderDetail.count ?? 0})',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Product Items
                            if (orderDetail.product != null)
                              for (int index = 0;
                                  index < orderDetail.count!;
                                  index++)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              orderDetail
                                                      .product?[index].photo ??
                                                  '',
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  width: 100,
                                                  height: 100,
                                                  color: Colors.grey[300],
                                                  child: Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.grey[600]),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  orderDetail.product?[index]
                                                          .productNameEn ??
                                                      'Product Name',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Quantity : ${orderDetail.product?[index].qty ?? ''}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Review : ${orderDetail.product?[index].isReviewed ?? 'Not reviewed'}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    if (orderDetail
                                                            .processStatus
                                                            ?.toLowerCase() ==
                                                        "to review")
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          _showReviewDialog(
                                                            context,
                                                            orderDetail
                                                                    .product?[
                                                                        index]
                                                                    .productId ??
                                                                '',
                                                          );
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFFFFCA48),
                                                          foregroundColor:
                                                              Colors.white,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 12,
                                                            vertical: 8,
                                                          ),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                          ),
                                                          elevation: 2,
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: const [
                                                            Icon(
                                                              Icons
                                                                  .star_outline,
                                                              size: 16,
                                                            ),
                                                            SizedBox(width: 4),
                                                            Text(
                                                              'Add Review',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Price : \$${orderDetail.product?[index].unitPrice ?? '0.00'}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFFF5D248),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Order Summary Section
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.receipt_outlined,
                                  color: Color(0xFFFFCA48),
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Order Summary',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Payment details
                            PaymentRowItem(
                              title: 'Subtotal',
                              amount: _calculateSubtotal(orderDetail),
                            ),
                            PaymentRowItem(
                              title: 'Delivery Fee',
                              amount: orderDetail.deliveryFee ?? '0.00',
                            ),

                            PaymentRowItem(
                              title: 'Packaging',
                              amount: orderDetail.packaging ?? '0.00',
                            ),

                            PaymentRowItem(
                              title: 'Tax',
                              amount: orderDetail.tax ?? '0.00',
                            ),

                            PaymentRowItem(
                              title: 'Discount',
                              amount: orderDetail.discountAmount ?? '0.00',
                            ),

                            Text(
                              orderDetail.method ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(thickness: 1),
                            PaymentRowItem(
                              title: 'Total',
                              amount:
                              _calculateSubtotal(orderDetail),
                              isTotal: true,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
    );
  }

  String _calculateSubtotal(dynamic orderDetail) {
    final products = orderDetail.product;
    if (products == null) return '0.00';

    double subtotal = 0;
    for (var product in products) {
      double price = double.tryParse(product.unitPrice ?? '0') ?? 0;
      int qty = int.tryParse(product.qty ?? '1') ?? 1;
      subtotal += price * qty;
    }
    return subtotal.toStringAsFixed(2);
  }

  void _showReviewDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProductReviewDialog(
          productId: productId,
          onSubmit: (rating, comment) async {
            // Call the API to submit the review
            final orderProvider = context.read<OrderProvider>();
            await orderProvider.reviewOrder(
                widget.orderId, productId, rating.toString(), comment);

            // Show success message
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Review submitted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            }

            // Refresh order details to update the review status
            orderProvider.getOrderDetails(widget.orderId);
          },
        );
      },
    );
  }
}

class PaymentRowItem extends StatelessWidget {
  final String title;
  final String amount;
  final bool isTotal;

  const PaymentRowItem({
    super.key,
    required this.title,
    required this.amount,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 24 : 14,
              color: isTotal ? Colors.black87 : Colors.grey,
            ),
          ),
          Text(
            '\$$amount',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 24 : 14,
              color: isTotal ? const Color(0xFFF5D248) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
