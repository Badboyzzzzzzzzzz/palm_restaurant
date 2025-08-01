import 'package:palm_ecommerce_app/models/checkout/checkout.dart';
import 'package:palm_ecommerce_app/models/params/checkout_params.dart';

abstract class CheckoutRepository {
  Future<CheckoutModel> getCheckoutInfo({
    bool? isPickUp,
  });
  Future<List<PaymentMethodModel>> getPaymentMethods();
  Future<void> checkout({
    CheckoutParams checkoutParams,
  });
}
