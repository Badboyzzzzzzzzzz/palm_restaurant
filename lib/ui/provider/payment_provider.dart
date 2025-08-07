import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/data/repository/payment_method_repository.dart';
import 'package:palm_ecommerce_app/models/waiting_payment.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
class PaymentProvider extends ChangeNotifier {
  final PaymentMethodRepository paymentMethodRepository;
  PaymentProvider({required this.paymentMethodRepository});
  AsyncValue<WaitingPayment> _waitingForPayment = AsyncValue.loading();
  AsyncValue<WaitingPayment> get waitingForPayment => _waitingForPayment;

  // Track if direct payment has been attempted
  bool _directPaymentAttempted = false;
  bool get directPaymentAttempted => _directPaymentAttempted;

  // Reset the direct payment flag
  void resetDirectPaymentFlag() {
    _directPaymentAttempted = false;
    notifyListeners();
  }
  Future<void> getWaitingForPayment() async {
    _waitingForPayment = AsyncValue.loading();
    notifyListeners();
    try {
      final waitingForPayment =
          await paymentMethodRepository.waitingForPayment();
      _waitingForPayment = AsyncValue.success(waitingForPayment);
    } catch (e) {
      _waitingForPayment = AsyncValue.error(e.toString());
      print('Error getting waiting for payment: $e');
    } finally {
      notifyListeners();
    }
  }
}
