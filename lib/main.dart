import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:palm_ecommerce_app/firebase_options.dart';
import 'package:palm_ecommerce_app/l10n/app_localizations.dart';
import 'package:palm_ecommerce_app/ui/screens/splash/spalsh_screen.dart';
import 'package:palm_ecommerce_app/theme/theme_config.dart';
import 'package:palm_ecommerce_app/app_model/app_them.dart';

// Providers
import 'package:palm_ecommerce_app/ui/provider/language_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/authentication_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/product_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/category_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/cart_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/checkout_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/address_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/order_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/favorite_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/payment_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/notification_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/bakong_provider.dart';

// Repositories
import 'package:palm_ecommerce_app/data/repository/https/authentication_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/product_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/category_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/cart_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/checkout_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/delivery_address_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/order_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/favorite_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/payment_method_api.repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/notification_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/bakong_api_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      Firebase.app(); // Use the existing instance if already initialized
    }
    FirebaseAuth.instance.setLanguageCode('en');
  } catch (e) {
    print('Firebase init error: $e');
  }
  // Initialize repositories
  final authRepository = AuthenticationApiRepository();
  final productRepository = ProductApiRepository()..repository = authRepository;
  final categoryRepository = CategoryApiRepository(authRepository);
  final cartRepository = CartApiRepository()..repository = authRepository;
  final checkoutRepository = CheckoutApiRepository()
    ..repository = authRepository;
  final addressRepository = DeliveryAddressApiRepository(authRepository);
  final orderRepository = OrderApiRepository(authRepository);
  final favoriteRepository = FavoriteApiRepository(authRepository);
  final paymentMethodRepository = PaymentMethodApiRepository(authRepository);
  final notificationRepository = NotificationApiRepository()
    ..repository = authRepository;
  final bakongRepository = BakongApiRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(
            create: (_) => AuthenticationProvider(repository: authRepository)),
        ChangeNotifierProvider(
            create: (_) => ProductProvider(repository: productRepository)),
        ChangeNotifierProvider(
            create: (_) =>
                CategoryProvider(categoryRepository: categoryRepository)),
        ChangeNotifierProvider(
            create: (_) => CartProvider(repository: cartRepository)),
        ChangeNotifierProvider(
            create: (_) =>
                CheckoutProvider(checkoutRepository: checkoutRepository)),
        ChangeNotifierProvider(
            create: (_) =>
                AddressProvider(addressRepository: addressRepository)),
        ChangeNotifierProvider(
            create: (_) => OrderProvider(orderRepository: orderRepository)),
        ChangeNotifierProvider(
            create: (_) => FavoriteProvider(favoriteRepository)),
        ChangeNotifierProvider(
            create: (_) => PaymentProvider(
                paymentMethodRepository: paymentMethodRepository)),
        ChangeNotifierProvider(
            create: (_) => NotificationProvider(notificationRepository)),
        ChangeNotifierProvider(
            create: (_) => BakongProvider(bakongRepository: bakongRepository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, LanguageProvider>(
      builder: (context, appProvider, languageProvider, _) {
        if (!languageProvider.isInitialized) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp(
          key: appProvider.key,
          navigatorKey: appProvider.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'PALM Ecommerce',
          theme: _themeData(appProvider.theme),
          darkTheme: _themeData(ThemeConfig.lightTheme),
          locale: languageProvider.currentLocale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            ...AppLocalizations.localizationsDelegates,
          ],
          home: const SplashScreen(),
        );
      },
    );
  }

  ThemeData _themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSerif4TextTheme(theme.textTheme).apply(
        fontFamily: 'Khmer OS',
      ),
      colorScheme: theme.colorScheme.copyWith(
        secondary: ThemeConfig.lightAccent,
      ),
    );
  }
}
