

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:foodie_vendor_app/providers/app_provider.dart';
import 'package:foodie_vendor_app/providers/auth_provider.dart';
import 'package:foodie_vendor_app/screens/landing_screens/home_screen.dart';
import 'package:foodie_vendor_app/util/constants.dart';
import 'package:foodie_vendor_app/util/navigators.dart';
import 'package:foodie_vendor_app/widgets/textformfield.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Nav _nav = Nav();
  @override
  Widget build(BuildContext context) {
    final _appProvider = Provider.of<AppProvider>(context);
    final _authData = Provider.of<AuthProvider>(context);

    // method for displaying scaffold messages
     scaffoldMsg(String msg) {
      return Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
    return Scaffold(
      body: SafeArea(
              child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("LOGIN",
                          style: TextStyle(fontFamily: 'Anton', fontSize: 50)),
                      SizedBox(width: 20),
                      Image.asset("images/logo.png", height: 80),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Email',
                    controller: _emailController,
                    prefixIcon: Icon(Icons.email_outlined),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter Email";
                      }
                      final bool _isValid =
                          EmailValidator.validate(_emailController.text);
                      if (!_isValid) {
                        return "Invalid Email Format";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Password',
                    controller: _passwordController,
                    obscureText: _appProvider.showPassword,
                    suffixIcon: IconButton(
                      icon: _appProvider.showPassword
                          ? Icon(Icons.visibility_off_outlined)
                          : Icon(Icons.remove_red_eye_outlined),
                      onPressed: () {
                        _appProvider.togglePassword();
                      },
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter Password";
                      }
                      if (value.length < 6) {
                        return "Minimum of 6 characters";
                      }
                      return null;
                    },
                    prefixIcon: Icon(Icons.vpn_key_outlined),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _authData
                                  .loggingVendor(_emailController.text,
                                      _passwordController.text)
                                  .then(
                                (credential) {
                                  if (credential != null) {
                                    _nav.pushReplacement(
                                        context: context,
                                        destination: HomeScreen());
                                  } else {
                                    scaffoldMsg("Logging failed");
                                  }
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
