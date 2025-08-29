// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/models/params/checkout_params.dart';
import 'package:palm_ecommerce_app/ui/provider/address_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/provider/bakong_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/cart_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/checkout_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/payment_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/checkout/payment_widget/bakong_kh_qr.dart';
import 'package:palm_ecommerce_app/ui/screens/checkout/widget/delivery_address.dart';
import 'package:palm_ecommerce_app/ui/screens/checkout/widget/checkout_success.dart';
import 'package:palm_ecommerce_app/ui/screens/checkout/widget/payment_section.dart';
import 'package:palm_ecommerce_app/util/themes.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_app/models/checkout/checkout.dart';
import 'package:palm_ecommerce_app/l10n/app_localizations.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key});
  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> with TickerProviderStateMixin {
  Future<void> processCheckout(BuildContext context) async {
    final checkoutProvider =
        Provider.of<CheckoutProvider>(context, listen: false);
    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);
    final bakongProvider = Provider.of<BakongProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    try {
      final checkoutParams = CheckoutParams(
        addressId: selectedCheckOut == 'Pick Up'
            ? ''
            : Provider.of<AddressProvider>(context, listen: false)
                .addresses
                .data
                ?.first
                .id
                .toString(),
        paymentMethod: selectedPaymentMethod,
        branchId: 'PALM-00060001',
        isBuyNow: '0',
        isRecheckOut: '0',
        isPickUp: selectedCheckOut == 'Pick Up' ? '1' : '0',
      );
      await checkoutProvider.checkout(checkoutParams: checkoutParams);
      await cartProvider.clearCart();
      // Process QR code payment if needed
      if (isQRCodePayment(selectedPaymentMethod)) {
        try {
          bakongProvider.paymentVerification;
          await paymentProvider.getWaitingForPayment();
          final waitingPayment = paymentProvider.waitingForPayment;
          if (waitingPayment.state == AsyncValueState.success &&
              waitingPayment.data != null &&
              waitingPayment.data?.bookingId != null) {
            double amount = 0.0;
            if (checkoutProvider.checkoutInfo.data?.grandTotal != null) {
              if (selectedCheckOut == 'Pick Up') {
                // For pickup, calculate amount without delivery fee
                final subtotal = double.tryParse(checkoutProvider
                            .checkoutInfo.data!.totalPriceOfterDiscount
                            ?.replaceAll(',', '') ??
                        '0') ??
                    0.0;
                final taxAmount = double.tryParse(checkoutProvider
                            .checkoutInfo.data!.taxAmount
                            ?.replaceAll(',', '') ??
                        '0') ??
                    0.0;
                amount = subtotal + taxAmount;
              } else {
                // For delivery, use the full grand total
                amount = double.tryParse(checkoutProvider
                        .checkoutInfo.data!.grandTotal!
                        .replaceAll(',', '')) ??
                    0.0;
              }
            }
            if (amount <= 0) {
              amount = 1.0;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KHQRScreen(
                  bookingId: waitingPayment.data?.bookingId,
                  amount: amount,
                ),
              ),
            );
            return;
          } else {
            throw Exception(
                "Could not get payment information. Please try again.");
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(
                          'QR payment setup failed. Your order was placed but you may need to pay using another method.')),
                ],
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(10),
              duration: Duration(seconds: 5),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutSuccessScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Error: ${e.toString()}')),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  bool isQRCodePayment(String paymentMethodId) {
    final checkoutProvider =
        Provider.of<CheckoutProvider>(context, listen: false);
    final paymentMethods = checkoutProvider.paymentMethods;

    if (paymentMethods.state == AsyncValueState.success &&
        paymentMethods.data != null) {
      final selectedMethod = paymentMethods.data!.firstWhere(
        (method) => method.id == paymentMethodId,
        orElse: () => PaymentMethodModel(),
      );

      return selectedMethod.method != null &&
          (selectedMethod.method!.toLowerCase().contains('qr') ||
              selectedMethod.method!.toLowerCase().contains('khqr') ||
              selectedMethod.method!.toLowerCase().contains('bakong') ||
              selectedMethod.method!.toLowerCase().contains('scan'));
    }
    return false;
  }

  bool isLoading = false;
  String selectedPaymentMethod = '';
  String selectedCheckOut = 'Delivery';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddressProvider>(context, listen: false).fetchAddresses();
      Provider.of<CheckoutProvider>(context, listen: false).getPaymentMethods();
      Provider.of<CheckoutProvider>(context, listen: false)
          .getCheckoutInfo(isPickUp: selectedCheckOut == 'Pick Up');
    });
  }

  @override
  Widget build(BuildContext context) {
    final checkoutProvider = Provider.of<CheckoutProvider>(context);
    final checkoutInfo = checkoutProvider.checkoutInfo;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Color(0xFFFFCA48),
          elevation: 0,
          centerTitle: true,
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
          title: Text(AppLocalizations.of(context)!.checkout,
              style: TextStyle(
                  color: whiteColor,
                  fontSize: 24,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      body: Stack(
        children: [
          isLoading
              ? SizedBox.shrink()
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Address Card
                        selectedCheckOut == 'Delivery'
                            ? DeliveryAddress()
                            : Container(),
                        SizedBox(height: 16),
                        // Delivery Method
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Pick Up Option
                              Row(
                                children: [
                                  Radio(
                                    value: 'Pick Up',
                                    groupValue: selectedCheckOut,
                                    activeColor: const Color(0xFFF5D248),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCheckOut = value.toString();
                                      });
                                      Provider.of<CheckoutProvider>(context,
                                              listen: false)
                                          .getCheckoutInfo(isPickUp: true);
                                    },
                                  ),
                                  Text(
                                    'Pick Up',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5D248)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.shopping_bag_outlined,
                                        color: const Color(0xFFF5D248),
                                        size: 24),
                                  ),
                                ],
                              ),
                              // Delivery Option
                              Row(
                                children: [
                                  Radio(
                                    value: 'Delivery',
                                    groupValue: selectedCheckOut,
                                    activeColor: const Color(0xFFF5D248),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCheckOut = value.toString();
                                      });
                                      Provider.of<CheckoutProvider>(context,
                                              listen: false)
                                          .getCheckoutInfo(isPickUp: false);
                                    },
                                  ),
                                  Text(
                                    'Delivery',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5D248)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.delivery_dining,
                                        color: const Color(0xFFF5D248),
                                        size: 24),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Payment Method Section
                        PaymentSection(
                          selectedPaymentMethod: selectedPaymentMethod,
                          onPaymentMethodChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        // Order Items Section
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5D248)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.shopping_cart,
                                        color: const Color(0xFFF5D248),
                                        size: 24),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Items in Your Order',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Column(
                                children: [
                                  for (int index = 0;
                                      index <
                                          (checkoutInfo.data?.product?.length ??
                                              0);
                                      index++)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              checkoutInfo.data?.product?[index]
                                                      .photo ??
                                                  '',
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  width: 80,
                                                  height: 80,
                                                  color: Colors.grey[300],
                                                  child: Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.grey[600]),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  checkoutInfo
                                                          .data
                                                          ?.product?[index]
                                                          .productNameEn ??
                                                      '',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  checkoutInfo
                                                          .data
                                                          ?.product?[index]
                                                          .description ??
                                                      '',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '\$${(double.tryParse(checkoutInfo.data?.product?[index].price ?? '0.00') ?? 0.0) * (double.tryParse(checkoutInfo.data?.product?[index].qty ?? '0') ?? 0.0)}',
                                                      style: TextStyle(
                                                        color: const Color(
                                                            0xFFF5D248),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Quantity : ${checkoutInfo.data?.product?[index].qty ?? '0'}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        // Summary Payment Section
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5D248)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.receipt,
                                        color: const Color(0xFFF5D248),
                                        size: 24),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Summary payment',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 16),
                              // Summary Details
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sub Total',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '\$${checkoutInfo.data?.totalPriceOfterDiscount ?? "0.00"}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery Fee',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    selectedCheckOut == 'Delivery'
                                        ? '\$${checkoutInfo.data?.deliveryFee ?? "0.00"}'
                                        : '\$0.00',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tax',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '\$${checkoutInfo.data?.taxAmount ?? "Tax Included"}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Divider(),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    selectedCheckOut == 'Pick Up'
                                        ? '\$${((double.tryParse(checkoutInfo.data?.grandTotal?.replaceAll(',', '') ?? '0') ?? 0.0) - (double.tryParse(checkoutInfo.data?.deliveryFee?.replaceAll(',', '') ?? '0') ?? 0.0)).toStringAsFixed(2)}'
                                        : '\$${((double.tryParse(checkoutInfo.data?.grandTotal?.replaceAll(',', '') ?? '0') ?? 0.0))}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: const Color(0xFFF5D248),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
      bottomNavigationBar: isLoading
          ? null
          : Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        selectedCheckOut == 'Pick Up' &&
                                checkoutInfo.data?.grandTotal != null &&
                                checkoutInfo.data?.deliveryFee != null
                            ? '\$${((double.tryParse(checkoutInfo.data?.grandTotal?.replaceAll(',', '') ?? '0') ?? 0.0) - (double.tryParse(checkoutInfo.data?.deliveryFee?.replaceAll(',', '') ?? '0') ?? 0.0)).toStringAsFixed(2)}'
                            : '\$${((double.tryParse(checkoutInfo.data?.grandTotal?.replaceAll(',', '') ?? '0') ?? 0.0))}',
                        style: TextStyle(
                          color: const Color(0xFFF5D248),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedPaymentMethod.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.white),
                                SizedBox(width: 10),
                                Text('Please select a payment method'),
                              ],
                            ),
                            backgroundColor: Colors.amber.shade800,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.all(10),
                          ),
                        );
                        return;
                      }
                      processCheckout(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5D248),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Order Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.shopping_cart_checkout, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
