import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/data/repository/bakong_repository.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';

class BakongProvider extends ChangeNotifier {
  final BakongRepository bakongRepository;

  BakongProvider({required this.bakongRepository});

  // Payment verification state
  AsyncValue<bool> _paymentVerification = AsyncValue.empty();
  AsyncValue<bool> get paymentVerification => _paymentVerification;

  // Order status update state
  AsyncValue<bool> _orderStatusUpdate = AsyncValue.empty();
  AsyncValue<bool> get orderStatusUpdate => _orderStatusUpdate;

  // Verification attempts tracking
  int _verificationAttempts = 0;
  int get verificationAttempts => _verificationAttempts;

  // Last error message
  String _lastErrorMessage = '';
  String get lastErrorMessage => _lastErrorMessage;

  // Verify payment using MD5 hash
  Future<void> verifyPayment(String md5) async {
    _paymentVerification = AsyncValue.loading();
    _verificationAttempts++;
    _lastErrorMessage = '';
    notifyListeners();

    try {
      debugPrint('Attempting to verify payment with MD5: $md5');
      final isVerified = await bakongRepository.verifyMd5(md5);
      _paymentVerification = AsyncValue.success(isVerified);
      debugPrint('Payment verification result: $isVerified');
    } catch (e) {
      debugPrint('Payment verification error: $e');
      _lastErrorMessage = e.toString();

      // Create a more specific error message based on the error
      String errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        errorMessage = 'Authentication failed: Invalid or expired token (401)';
      } else if (errorMessage.contains('timeout')) {
        errorMessage = 'Connection timeout: Server is not responding';
      } else if (errorMessage.contains('Connection refused')) {
        errorMessage = 'Connection refused: Unable to reach payment server';
      }

      _paymentVerification = AsyncValue.error(errorMessage);
    } finally {
      notifyListeners();
    }
  }

  // Reset verification attempts
  void resetVerificationAttempts() {
    _verificationAttempts = 0;
    notifyListeners();
  }

  // Reset states
  void resetStates() {
    _paymentVerification = AsyncValue.empty();
    _orderStatusUpdate = AsyncValue.empty();
    _verificationAttempts = 0;
    _lastErrorMessage = '';
    notifyListeners();
  }
}
