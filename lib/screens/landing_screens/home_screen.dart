import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodie_vendor_app/screens/auth_screens/sign_in.dart';
import 'package:foodie_vendor_app/util/navigators.dart';

class HomeScreen extends StatelessWidget {
  static const String id = "home-screen";
  final Nav _nav = Nav();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text("I want to fuck Helen so badly")),
              InkWell(
                child: Text("logout"),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  _nav.pushReplacement(
                      context: context, destination: SignInScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
