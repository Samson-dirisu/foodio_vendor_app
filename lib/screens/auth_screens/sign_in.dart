
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

// my packages
import 'package:foodie_vendor_app/util/constants.dart';
import 'package:foodie_vendor_app/widgets/reset_password.dart';
import 'package:foodie_vendor_app/widgets/submit_button.dart';
import 'package:foodie_vendor_app/providers/app_provider.dart';
import 'package:foodie_vendor_app/providers/auth_provider.dart';
import 'package:foodie_vendor_app/screens/landing_screens/home_screen.dart';
import 'package:foodie_vendor_app/util/navigators.dart';
import 'package:foodie_vendor_app/widgets/textformfield.dart';

class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
   final Nav _nav = Nav();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _appProvider = Provider.of<AppProvider>(context);
    final _authData = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      key: _key,
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

                  // Email text field
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

                  // Password textfield
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
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Text(
                            "Forgot Password?",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            _nav.push(
                                context: context, destination: ResetPassword());
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Login button
                  SubmitButton(
                    child: _appProvider.isLoading
                        ? LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                        : Text(
                            "Sign in",
                            style: TextStyle(color: Colors.white),
                          ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _appProvider.changeIsLoading(true);
                        _authData
                            .loggingVendor(
                                _emailController.text, _passwordController.text)
                            .then(
                          (credential) {
                            if (credential != null) {
                              _appProvider.changeIsLoading(false);
                              _nav.pushReplacement(
                                  context: context, destination: HomeScreen());
                            } else {
                              _appProvider.changeIsLoading(false);
                              scaffoldMsg(_authData.error, _key);
                            }
                          },
                        );
                      }
                    },
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
