import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/ui/screens/auth/login/sign_in_body.dart';

class SignInScreen extends StatelessWidget {
  //final Function function;

  const SignInScreen({super.key, Function? function});

  static String nameRoute = "/sign_in";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      title: "Login",
      home: const SignInBody(),
    );
  }
}
