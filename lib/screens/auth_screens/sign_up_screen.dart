import 'package:flutter/material.dart';
import 'package:foodie_vendor_app/widgets/image_picker.dart';
import 'package:foodie_vendor_app/widgets/register_form.dart';

class SignUpScreen extends StatelessWidget {
  static const String id = "signUP-screen";
  final _scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: "_signUpScreen");

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ShopPicCard(),
                  RegisterForm(refkey: this._scaffoldKey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
