import 'package:palm_ecommerce_app/app_model/app_them.dart';
import 'package:palm_ecommerce_app/data/repository/https/authentication_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/cart_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/category_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/checkout_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/delivery_address_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/favorite_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/notification_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/order_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/payment_method_api.repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/product_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/https/bakong_api_repository.dart';
import 'package:palm_ecommerce_app/firebase_options.dart';
import 'package:palm_ecommerce_app/theme/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palm_ecommerce_app/l10n/app_localizations.dart';
import 'package:palm_ecommerce_app/ui/provider/address_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/authentication_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/cart_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/category_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/favorite_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/notification_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/order_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/payment_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/product_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/checkout_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/language_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/splash/spalsh_screen.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_app/ui/provider/bakong_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authRepository = AuthenticationApiRepository();
  final productRepository = ProductApiRepository();
  final categoryRepository = CategoryApiRepository(authRepository);
  final cartRepository = CartApiRepository();
  final checkoutRepository = CheckoutApiRepository();
  final addressRepository = DeliveryAddressApiRepository(authRepository);
  final orderRepository = OrderApiRepository(authRepository);
  final favoriteRepository = FavoriteApiRepository(authRepository);
  final paymentMethodRepository = PaymentMethodApiRepository(authRepository);
  final notificationRepository = NotificationApiRepository();
  final bakongRepository = BakongApiRepository();
  // Initialize repositories with auth repository
  productRepository.repository = authRepository;
  cartRepository.repository = authRepository;
  checkoutRepository.repository = authRepository;
  notificationRepository.repository = authRepository;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(repository: productRepository),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              AuthenticationProvider(repository: authRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(
            categoryRepository: categoryRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(repository: cartRepository),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              CheckoutProvider(checkoutRepository: checkoutRepository),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              AddressProvider(addressRepository: addressRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(orderRepository: orderRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoriteProvider(favoriteRepository),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              PaymentProvider(paymentMethodRepository: paymentMethodRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(notificationRepository),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              BakongProvider(bakongRepository: bakongRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(),
        ),
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
      builder: (BuildContext context, AppProvider appProvider,
          LanguageProvider languageProvider, Widget? child) {
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: 'PALM Ecommerce',
          theme: themeData(appProvider.theme),
          darkTheme: themeData(ThemeConfig.lightTheme),
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
  // Apply font to our app's theme
  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSerif4TextTheme(
        theme.textTheme,
      ).copyWith(
        // Configure default text styles for Khmer text
        bodyLarge: const TextStyle(fontFamily: 'Khmer OS'),
        bodyMedium: const TextStyle(fontFamily: 'Khmer OS'),
        bodySmall: const TextStyle(fontFamily: 'Khmer OS'),
        displayLarge: const TextStyle(fontFamily: 'Khmer OS'),
        displayMedium: const TextStyle(fontFamily: 'Khmer OS'),
        displaySmall: const TextStyle(fontFamily: 'Khmer OS'),
        headlineLarge: const TextStyle(fontFamily: 'Khmer OS'),
        headlineMedium: const TextStyle(fontFamily: 'Khmer OS'),
        headlineSmall: const TextStyle(fontFamily: 'Khmer OS'),
        titleLarge: const TextStyle(fontFamily: 'Khmer OS'),
        titleMedium: const TextStyle(fontFamily: 'Khmer OS'),
        titleSmall: const TextStyle(fontFamily: 'Khmer OS'),
        labelLarge: const TextStyle(fontFamily: 'Khmer OS'),
        labelMedium: const TextStyle(fontFamily: 'Khmer OS'),
        labelSmall: const TextStyle(fontFamily: 'Khmer OS'),
      ),
      colorScheme: theme.colorScheme.copyWith(
        secondary: ThemeConfig.lightAccent,
      ),
    );
  }
}
