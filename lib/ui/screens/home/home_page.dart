// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palm_ecommerce_app/ui/provider/authentication_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/home/hot_promotion/hot_promotion_view.dart';
import 'package:palm_ecommerce_app/ui/screens/home/hot_promotion/hot_promotion.dart';
import 'package:palm_ecommerce_app/ui/screens/home/widget/cart_icon.dart';
import 'package:palm_ecommerce_app/ui/screens/home/category/food_category_list.dart';
import 'package:palm_ecommerce_app/ui/screens/home/discount/slide_show_dicount_food.dart';
import 'package:palm_ecommerce_app/ui/screens/home/new_arrival_food/new_arrival_food.dart';
import 'package:palm_ecommerce_app/ui/screens/home/new_arrival_food/view_all_new_arrival_screen.dart';
import 'package:palm_ecommerce_app/ui/screens/home/widget/notification_icon.dart';
import 'package:palm_ecommerce_app/util/data.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_app/ui/provider/product_provider.dart';
import 'package:palm_ecommerce_app/l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;
  Timer? _timeTimer; // Made nullable for better null safety
  bool _isInitialized = false;
  String selectedCategory = '';
  String _greeting = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateGreeting();
    // Start timer after first greeting update
    if (_timeTimer == null) {
      _startGreetingTimer();
    }
  }

  void _startGreetingTimer() {
    _timeTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        // Check if widget is still mounted
        _updateGreeting();
      }
    });
  }

  void _updateGreeting() {
    if (!mounted) return;

    // Ensure we're in a valid build context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final localizations = AppLocalizations.of(context);
      if (localizations == null) {
        setState(() => _greeting = 'Welcome');
        return;
      }

      final hour = DateTime.now().hour;
      setState(() {
        if (hour < 12) {
          _greeting = localizations.goodMorning;
        } else if (hour < 17) {
          _greeting = localizations.goodAfternoon;
        } else {
          _greeting = localizations.goodEvening;
        }
      });
    });
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;

    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.initializeCurrentUser();
    if (mounted) {
      setState(() {
        token = authProvider.token;
      });
    }
  }

  Future<void> _initializeData() async {
    if (!_isInitialized && mounted) {
      _isInitialized = true;
      // Use addPostFrameCallback to ensure we're not updating during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchData();
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _timeTimer?.cancel(); // Cancel timer safely
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    if (!mounted) return;

    if (_debounceTimer?.isActive ?? false) return;
    _debounceTimer = Timer(const Duration(seconds: 2), () {});

    try {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      await provider.fetchProducts();
      await provider.fetchTopSaleFood();
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    final user = authProvider.user;
    final userData = user.data; // Add null safety for user
    final profileImage = userData?.profileImage;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFCA48),
                        Color.fromARGB(255, 225, 202, 108),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: profileImage != null
                                      ? Image.network(
                                          profileImage,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              width: 40,
                                              height: 40,
                                              color: Colors.black,
                                              child: const Icon(Icons.person,
                                                  color: Colors.white),
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          'assets/images/profile_avatar.png',
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              width: 36,
                                              height: 36,
                                              color: Colors.black,
                                              child: const Icon(Icons.person,
                                                  color: Colors.white),
                                            );
                                          },
                                        ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)?.welcome ??
                                          'Welcome',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      userData?.name ?? 'Username',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Notification icon only (cart icon moved to floating button)
                            const NotificationIcon(),
                          ],
                        ),
                      ),
                      // Dynamic greeting based on time of day
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _greeting.isEmpty ? 'Hello' : _greeting,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF391713),
                                fontFamily: 'League Spartan',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppLocalizations.of(context)?.greetingSubtitle ??
                                  'Welcome to our app',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF391713),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                // Main content with white background and rounded corners
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          // Discount banner
                          const SlideShowDiscountFood(),
                          const SizedBox(height: 8),
                          // Category circles
                          Container(
                            height: 230,
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            decoration: BoxDecoration(
                              color: Colors.yellow[100], // Yellow background
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    AppLocalizations.of(context)
                                            ?.foodCategory ??
                                        'Food Categories',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF391713),
                                      fontFamily: 'League Spartan',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 160,
                                  child: FoodCategory(
                                    onCategorySelected: (category) {
                                      if (mounted) {
                                        setState(() {
                                          selectedCategory = category;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildSectionHeader(
                              AppLocalizations.of(context)?.hotPromotion ??
                                  'Hot Promotion', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ViewAllBestSeller()),
                            );
                          }),
                          const BestSeller(),
                          const SizedBox(height: 8),
                          // Divider line
                          Container(
                            height: 1,
                            color: const Color(0xFFFFD8C7),
                          ),
                          const SizedBox(height: 8),
                          _buildSectionHeader(
                              AppLocalizations.of(context)?.newArrival ??
                                  'New Arrival', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NewArrivalScreen()),
                            );
                          }),
                          const NewArrivalFood(),
                          // Add extra space at bottom for floating cart button
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Add floating cart icon
            const CartIcon(isFloating: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onPressed) {
    final localizations = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF391713),
            fontFamily: 'League Spartan',
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            localizations?.viewAll ?? 'View All',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE95322),
            ),
          ),
        ),
      ],
    );
  }
}
