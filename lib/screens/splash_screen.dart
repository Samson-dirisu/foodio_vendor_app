import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// my imports
import 'package:foodie_vendor_app/screens/auth_screens/sign_in.dart';
import 'package:foodie_vendor_app/screens/auth_screens/sign_up_screen.dart';
import 'package:foodie_vendor_app/util/navigators.dart';
import 'landing_screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splash-screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Nav _nav = Nav();
  Timer _timer;

  // what should be done before any widget
  @override
  void initState() {
    _timer = Timer(
      Duration(seconds: 3),
      () {
        FirebaseAuth.instance.authStateChanges().listen((User user) {
          if (user == null) {
            _nav.pushReplacement(context: context, destination: SignInScreen());
          } else {
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          }
        });
      },
    );

    super.initState();
  }

  // dispose timer to avoid conflict
  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: Image.asset("images/logo.png"),
              ),
              Text(
                "Foodio - Vendor App",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
