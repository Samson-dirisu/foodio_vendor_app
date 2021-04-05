import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:foodie_vendor_app/screens/auth_screens/sign_in.dart';
import 'package:foodie_vendor_app/util/constants.dart';
import 'package:foodie_vendor_app/widgets/submit_button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// my imports
import 'package:foodie_vendor_app/providers/app_provider.dart';
import 'package:foodie_vendor_app/providers/auth_provider.dart';
import 'package:foodie_vendor_app/util/navigators.dart';
import 'package:foodie_vendor_app/widgets/textformfield.dart';

class ResetPassword extends StatelessWidget {
  // Contorllers
  final TextEditingController _emailController = TextEditingController();

  // Keys
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  // widgets
  final Nav _nav = Nav();
  @override
  Widget build(BuildContext context) {
    //Providers
    final _appProvider = Provider.of<AppProvider>(context);
    final _authData = Provider.of<AuthProvider>(context);

    // return scaffold
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(.1),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lottie animation
                  Container(
                    color: Theme.of(context).primaryColor.withOpacity(.2),
                    alignment: Alignment.center,
                    child: Lottie.asset('lottie/forgotPW.json'),
                  ),
                  SizedBox(height: 20),
                  // Texts
                  RichText(
                    text: TextSpan(
                      text: '',
                      children: [
                        TextSpan(
                          text: 'Forgot Password ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        TextSpan(
                          text:
                              'Dont worry, provider us your registered email, we will send you an email to reset your password',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                            fontSize: 14.0,
                          ),
                        )
                      ],
                    ),
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

                  // Submit Button
                  SubmitButton(
                    child: _appProvider.isLoading
                        ? LinearProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white))
                        : Text("Reset Password",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _appProvider.changeIsLoading(true);
                        _authData
                            .resetPassword(_emailController.text)
                            .then((value) {
                              scaffoldMsg("Check your Email for reset link", this._key);
                            });
                        _appProvider.changeIsLoading(false);
                      } else {
                         scaffoldMsg("Input your correct email", this._key);
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
