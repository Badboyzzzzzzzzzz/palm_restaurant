// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_app/ui/provider/order_provider.dart';
import 'package:palm_ecommerce_app/util/themes.dart';
import 'package:palm_ecommerce_app/ui/screens/order/widget/food_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/l10n/app_localizations.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  bool _isTabControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = context.read<OrderProvider>();

      orderProvider.getOrderStatus().then((_) {
        if (orderProvider.orderStatus.data?.isNotEmpty ?? false) {
          final statusId = orderProvider.selectedStatusId.isNotEmpty
              ? orderProvider.selectedStatusId
              : orderProvider.orderStatus.data!.first.statusProcessId ?? '';
          if (orderProvider.orders.data == null ||
              orderProvider.orders.data!.isEmpty ||
              orderProvider.selectedStatusId != statusId) {
            orderProvider.getOrders(statusId);
          }
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final orderProvider = context.watch<OrderProvider>();
    if (orderProvider.orderStatus.state == AsyncValueState.success &&
        !_isTabControllerInitialized) {
      final statuses = orderProvider.orderStatus.data ?? [];
      if (statuses.isNotEmpty) {
        _tabController = TabController(
          length: statuses.length,
          vsync: this,
        );
        int initialIndex = 0;
        if (orderProvider.selectedStatusId.isNotEmpty) {
          for (int i = 0; i < statuses.length; i++) {
            if (statuses[i].statusProcessId == orderProvider.selectedStatusId) {
              initialIndex = i;
              break;
            }
          }
        }
        _tabController.index = initialIndex;
        _currentTabIndex = initialIndex;
        _tabController.addListener(() {
          if (!_tabController.indexIsChanging) {
            setState(() {
              _currentTabIndex = _tabController.index;
            });
            final selectedStatus = statuses[_tabController.index];
            orderProvider.selectStatus(selectedStatus.statusProcessId ?? '');
          }
        });

        _isTabControllerInitialized = true;
      }
    }
  }

  @override
  void dispose() {
    if (_isTabControllerInitialized) {
      _tabController.dispose();
    }
    super.dispose();
  }

  void _onTabSelected(int index) {
    final orderProvider = context.read<OrderProvider>();
    final statuses = orderProvider.orderStatus.data ?? [];
    if (index < statuses.length) {
      setState(() {
        _currentTabIndex = index;
      });
      if (_isTabControllerInitialized) {
        _tabController.animateTo(index);
      }
      final selectedStatusId = statuses[index].statusProcessId ?? '';
      orderProvider.selectStatus(selectedStatusId);
    }
  }

  Future<void> _refreshOrders() async {
    try {
      // Add haptic feedback for modern feel
      HapticFeedback.lightImpact();

      final orderProvider = context.read<OrderProvider>();

      // Refresh order status first
      await orderProvider.getOrderStatus();

      // Get current selected status or use first status
      if (orderProvider.orderStatus.data?.isNotEmpty ?? false) {
        final statusId = orderProvider.selectedStatusId.isNotEmpty
            ? orderProvider.selectedStatusId
            : orderProvider.orderStatus.data!.first.statusProcessId ?? '';

        // Refresh orders for current status
        await orderProvider.getOrders(statusId);
      }

      // Success haptic feedback
      HapticFeedback.selectionClick();
    } catch (e) {
      // Error haptic feedback
      HapticFeedback.heavyImpact();

      // Handle error silently or show a snackbar
      debugPrint('Error refreshing orders: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text('Failed to refresh orders'),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final orders = orderProvider.orders.data ?? [];
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: primaryBackgroundColor,
        title: Text(
          AppLocalizations.of(context)?.orders ?? 'My Orders',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (orderProvider.orderStatus.state == AsyncValueState.loading)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 30.0,
                ),
              )
            else if (orderProvider.orderStatus.data?.isNotEmpty ?? false)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: orderProvider.orderStatus.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final status = orderProvider.orderStatus.data![index];
                    return _buildTab(
                      status.statusProcessEn ?? '',
                      _currentTabIndex == index,
                      onTap: () => _onTabSelected(index),
                    );
                  },
                ),
              ),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: orderProvider.orders.state == AsyncValueState.loading
                    ? Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: primaryBackgroundColor,
                          size: 45.00,
                        ),
                      )
                    : orders.isEmpty
                        ? RefreshIndicator(
                            onRefresh: _refreshOrders,
                            color: primaryBackgroundColor,
                            backgroundColor: Colors.white,
                            strokeWidth: 3.0,
                            displacement: 50.0,
                            edgeOffset: 20.0,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.receipt_long_outlined,
                                        size: 70,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No orders found',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No orders for this status yet',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        'Pull down to refresh',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade400,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _refreshOrders,
                            color: primaryBackgroundColor,
                            backgroundColor: Colors.white,
                            strokeWidth: 3.0,
                            displacement: 50.0,
                            edgeOffset: 20.0,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 8),
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              itemCount: orders.length,
                              itemBuilder: (context, index) {
                                final order = orders[index];

                                return FoodWidget(
                                  orderId: order.bookingId ?? '',
                                  orderPhoto: order.orderphoto,
                                  price: order.isPickUp == '1'
                                      ? (double.tryParse(
                                                  order.grandTotal ?? '0') ??
                                              0) -
                                          2
                                      : (double.tryParse(
                                              order.grandTotal ?? '0') ??
                                          0),
                                  deliveryStatus: order.isPickUp == '1'
                                      ? 'Pickup'
                                      : 'Delivery',
                                  orderStatus:
                                      order.processStatus ?? 'Processing',
                                  date: order.bookingDate ?? '',
                                  itemCount: order.orderphoto.length,
                                  onCancelPressed: () {
                                    orderProvider
                                        .cancelOrder(order.bookingId ?? '');
                                  },
                                );
                              },
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected, {required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: primaryBackgroundColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              text,
              style: TextStyle(
                color: isSelected ? primaryBackgroundColor : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
