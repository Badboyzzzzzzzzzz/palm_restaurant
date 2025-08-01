import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:palm_ecommerce_app/ui/widget/bottomNavigator.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CheckoutSuccessScreen extends StatefulWidget {
  const CheckoutSuccessScreen({
    super.key,
  });

  @override
  State<CheckoutSuccessScreen> createState() => _CheckoutSuccessScreenState();
}

class _CheckoutSuccessScreenState extends State<CheckoutSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    // Start animations immediately
    _confettiController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFFDF5),
                  Colors.white,
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        // Success animation
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Pulsating circle
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFF5D248).withOpacity(0.2),
                              ),
                            )
                                .animate(controller: _fadeController)
                                .scale(
                                    begin: Offset(0.8, 0.8),
                                    end: Offset(1.0, 1.0),
                                    curve: Curves.easeOutBack)
                                .fadeIn(duration: 600.ms),

                            // Success animation
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: Lottie.network(
                                'https://assets10.lottiefiles.com/packages/lf20_s2lryxtd.json',
                                controller: _confettiController,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),

                        // Success message
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Text(
                                'Order Successful!',
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF391713),
                                ),
                              )
                                  .animate(controller: _fadeController)
                                  .slideY(
                                      begin: 0.3,
                                      end: 0,
                                      curve: Curves.easeOutQuad)
                                  .fadeIn(delay: 200.ms),
                              const SizedBox(height: 16),
                              Text(
                                'Your order has been placed successfully. We will contact you soon!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
                              )
                                  .animate(controller: _fadeController)
                                  .slideY(
                                      begin: 0.3,
                                      end: 0,
                                      curve: Curves.easeOutQuad)
                                  .fadeIn(delay: 400.ms),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Continue shopping button
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to home screen
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BottomNavBar(),
                              ),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5D248),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Continue Shopping',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                          .animate(controller: _fadeController)
                          .slideY(begin: 0.3, end: 0, curve: Curves.easeOutQuad)
                          .fadeIn(delay: 1000.ms),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          // Navigate to order tracking
                          // You can implement this navigation
                        },
                        child: Text(
                          'Track My Order',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFF5D248),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                          .animate(controller: _fadeController)
                          .slideY(begin: 0.3, end: 0, curve: Curves.easeOutQuad)
                          .fadeIn(delay: 1200.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Confetti overlay animation
          Positioned.fill(
            child: IgnorePointer(
              child: Lottie.network(
                'https://assets2.lottiefiles.com/packages/lf20_uwR49r.json',
                controller: _confettiController,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
