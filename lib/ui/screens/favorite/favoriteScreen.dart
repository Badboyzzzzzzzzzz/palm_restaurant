import 'package:palm_ecommerce_app/ui/provider/favorite_provider.dart';
import 'package:palm_ecommerce_app/util/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widget/favoriteScreenBody.dart';
import 'package:palm_ecommerce_app/l10n/app_localizations.dart';

class Favoritescreen extends StatefulWidget {
  const Favoritescreen({super.key});
  @override
  State<Favoritescreen> createState() => _SavePageState();
}

class _SavePageState extends State<Favoritescreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoriteProvider>(context, listen: false)
          .getFavoriteProducts();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: AppBar(
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryBackgroundColor,
                    primaryBackgroundColor.withOpacity(0.9)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _animation,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: whiteColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: accentColor,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  AppLocalizations.of(context)!.favorites,
                  style: semiBoldText20.copyWith(
                    color: blackColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          await context.read<FavoriteProvider>().getFavoriteProducts();
        },
        child: const FavoriteScreenBody(),
      ),
    );
  }
}
