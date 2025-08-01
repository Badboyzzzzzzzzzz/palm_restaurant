import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/util/size_config.dart';
import 'widgets/splash_body.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static String nameRoute = "/splash";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SplashBody(),
    );
  }
}
