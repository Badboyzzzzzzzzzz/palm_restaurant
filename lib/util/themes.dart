import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primaryBackgroundColor = const Color(0xFFFFCA48); // Earthy yellow/brown
Color secondaryBackgroundColor =
    const Color(0xFFF5F5F5); // Off-white/light grey for middle section
Color accentColor = const Color(0xFFFF6B3D); // Reddish-orange accent color

Color backgroundColor =
    const Color(0xFFFFCA48); // Keep original but might not be used widely
Color backgroundColorWhite = const Color(0xFFFFFFFF);
Color whiteColor = const Color(0xFFFFFFFF);
Color blackColor = const Color(0xFF2D2D2D);
Color blackColor2 = Color(0xFF000000);
Color greyColor = Color(0xFFBDBDBD);
Color greyColorSearchField = Color(0xFFF8F8F8);
Color greenColor = Color(0xFF098B5C);
Color blueColor = Color(0xFFFFD21B);
Color greyColorRecentBook = Color(0xFFAFAFAF);
Color borderColorRecentBook = Color(0xFFF3F3F3);
Color greyColorInfo = Color(0xFF7F7F7F);
Color dividerColor = Color(0xFF6B6B6B);
Color transParentColor = Colors.transparent;

// const kAppBarHeight = 56.0;

// SEMIBOLD TEXT
TextStyle semiBoldText20 =
    GoogleFonts.poppins(fontSize: 20, fontWeight: semiBold);
TextStyle semiBoldText16 =
    GoogleFonts.poppins(fontSize: 16, fontWeight: semiBold);
TextStyle semiBoldText14 =
    GoogleFonts.poppins(fontSize: 14, fontWeight: semiBold);
TextStyle semiBoldText12 =
    GoogleFonts.poppins(fontSize: 12, fontWeight: semiBold);

//REGULAR TEXT
TextStyle regularText14 =
    GoogleFonts.poppins(fontSize: 14, fontWeight: regular);
TextStyle regularText12 =
    GoogleFonts.poppins(fontSize: 12, fontWeight: regular);

//MEDIUM TEXT
TextStyle mediumText12 =
    GoogleFonts.poppins(color: dividerColor, fontSize: 12, fontWeight: medium);
TextStyle mediumText14 = GoogleFonts.poppins(fontSize: 14, fontWeight: medium);
TextStyle mediumText10 = GoogleFonts.poppins(fontSize: 10, fontWeight: medium);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

/*For Login Form*/
// ThemeData theme() {
//   return ThemeData(
//     // scaffoldBackgroundColor: Colors.blue,
//     // fontFamily: "Menlo",
//     appBarTheme: AppBarTheme(
//       color: Colors.white,
//       elevation: 1,
//       brightness: Brightness.light,
//       iconTheme: IconThemeData(color: Colors.black),
//       textTheme: TextTheme(
//         headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
//
//       ),
//     ),
//     visualDensity: VisualDensity.adaptivePlatformDensity,
//     // textTheme: TextTheme(
//     //   bodyText1: TextStyle(color: Colors.black),
//     //   bodyText2: TextStyle(color: Colors.black),
//     // ),
//   );
// }
