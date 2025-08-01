import 'package:palm_ecommerce_app/models/order/order.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getOrders(String processStatusId);
  Future<OrderDetailModel?> getOrderDetails(String orderId);
  Future<List<TrackingStatusModel>> getOrderStatus();
  Future<void> cancelOrder(String orderId);
  Future<void> reviewOrder(
      String orderId, String productId, String rating, String comment);
}
