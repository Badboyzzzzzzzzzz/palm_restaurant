import 'package:palm_ecommerce_app/models/delivery.dart';

abstract class DeliveryAddressRepository {
  Future<List<DeliveryAddressModel>> getDeliveryAddresses();
  Future<void> addDeliveryAddress(DeliveryAddressModel deliveryAddress);
  Future<void> updateDeliveryAddress(DeliveryAddressModel deliveryAddress);
  Future<void> deleteDeliveryAddress(String id);
}
