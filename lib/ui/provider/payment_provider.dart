import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/data/repository/payment_method_repository.dart';
import 'package:palm_ecommerce_app/models/checkout/checkout.dart';
import 'package:palm_ecommerce_app/models/waiting_payment.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentMethodRepository paymentMethodRepository;
  PaymentProvider({required this.paymentMethodRepository});
  AsyncValue<WaitingPayment> _waitingForPayment = AsyncValue.loading();
  AsyncValue<CheckoutABAModel> _khqrDeeplink = AsyncValue.loading();
  AsyncValue<CheckTransactionModel> _checkTransaction = AsyncValue.loading();
  AsyncValue<WaitingPayment> get waitingForPayment => _waitingForPayment;
  AsyncValue<CheckoutABAModel> get khqrDeeplink => _khqrDeeplink;
  AsyncValue<CheckTransactionModel> get checkTransaction => _checkTransaction;

  // Track if direct payment has been attempted
  bool _directPaymentAttempted = false;
  bool get directPaymentAttempted => _directPaymentAttempted;

  // Reset the direct payment flag
  void resetDirectPaymentFlag() {
    _directPaymentAttempted = false;
    notifyListeners();
  }

  // Process direct payment flow
  Future<bool> processDirectPayment(String orderId) async {
    try {
      _directPaymentAttempted = true;
      notifyListeners();
      // Get KHQR deeplink
      await getKhqrDeeplink(orderId);
      // Check if we have a valid deeplink
      if (_khqrDeeplink.state == AsyncValueState.success &&
          _khqrDeeplink.data != null &&
          _khqrDeeplink.data?.abapayDeeplink != null &&
          _khqrDeeplink.data!.abapayDeeplink!.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error in processDirectPayment: $e');
      return false;
    }
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

  Future<void> getKhqrDeeplink(String orderId) async {
    _khqrDeeplink = AsyncValue.loading();
    notifyListeners();
    try {
      if (orderId.isEmpty) {
        throw Exception('Order ID is required');
      }
      final khqrDeeplink =
          await paymentMethodRepository.getKhqrDeeplink(orderId: orderId);
      // Validate that we have a valid QR string
      if (khqrDeeplink.qrString == null || khqrDeeplink.qrString!.isEmpty) {
        throw Exception('QR code data is missing or invalid');
      }
      _khqrDeeplink = AsyncValue.success(khqrDeeplink);
    } catch (e) {
      print('Error getting KHQR deeplink: $e');
      _khqrDeeplink = AsyncValue.error(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> checkTransactionStatus(String orderId) async {
    _checkTransaction = AsyncValue.loading();
    notifyListeners();
    try {
      final checkTransaction =
          await paymentMethodRepository.checkTransaction(orderId: orderId);
      _checkTransaction = AsyncValue.success(checkTransaction);
    } catch (e) {
      _checkTransaction = AsyncValue.error(e.toString());
      print('Error checking transaction status: $e');
    } finally {
      notifyListeners();
    }
  }
}
