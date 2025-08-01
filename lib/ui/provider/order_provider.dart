import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/data/repository/order_repository.dart';
import 'package:palm_ecommerce_app/models/order/order.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository orderRepository;
  AsyncValue<List<OrderModel>> _orders = AsyncValue.empty();
  AsyncValue<OrderDetailModel?> _orderDetails = AsyncValue.empty();
  AsyncValue<List<TrackingStatusModel>> _orderStatus = AsyncValue.empty();
  List<TrackingStatusModel> _cachedOrderStatus = [];
  List<OrderModel> _cachedOrders = [];
  String _selectedStatusId = '';
  bool _hasLoadedOrderStatus = false;

  AsyncValue<void> _cancelOrderStatus = AsyncValue.empty();
  AsyncValue<void> get cancelOrderStatus => _cancelOrderStatus;
  OrderProvider({required this.orderRepository});
  AsyncValue<List<OrderModel>> get orders => _orders;
  AsyncValue<OrderDetailModel?> get orderDetails => _orderDetails;
  AsyncValue<List<TrackingStatusModel>> get orderStatus => _orderStatus;
  String get selectedStatusId => _selectedStatusId;
  bool get hasLoadedOrderStatus => _hasLoadedOrderStatus;

  void selectStatus(String statusId) {
    _selectedStatusId = statusId;
    getOrders(statusId);
    notifyListeners();
  }

  // Method to notify listeners when order status is updated manually
  void notifyOrderStatusUpdated() {
    // Update the cached orders with the modified data
    if (_orders.data != null) {
      _cachedOrders = _orders.data!;
    }
    // Notify listeners to refresh UI
    notifyListeners();
  }

  Future<void> getOrders(String processStatusId) async {
    _orders = AsyncValue.loading();
    notifyListeners();
    try {
      if (processStatusId.isNotEmpty) {
        _selectedStatusId = processStatusId;
      }
      final orders = await orderRepository.getOrders(processStatusId);
      _cachedOrders = orders;
      _orders = AsyncValue.success(_cachedOrders);
      notifyListeners();
    } catch (e) {
      print('DEBUG: Provider - Error in getOrders: $e');
      _orders = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> getOrderDetails(String orderId) async {
    _orderDetails = AsyncValue.loading();
    notifyListeners();
    try {
      final orderDetails = await orderRepository.getOrderDetails(orderId);
      _orderDetails = AsyncValue.success(orderDetails);
      notifyListeners();
    } catch (e) {
      _orderDetails = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> getOrderStatus() async {
    if (_hasLoadedOrderStatus && _cachedOrderStatus.isNotEmpty) {
      _orderStatus = AsyncValue.success(_cachedOrderStatus);
      notifyListeners();
      return;
    }
    _orderStatus = AsyncValue.loading();
    notifyListeners();
    try {
      final orderStatus = await orderRepository.getOrderStatus();
      _cachedOrderStatus = orderStatus;
      _orderStatus = AsyncValue.success(_cachedOrderStatus);
      _hasLoadedOrderStatus = true;
      notifyListeners();
    } catch (e) {
      _orderStatus = AsyncValue.error(e);
      notifyListeners();
    }
  }

  // Method to force refresh order status if needed
  Future<void> refreshOrderStatus() async {
    _hasLoadedOrderStatus = false;
    await getOrderStatus();
  }

  Future<void> cancelOrder(String orderId) async {
    _cancelOrderStatus = AsyncValue.loading();
    notifyListeners();
    try {
      print('DEBUG: Provider - Canceling order: $orderId');
      await orderRepository.cancelOrder(orderId);

      // Update local cached orders by removing the canceled order
      _cachedOrders.removeWhere((order) => order.bookingId == orderId);
      _orders = AsyncValue.success(_cachedOrders);
      _cancelOrderStatus = AsyncValue.success(null);
    } catch (e) {
      print('DEBUG: Provider - Error in cancelOrder: $e');
      _cancelOrderStatus = AsyncValue.error(e);
    }
    notifyListeners();
  }
  Future<void> reviewOrder(String orderId, String productId, String rating, String comment) async {
    try {
      await orderRepository.reviewOrder(orderId, productId, rating, comment);
    } catch (e) {
      print('DEBUG: Provider - Error in reviewOrder: $e');
    }
    notifyListeners();
  }
}
