// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
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
        title: Text(AppLocalizations.of(context)?.orders ?? 'My Orders',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
        actions: [
          IconButton(
            onPressed: () {
              orderProvider.refreshOrderStatus().then((_) {
                if (orderProvider.orderStatus.data?.isNotEmpty ?? false) {
                  final firstStatus = orderProvider.orderStatus.data!.first;
                  orderProvider.getOrders(firstStatus.statusProcessId ?? '');
                }
              });
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
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
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
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
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 8),
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              final order = orders[index];

                              return FoodWidget(
                                orderId: order.bookingId ?? '',
                                orderPhoto: order.orderphoto,
                                price: order.isPickUp == '1'
                                    ? (double.tryParse(order.grandTotal ?? '0') ?? 0) - 2
                                    : (double.tryParse(order.grandTotal ?? '0') ?? 0),
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
