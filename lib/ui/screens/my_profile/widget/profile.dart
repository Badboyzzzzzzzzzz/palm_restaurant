// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/l10n/app_localizations.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/screens/my_profile/widget/edit_user_profile.dart';
import 'package:palm_ecommerce_app/util/data.dart';
import 'package:palm_ecommerce_app/util/themes.dart';
import 'package:palm_ecommerce_app/ui/provider/authentication_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
  });
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? currentToken;
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.getUserInfo();
    setState(() {
      currentToken = authProvider.token;
      token = authProvider.token;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    final userState = authProvider.user;
    final profileImage = authProvider.user.data?.profileImage;
    // Check if data is still loading
    if (userState.state == AsyncValueState.loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryBackgroundColor,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context)?.profile ?? 'My Profile',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: whiteColor),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: whiteColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(color: primaryBackgroundColor),
        ),
      );
    }

    // Check for errors
    if (userState.state == AsyncValueState.error) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryBackgroundColor,
          elevation: 0,
          title: Text(AppLocalizations.of(context)!.profile,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: whiteColor)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: whiteColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  size: 48, color: primaryBackgroundColor),
              SizedBox(height: 16),
              Text('Error loading profile: ${userState.error}',
                  style: regularText14, textAlign: TextAlign.center),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _loadUserData();
                },
                style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    // Continue with your existing UI for success state
    final userInfo = userState.data;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)?.profile ?? 'My Profile',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: whiteColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: whiteColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Top background gradient
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primaryBackgroundColor,
                  primaryBackgroundColor.withOpacity(0.5),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Center(
                        child: SizedBox(
                      height: 115,
                      width: 115,
                      child: Stack(
                        fit: StackFit.expand,
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            backgroundImage: profileImage != null
                                ? NetworkImage(profileImage)
                                : const AssetImage("assets/palmlogo.png"),
                          ),
                          Positioned(
                            right: -16,
                            bottom: 0,
                            child: SizedBox(
                              height: 46,
                              width: 46,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: const BorderSide(color: Colors.white),
                                  ),
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color(0xFFF5F6F9),
                                ),
                                onPressed: () {},
                                child: Image.asset("assets/camera-outline.png"),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  color: primaryBackgroundColor,
                                  size: 24,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  AppLocalizations.of(context)?.personInfo ??
                                      'Personal Information',
                                  style: semiBoldText16.copyWith(
                                      color: blackColor),
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color:
                                        primaryBackgroundColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EditUserProfile(),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      color: primaryBackgroundColor,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1),
                          _buildInfoItem(
                            icon: Icons.credit_card_outlined,
                            title: "ID",
                            value: userInfo?.id.toString() ?? "N/A",
                          ),
                          Divider(height: 1),
                          _buildInfoItem(
                            icon: Icons.person_outline,
                            title: AppLocalizations.of(context)?.userName ??
                                'Username',
                            value: userInfo?.name ?? "N/A",
                          ),
                          Divider(height: 1),
                          _buildInfoItem(
                            icon: Icons.phone_outlined,
                            title: AppLocalizations.of(context)?.phoneNumber ??
                                'Phone Number',
                            value: userInfo?.phone ?? "N/A",
                          ),
                          Divider(height: 1),
                          _buildInfoItem(
                            icon: Icons.email_outlined,
                            title: "Email",
                            value: userInfo?.email ?? "N/A",
                          ),
                          _buildInfoItem(
                            icon: Icons.male_outlined,
                            title: "Gender",
                            value: _formatGender(userInfo?.gender),
                          ),
                          _buildInfoItem(
                            icon: Icons.date_range,
                            title: "Date of Birth",
                            value: _formatDateOfBirth(userInfo?.dob),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatGender(String? gender) {
    if (gender == null) return "N/A";
    String lowerGender = gender.toLowerCase();
    if (lowerGender == "male" ||
        lowerGender == "female" ||
        lowerGender == "other") {
      return gender[0].toUpperCase() + gender.substring(1).toLowerCase();
    }

    switch (gender) {
      case "1":
        return "Male";
      case "2":
        return "Female";
      case "0":
      case "3":
        return "Other";
      default:
        return gender;
    }
  }

  String _formatDateOfBirth(String? dob) {
    if (dob == null || dob.isEmpty) return "N/A";

    if (!dob.contains('-') && !dob.contains('/')) {
      return dob;
    }

    try {
      DateTime dateTime;
      if (dob.contains('T')) {
        dateTime = DateTime.parse(dob);
      } else if (dob.contains('-')) {
        final parts = dob.split('-');
        if (parts.length == 3) {
          dateTime = DateTime(
              int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
        } else {
          return dob;
        }
      } else if (dob.contains('/')) {
        final parts = dob.split('/');
        if (parts.length == 3) {
          dateTime = DateTime(
              int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
        } else {
          return dob;
        }
      } else {
        return dob;
      }
      final months = [
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return "${dateTime.day} ${months[dateTime.month]}, ${dateTime.year}";
    } catch (e) {
      return dob;
    }
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryBackgroundColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: primaryBackgroundColor,
              size: 18,
            ),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: regularText14.copyWith(color: blackColor),
              ),
              SizedBox(height: 3),
              Text(
                value,
                style: mediumText14.copyWith(color: blackColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
