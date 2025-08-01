// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/provider/checkout_provider.dart';
import 'package:provider/provider.dart';

class PaymentSection extends StatelessWidget {
  final String selectedPaymentMethod;
  final Function(String) onPaymentMethodChanged;

  const PaymentSection({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final checkoutProvider = Provider.of<CheckoutProvider>(context);
    final paymentMethods = checkoutProvider.paymentMethods;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  Icon(Icons.payment, color: const Color(0xFFF5D248), size: 24),
            ),
            SizedBox(width: 12),
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
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
          child: Column(
            children: [
              if (paymentMethods.state == AsyncValueState.loading)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (paymentMethods.state == AsyncValueState.error)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Failed to load payment methods: ${paymentMethods.error}'),
                )
              else if (paymentMethods.state == AsyncValueState.success &&
                  paymentMethods.data != null &&
                  paymentMethods.data!.isNotEmpty)
                ...paymentMethods.data!.map((method) {
                  final isSelected = method.id == selectedPaymentMethod;
                  final isQRPayment = isQRCodePayment(method.method);

                  return Container(
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFF5D248)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                      color:
                          isSelected ? const Color(0xFFFFF9E6) : Colors.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Radio(
                                value: method.id ?? '',
                                groupValue: selectedPaymentMethod,
                                activeColor: const Color(0xFFF5D248),
                                onChanged: (value) {
                                  print(
                                      "DEBUG: Payment method selected: ${method.method} (ID: ${value})");
                                  onPaymentMethodChanged(value.toString());
                                },
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      method.method ?? 'Unknown Method',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    if (isQRPayment)
                                      Text(
                                        'Scan QR code to pay',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: method.photo != null
                                    ? Image.network(
                                        method.photo!,
                                        width: 60,
                                        height: 40,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return isQRPayment
                                              ? Icon(Icons.qr_code,
                                                  size: 24,
                                                  color:
                                                      const Color(0xFFF5D248))
                                              : Icon(Icons.payment, size: 24);
                                        },
                                      )
                                    : isQRPayment
                                        ? Icon(Icons.qr_code,
                                            size: 24,
                                            color: const Color(0xFFF5D248))
                                        : Icon(Icons.payment, size: 24),
                              ),
                            ],
                          ),
                        ),
                        if (method.description != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 48.0, right: 16.0, bottom: 8.0),
                            child: Text(
                              method.description!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                })
              else
                Text('No payment methods available'),
            ],
          ),
        ),
      ],
    );
  }

  bool isQRCodePayment(String? methodName) {
    if (methodName == null) return false;
    final name = methodName.toLowerCase();
    return name.contains('qr') ||
        name.contains('scan') ||
        name.contains('khqr');
  }
}
