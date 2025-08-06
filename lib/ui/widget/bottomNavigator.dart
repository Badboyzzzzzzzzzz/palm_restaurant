import 'package:palm_ecommerce_app/ui/screens/home/home_page.dart';
import 'package:palm_ecommerce_app/ui/screens/favorite/favoriteScreen.dart';
import 'package:palm_ecommerce_app/ui/screens/my_profile/my_profile.dart';
import 'package:palm_ecommerce_app/ui/screens/order/order.dart';
import 'package:palm_ecommerce_app/util/themes.dart';
import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/l10n/app_localizations.dart';

class BottomNavBar extends StatefulWidget {
  static const nameRoute = '/';
  static const int homeIndex = 0;
  static const int favoriteIndex = 1;
  static const int orderIndex = 2;
  static const int accountIndex = 3;

  final int initialIndex;

  const BottomNavBar({super.key, this.initialIndex = homeIndex});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _selectedIndex;

  final _screens = [
    const HomePage(),
    const Favoritescreen(),
    const OrderScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    Widget customBottomNav() {
      return BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (i) {
          setState(() {
            _selectedIndex = i;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(top: 6),
              child: Image.asset(
                'assets/icons/icnNavHome1.png',
                width: 20,
                color: _selectedIndex == BottomNavBar.homeIndex
                    ? blueColor
                    : greyColor,
              ),
            ),
            label: AppLocalizations.of(context)?.home ?? 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(top: 6),
              child: Icon(
                Icons.favorite_outline_sharp,
                size: 20,
                color: _selectedIndex == BottomNavBar.favoriteIndex
                    ? blueColor
                    : greyColor,
              ),
            ),
            label: AppLocalizations.of(context)?.favorites ?? 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(top: 6),
              child: Icon(
                Icons.delivery_dining,
                size: 20,
                color: _selectedIndex == BottomNavBar.orderIndex
                    ? blueColor
                    : greyColor,
              ),
            ),
            label: AppLocalizations.of(context)?.orders ?? 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(top: 6),
              child: Image.asset(
                'assets/icons/icnNavUser.png',
                width: 20,
                color: _selectedIndex == BottomNavBar.accountIndex
                    ? blueColor
                    : greyColor,
              ),
            ),
            label: AppLocalizations.of(context)?.profile ?? 'My Profile',
          ),
        ],  
      );
    }

    return Scaffold(
      bottomNavigationBar: customBottomNav(),
      body: Stack(
        children: _screens
            .asMap()
            .map((i, screen) => MapEntry(
                i,
                Offstage(
                  offstage: _selectedIndex != i,
                  // child: screen,
                  child: screen,
                )))
            .values
            .toList(),
      ),
    );
  }
}
