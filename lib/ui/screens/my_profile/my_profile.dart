// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:palm_ecommerce_app/ui/provider/authentication_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/my_profile/widget/profile_picture.dart';
import 'package:palm_ecommerce_app/ui/screens/my_profile/widget/aboutUs.dart';
import 'package:palm_ecommerce_app/ui/screens/my_profile/widget/language_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/ui/screens/auth/login/sign_in_screen.dart';
import 'package:palm_ecommerce_app/ui/screens/cart_screen/cart_screen.dart';
import 'package:palm_ecommerce_app/ui/screens/my_profile/widget/profile.dart';
import 'package:palm_ecommerce_app/ui/screens/my_profile/widget/change_password.dart';
import 'package:palm_ecommerce_app/util/themes.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_app/l10n/app_localizations.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryBackgroundColor,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)?.profile ?? 'Profile',
          style: semiBoldText20.copyWith(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryBackgroundColor,
              secondaryBackgroundColor,
            ],
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfilePicture(),
              Text(
                authProvider.user.data?.name ?? "Guest User",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                AppLocalizations.of(context)?.welcome ?? 'Welcome',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              _buildMenuItem(
                text: AppLocalizations.of(context)?.profile ?? 'Profile',
                icon: Icons.person,
                iconColor: Colors.indigo,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
              ),
              _buildMenuItem(
                text: AppLocalizations.of(context)?.cart ?? 'Cart',
                icon: Icons.shopping_cart,
                iconColor: Colors.blueAccent,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartScreen()));
                },
              ),
              _buildMenuItem(
                text: AppLocalizations.of(context)?.about ?? 'About Us',
                icon: Icons.info_outline,
                iconColor: Colors.teal,
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AboutUs()));
                },
              ),
              _buildMenuItem(
                text: AppLocalizations.of(context)?.language ?? 'Language',
                icon: Icons.language,
                iconColor: Colors.blueGrey,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LanguageSelectionScreen()));
                },
              ),
              _buildMenuItem(
                text: AppLocalizations.of(context)?.changePassword ??
                    'Change Password',
                icon: Icons.info_outline,
                iconColor: Colors.teal,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChangePassword()));
                },
              ),
              _buildMenuItem(
                text: AppLocalizations.of(context)?.help ?? 'Help',
                icon: Icons.help_outline,
                iconColor: Colors.blueGrey,
                onTap: () {},
              ),
              authProvider.token == null
                  ? _buildMenuItem(
                      text: AppLocalizations.of(context)?.login ?? 'Login',
                      icon: Icons.login,
                      iconColor: accentColor,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()));
                      },
                    )
                  : _buildMenuItem(
                      text: AppLocalizations.of(context)?.logout ?? 'Logout',
                      icon: Icons.logout,
                      iconColor: Colors.redAccent,
                      onTap: () {
                        _showLogoutDialog(context, authProvider);
                      },
                    ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String text,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        title: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
          )
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: greyColor,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(
      BuildContext context, AuthenticationProvider authProvider) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Log Out'),
        content: const Text('Do you want to logout?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              await authProvider.signOut();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              }
            },
            child: const Text('Yes'),
          )
        ],
      ),
    );
  }
}
