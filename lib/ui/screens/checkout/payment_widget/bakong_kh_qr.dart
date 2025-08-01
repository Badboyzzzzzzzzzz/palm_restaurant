import 'dart:async';
import 'package:flutter/material.dart';
import 'package:khqr_sdk/khqr_sdk.dart';
import 'package:palm_ecommerce_app/ui/provider/bakong_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/screens/checkout/widget/checkout_success.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_app/ui/provider/order_provider.dart';

class BakongPaymentService {
  final BuildContext context;
  final String? bookingId;
  final double? amount;
  final Function(String) onStatusUpdate;
  final Function(bool) onPaymentComplete;

  final _khqrSdk = KhqrSdk();
  String? _qrContent;
  String? _qrMd5;
  bool _isLoading = false;
  Timer? _statusTimer;
  bool _isCheckingStatus = false;
  bool _paymentSuccess = false;
  String _errorMessage = '';
  int _verificationAttempts = 0;
  final int _maxVerificationAttempts = 120;
  String _statusMessage = 'Waiting for payment...';
  BakongPaymentService({
    required this.context,
    this.bookingId,
    this.amount,
    required this.onStatusUpdate,
    required this.onPaymentComplete,
  }) {
    _generateMerchantQR();
  }
  void dispose() {
    _statusTimer?.cancel();
  }

  String? get qrContent => _qrContent;
  bool get isLoading => _isLoading;
  String get statusMessage => _statusMessage;
  bool get isPaymentSuccess => _paymentSuccess;
  String get errorMessage => _errorMessage;

  Future<void> _generateMerchantQR() async {
    _isLoading = true;
    _errorMessage = '';
    _statusMessage = 'Generating QR code...';
    onStatusUpdate(_statusMessage);
    try {
      final expireTime =
          DateTime.now().millisecondsSinceEpoch + 3600000; // 1 hour
      final info = MerchantInfo(
        bakongAccountId: 'socheat_cheng1@aclb',
        acquiringBank: 'ACLEDA Bank',
        merchantId: bookingId ?? 'PALM${DateTime.now().millisecondsSinceEpoch}',
        merchantName: 'Palm Restaurant',
        currency: KhqrCurrency.usd,
        amount: amount ?? 1.0,
        expirationTimestamp: expireTime,
      );
      final khqrData = await _khqrSdk.generateMerchant(info);
      if (khqrData == null) {
        throw Exception('Failed to generate QR code - null response');
      }
      _qrContent = khqrData.qr;
      _qrMd5 = khqrData.md5;
      _isLoading = false;
      _statusMessage = 'Waiting for payment...';
      onStatusUpdate(_statusMessage);
      _startStatusCheckTimer();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to generate QR code: ${e.toString()}';
      onStatusUpdate(_errorMessage);
    }
  }

  void _startStatusCheckTimer() {
    _statusTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      _verificationAttempts++;
      if (_verificationAttempts >= _maxVerificationAttempts) {
        timer.cancel();
        _statusMessage = 'Payment verification timeout. Please try again.';
        onStatusUpdate(_statusMessage);
        return;
      }
      if (_isCheckingStatus) return;
      await _checkPaymentStatus();
    });
  }

  Future<void> _checkPaymentStatus() async {
    if (_qrMd5 == null) return;
    _isCheckingStatus = true;
    _statusMessage = 'Checking payment status...';
    onStatusUpdate(_statusMessage);
    try {
      final bakongProvider =
          Provider.of<BakongProvider>(context, listen: false);
      await bakongProvider.verifyPayment(_qrMd5!);
      final status = bakongProvider.paymentVerification;
      if (status.state == AsyncValueState.success && status.data == true) {
        _statusTimer?.cancel();
        _paymentSuccess = true;
        _statusMessage = 'Payment confirmed!';
        onStatusUpdate(_statusMessage);
        try {
          final orderProvider =
              Provider.of<OrderProvider>(context, listen: false);
          await orderProvider.refreshOrderStatus();
          if (bookingId != null && bookingId!.isNotEmpty) {
            if (orderProvider.orders.data != null) {
              final orders = orderProvider.orders.data!;
              for (int i = 0; i < orders.length; i++) {
                if (orders[i].bookingId == bookingId) {
                  orders[i].processStatusId = "2";
                  orders[i].processStatus = "Confirmed";
                  break;
                }
              }
              orderProvider.notifyOrderStatusUpdated();
            }
          }
        } catch (e) {
          throw Exception(e);
        }
        onPaymentComplete(true);
      } else if (status.state == AsyncValueState.error) {
        String errorMessage = status.error.toString();
        if (errorMessage.contains('401')) {
          _statusMessage = 'Authentication error. Please contact support.';
        } else {
          _statusMessage = 'Waiting for payment...';
        }
        onStatusUpdate(_statusMessage);
      } else {
        _statusMessage = 'Waiting for payment...';
        onStatusUpdate(_statusMessage);
      }
    } catch (e) {
      if (e.toString().contains('401')) {
        _statusMessage = 'Authentication error. Please contact support.';
      } else {
        _statusMessage = 'Error checking payment status. Will retry...';
      }
      onStatusUpdate(_statusMessage);
    } finally {
      _isCheckingStatus = false;
    }
  }

  Future<void> checkPaymentManually() async {
    if (_isCheckingStatus) return;
    await _checkPaymentStatus();
  }

  // Cancel the payment process
  void cancelPayment() {
    _statusTimer?.cancel();
  }
}

// Minimal widget to display QR code and status
class BakongQRWidget extends StatefulWidget {
  final String? bookingId;
  final double? amount;
  final bool showQROnly;
  final Function(bool)? onPaymentComplete;

  const BakongQRWidget({
    super.key,
    this.bookingId,
    this.amount,
    this.showQROnly = false,
    this.onPaymentComplete,
  });

  @override
  State<BakongQRWidget> createState() => _BakongQRWidgetState();
}

class _BakongQRWidgetState extends State<BakongQRWidget> {
  late BakongPaymentService _paymentService;

  @override
  void initState() {
    super.initState();
    _paymentService = BakongPaymentService(
      context: context,
      bookingId: widget.bookingId,
      amount: widget.amount,
      onStatusUpdate: (status) {
        if (mounted) setState(() {});
      },
      onPaymentComplete: (success) {
        if (success && widget.onPaymentComplete != null) {
          widget.onPaymentComplete!(true);
          if (widget.onPaymentComplete == null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const CheckoutSuccessScreen(),
              ),
              (route) => false,
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showQROnly) {
      return _buildQROnlyView();
    } else {
      return _buildFullView();
    }
  }

  Widget _buildQROnlyView() {
    if (_paymentService.isLoading) {
      return Center(
        child: SizedBox(
          width: 300,
          height: 500,
          child: CircularProgressIndicator(
            color: const Color(0xFFF5D248),
          ),
        ),
      );
    } else if (_paymentService.errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          'QR Error: ${_paymentService.errorMessage}',
          style: TextStyle(color: Colors.red),
        ),
      );
    } else if (_paymentService.qrContent != null) {
      return KhqrCardWidget(
        width: 300.0,
        receiverName: 'Palm Restaurant',
        amount: widget.amount ?? 0.0,
        keepIntegerDecimal: false,
        currency: KhqrCurrency.usd,
        qr: _paymentService.qrContent!,
      );
    }
    return SizedBox();
  }

  Widget _buildFullView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildQROnlyView(),
        const SizedBox(height: 16),
        Text(
          _paymentService.statusMessage,
          style: TextStyle(
            color: _paymentService.isPaymentSuccess
                ? Colors.green
                : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class KHQRScreen extends StatefulWidget {
  final String? bookingId;
  final double? amount;
  const KHQRScreen({
    super.key,
    this.bookingId,
    this.amount,
  });
  @override
  State<KHQRScreen> createState() => _KHQRScreenState();
}

class _KHQRScreenState extends State<KHQRScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("KHQR Payment"),
        backgroundColor: const Color(0xFFF5D248),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black87,
                size: 18,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: BakongQRWidget(
                    bookingId: widget.bookingId,
                    amount: widget.amount,
                    onPaymentComplete: (success) {
                      if (success) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckoutSuccessScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
