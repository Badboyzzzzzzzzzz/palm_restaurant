import 'package:palm_ecommerce_app/models/checkout/checkout.dart';
import 'package:palm_ecommerce_app/models/waiting_payment.dart';

abstract class PaymentMethodRepository {
  Future<WaitingPayment>  waitingForPayment();
  Future<CheckoutABAModel> getKhqrDeeplink({required String orderId});
  Future<CheckTransactionModel> checkTransaction({required String orderId});
}
