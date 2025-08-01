import 'package:flutter/widgets.dart';
import 'package:palm_ecommerce_app/data/repository/checkout_repository.dart';
import 'package:palm_ecommerce_app/models/checkout/checkout.dart';
import 'package:palm_ecommerce_app/models/delivery.dart';
import 'package:palm_ecommerce_app/models/params/checkout_params.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';

class CheckoutProvider extends ChangeNotifier {
  final CheckoutRepository checkoutRepository;
  CheckoutProvider({required this.checkoutRepository});

  AsyncValue<CheckoutModel> _checkoutInfo = AsyncValue.empty();
  AsyncValue<List<PaymentMethodModel>> _paymentMethods = AsyncValue.empty();
  AsyncValue<List<DeliveryAddressModel>> _shippingAddresses =
      AsyncValue.empty();
  List<PaymentMethodModel> _paymentMethodsList = [];

  AsyncValue<CheckoutModel> get checkoutInfo => _checkoutInfo;
  AsyncValue<List<PaymentMethodModel>> get paymentMethods => _paymentMethods;
  AsyncValue<List<DeliveryAddressModel>> get shippingAddresses =>
      _shippingAddresses;
  Future<void> getCheckoutInfo({bool? isPickUp}) async {
    try {
      _checkoutInfo = AsyncValue.loading();
      final checkoutInfo = await checkoutRepository.getCheckoutInfo(
        isPickUp: isPickUp,
      );
      _checkoutInfo = AsyncValue.success(checkoutInfo);
      notifyListeners();
    } catch (error) {
      _checkoutInfo = AsyncValue.error(error);
      notifyListeners();
    }
  }

  Future<void> getPaymentMethods() async {
    try {
      _paymentMethods = AsyncValue.loading();
      notifyListeners();
      final paymentMethods = await checkoutRepository.getPaymentMethods();
      _paymentMethodsList = paymentMethods;
      _paymentMethods = AsyncValue.success(_paymentMethodsList);
      notifyListeners();
    } catch (error) {
      _paymentMethods = AsyncValue.error(error);
      notifyListeners();
    }
  }

  Future<void> checkout({
    required CheckoutParams checkoutParams,
  }) async {
    try {
      _shippingAddresses = AsyncValue.loading();
      notifyListeners();
      await checkoutRepository.checkout(
        checkoutParams: checkoutParams,
      );
      notifyListeners();
    } catch (error) {
      _shippingAddresses = AsyncValue.error(error);
      notifyListeners();
    }
  }
}
