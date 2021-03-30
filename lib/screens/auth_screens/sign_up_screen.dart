import 'package:flutter/material.dart';
import 'package:foodie_vendor_app/widgets/image_picker.dart';
import 'package:foodie_vendor_app/widgets/register_form.dart';

class SignUpScreen extends StatelessWidget {
  static const String id = "signUP-screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ShopPicCard(),
                RegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
