// // ignore_for_file: deprecated_member_use
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:palm_ecommerce_app/ui/provider/payment_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
// import 'package:palm_ecommerce_app/ui/screens/checkout/widget/checkout_success.dart';
// import 'package:palm_ecommerce_app/ui/provider/checkout_provider.dart';

// class AbaQrCode extends StatefulWidget {
//   final String? bookingId;
//   const AbaQrCode({super.key, this.bookingId});

//   @override
//   State<AbaQrCode> createState() => _AbaQrCodeState();
// }

// class _AbaQrCodeState extends State<AbaQrCode> {
//   Timer? _statusTimer;
//   bool _isCheckingStatus = false;
//   bool _hasError = false;
//   String _errorMessage = '';
//   bool _isWebViewLoaded = false;
//   String? _directQrImageUrl;

//   @override
//   void initState() {
//     super.initState();
//     _loadQrCode();
//   }

//   Future<void> _loadQrCode() async {
//     try {
//       setState(() {
//         _hasError = false;
//         _errorMessage = '';
//         _isWebViewLoaded = false;
//       });
//       final paymentProvider =
//           Provider.of<PaymentProvider>(context, listen: false);
//       if (widget.bookingId == null || widget.bookingId!.isEmpty) {
//         throw Exception('Booking ID is required');
//       }

//       await paymentProvider.getKhqrDeeplink(widget.bookingId!);
//       final khqrData = paymentProvider.khqrDeeplink;

//       if (khqrData.state == AsyncValueState.success && khqrData.data != null) {
//         _startStatusCheckTimer();

//         // Handle QR display
//         if (khqrData.data!.checkoutQrUrl != null &&
//             khqrData.data!.checkoutQrUrl!.isNotEmpty) {
//           setState(() => _isWebViewLoaded = true);
//         } else if (khqrData.data!.qrString != null &&
//             khqrData.data!.qrString!.isNotEmpty) {
//           _generateDirectQrImage(khqrData.data!.qrString!);
//         } else {
//           throw Exception('No QR code data available');
//         }
//       } else if (khqrData.state == AsyncValueState.error) {
//         setState(() {
//           _hasError = true;
//           _errorMessage =
//               khqrData.error?.toString() ?? 'Failed to load QR code';
//         });
//       } else {
//         setState(() {
//           _hasError = true;
//           _errorMessage = 'No QR code data received';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _hasError = true;
//         _errorMessage = 'Error loading QR code: ${e.toString()}';
//       });
//     }
//   }

//   void _generateDirectQrImage(String qrString) {
//     final encodedData = Uri.encodeComponent(qrString);
//     final qrImageUrl =
//         'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=$encodedData';

//     setState(() {
//       _directQrImageUrl = qrImageUrl;
//       _isWebViewLoaded = true;
//     });
//   }

//   void _startStatusCheckTimer() {
//     _statusTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
//       if (!mounted) {
//         timer.cancel();
//         return;
//       }

//       if (_isCheckingStatus) return;

//       setState(() {
//         _isCheckingStatus = true;
//       });

//       try {
//         final paymentProvider =
//             Provider.of<PaymentProvider>(context, listen: false);
//         await paymentProvider.checkTransactionStatus(widget.bookingId!);
//         final status = paymentProvider.checkTransaction;

//         if (status.state == AsyncValueState.success &&
//             status.data != null &&
//             status.data!.paymentStatus?.toLowerCase() == 'success') {
//           // Payment successful
//           timer.cancel();

//           if (mounted) {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => const CheckoutSuccessScreen()),
//               (route) => false,
//             );
//           }
//         }
//       } catch (e) {
//         // Error handling silently
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isCheckingStatus = false;
//           });
//         }
//       }
//     });
//   }

//   Future<void> _retryLoading() async {
//     setState(() {
//       _hasError = false;
//       _errorMessage = '';
//       _isWebViewLoaded = false;
//       _directQrImageUrl = null;
//     });

//     _statusTimer?.cancel();
//     await _loadQrCode();
//   }

//   @override
//   void dispose() {
//     _statusTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final paymentProvider = Provider.of<PaymentProvider>(context);
//     final khqrData = paymentProvider.khqrDeeplink;
//     final checkoutProvider =
//         Provider.of<CheckoutProvider>(context, listen: false);
//     final checkoutInfo = checkoutProvider.checkoutInfo;

//     // Get total amount from checkout info
//     String totalAmount = '';
//     if (checkoutInfo.state == AsyncValueState.success &&
//         checkoutInfo.data != null &&
//         checkoutInfo.data!.grandTotal != null) {
//       totalAmount = checkoutInfo.data!.grandTotal!;
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'Payment Method',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color(0xFFF5D248),
//         elevation: 0,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 4.0),
//           child: IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 5,
//                     spreadRadius: 1,
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Icons.arrow_back_ios_new,
//                 color: Colors.black87,
//                 size: 18,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: khqrData.state == AsyncValueState.loading
//           ? const Center(
//               child: CircularProgressIndicator(color: Color(0xFFF5D248)))
//           : _hasError || khqrData.state == AsyncValueState.error
//               ? _buildErrorState()
//               : _buildQrPaymentScreen(khqrData, totalAmount),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.all(24),
//         margin: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 64, color: Colors.red),
//             const SizedBox(height: 24),
//             Text(
//               _errorMessage.isNotEmpty
//                   ? _errorMessage
//                   : 'Failed to load QR code',
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: _retryLoading,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFF5D248),
//                 foregroundColor: Colors.black,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text(
//                 'Try Again',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQrPaymentScreen(AsyncValue khqrData, String totalAmount) {
//     return Column(
//       children: [
//         Expanded(
//           child: Container(
//             color: const Color(0xFFF5F5F5),
//             child: _isWebViewLoaded
//                 ? _buildQrDisplay(khqrData)
//                 : const Center(
//                     child: CircularProgressIndicator(
//                       color: Color(0xFFF5D248),
//                     ),
//                   ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildQrDisplay(AsyncValue khqrData) {
//     // Direct QR image URL (from our API call)
//     if (_directQrImageUrl != null && _directQrImageUrl!.isNotEmpty) {
//       return Image.network(
//         _directQrImageUrl!,
//         fit: BoxFit.contain,
//         loadingBuilder: (context, child, loadingProgress) {
//           if (loadingProgress == null) return child;
//           return Center(
//             child: CircularProgressIndicator(
//               value: loadingProgress.expectedTotalBytes != null
//                   ? loadingProgress.cumulativeBytesLoaded /
//                       loadingProgress.expectedTotalBytes!
//                   : null,
//               color: const Color(0xFFF5D248),
//             ),
//           );
//         },
//         errorBuilder: (context, error, stackTrace) {
//           return const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.error_outline, size: 48, color: Colors.red),
//                 SizedBox(height: 16),
//                 Text('Failed to load QR image',
//                     style: TextStyle(color: Colors.red)),
//               ],
//             ),
//           );
//         },
//       );
//     }
//     // QR URL from API response
//     else if (khqrData.data?.checkoutQrUrl != null &&
//         khqrData.data!.checkoutQrUrl!.isNotEmpty) {
//       final qrUrl = khqrData.data!.checkoutQrUrl!;

//       // Check if it's an image URL
//       if (qrUrl.toLowerCase().endsWith('.png') ||
//           qrUrl.toLowerCase().endsWith('.jpg') ||
//           qrUrl.toLowerCase().endsWith('.jpeg') ||
//           qrUrl.contains('qrcode') ||
//           qrUrl.contains('qr-code')) {
//         return Image.network(
//           qrUrl,
//           fit: BoxFit.contain,
//           loadingBuilder: (context, child, loadingProgress) {
//             if (loadingProgress == null) return child;
//             return Center(
//               child: CircularProgressIndicator(
//                 value: loadingProgress.expectedTotalBytes != null
//                     ? loadingProgress.cumulativeBytesLoaded /
//                         loadingProgress.expectedTotalBytes!
//                     : null,
//                 color: const Color(0xFFF5D248),
//               ),
//             );
//           },
//           errorBuilder: (context, error, stackTrace) {
//             // Fallback to WebView
//             return InAppWebView(
//               initialUrlRequest: URLRequest(url: WebUri(qrUrl)),
//             );
//           },
//         );
//       } else {
//         // Use WebView for non-image URLs
//         return InAppWebView(
//           initialUrlRequest: URLRequest(url: WebUri(qrUrl)),
//         );
//       }
//     }
//     // No QR data available
//     else {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 48, color: Colors.red),
//             SizedBox(height: 16),
//             Text('No QR data available', style: TextStyle(color: Colors.red)),
//           ],
//         ),
//       );
//     }
//   }
// }
