import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// My Exports
import 'package:foodie_vendor_app/providers/app_provider.dart';
import 'package:foodie_vendor_app/providers/auth_provider.dart';
import 'package:foodie_vendor_app/screens/landing_screens/home_screen.dart';
import 'package:foodie_vendor_app/util/constants.dart';
import 'package:foodie_vendor_app/util/navigators.dart';
import 'package:foodie_vendor_app/widgets/submit_button.dart';
import 'package:foodie_vendor_app/widgets/textformfield.dart';
import 'package:email_validator/email_validator.dart';

class RegisterForm extends StatelessWidget {
  // Private variables
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _shopDialogController = TextEditingController();

  // Public Variables
  final GlobalKey<ScaffoldState> refkey;

  RegisterForm({this.refkey});

  final Nav _nav = Nav();

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    final _appProvider = Provider.of<AppProvider>(context);

    return _appProvider.isLoading
        ? CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))
        : Form(
            key: _formKey,
            child: Column(
              children: [
                // Business name TextFormField
                CustomTextFormField(
                  labelText: "Business Name",
                  controller: _nameController,
                  prefixIcon: Icon(Icons.add_business_outlined),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter Business Name";
                    }
                    return null;
                  },
                ),

                // Mobile Number TextFormField
                CustomTextFormField(
                  labelText: "Mobile Number",
                  prefixText: "+234  ",
                  controller: _mobileController,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icon(Icons.phone_android),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter Your Mobile Number";
                    }
                    return null;
                  },
                ),

                // Email TextFormField
                CustomTextFormField(
                  labelText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.email_outlined),
                  controller: _emailController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter Your Email";
                    }
                    final bool _isValid =
                        EmailValidator.validate(_emailController.text);
                    if (!_isValid) {
                      return "Invalid Email Format";
                    }
                    return null;
                  },
                ),

                // Password TextFormField
                CustomTextFormField(
                  labelText: "Password",
                  controller: _passwordController,
                  prefixIcon: Icon(Icons.vpn_key_outlined),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter Your Password";
                    }
                    if (value.length < 6) {
                      return "Minimum of 6 characters";
                    }
                    return null;
                  },
                ),

                // Confirm TextFormField
                CustomTextFormField(
                  labelText: "Confirm Password",
                  controller: _confirmPasswordController,
                  prefixIcon: Icon(Icons.vpn_key_outlined),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter Confirm password";
                    }
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      return "Password doesn\'t match";
                    }
                    if (value.length < 6) {
                      return "Minimum of 6 characters";
                    }
                    return null;
                  },
                ),

                // Businees location textfield
                CustomTextFormField(
                  controller: _appProvider.addressController,
                  labelText: "Business Location",
                  maxLines: 6,
                  prefixIcon: Icon(Icons.contact_mail_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.location_searching_outlined),
                    onPressed: () {
                      _appProvider.setInitialMessage();
                      _authData.getCurrentAddress().then((address) {
                        if (address != null) {
                          _appProvider.updateCurrentAddress(
                              _authData.shopAddress, _authData.placeName);
                        }
                      });
                    },
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please press the Navigation Icon by your right";
                    }
                    if (_authData.shopLatitude == null) {
                      scaffoldMsg(
                          'Couldn\'t find location...Try again', this.refkey);
                    }

                    return null;
                  },
                ),

                // shop dialog textfield
                CustomTextFormField(
                  labelText: "Shop Dialog",
                  controller: _shopDialogController,
                  prefixIcon: Icon(Icons.comment_bank_outlined),
                ),

                // sizedbox for space
                SizedBox(height: 20.0),

                // submit button
                SubmitButton(
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    if (_authData.isPicAvailable) {
                      // check if form requirement are meant
                      if (this._formKey.currentState.validate()) {
                        _appProvider.changeIsLoading(false);
                        _authData
                            .registerVendor(
                                _emailController.text, _passwordController.text)
                            .then(
                          (credential) {
                            if (credential.user.uid != null) {
                              _authData
                                  .uploadFile(
                                _authData.image.path,
                                _nameController.text,
                              )
                                  .then((url) {
                                // if url is available, save vendor data to firestore
                                if (url != null) {
                                  _authData.saveVendorDataToDb(
                                    url: url,
                                    mobile: this._mobileController.text,
                                    shopName: this._nameController.text,
                                    dialog: this._shopDialogController.text,
                                  );
                                  this._formKey.currentState.reset();
                                  _appProvider.addressController.clear();
                                  _appProvider.changeIsLoading(false);
                                  // if all is well and good, move to homescreen
                                  _nav.pushReplacement(
                                    context: context,
                                    destination: HomeScreen(),
                                  );
                                } else {
                                  scaffoldMsg(
                                      "Failed to upload shop profile picture",
                                      this.refkey);
                                }
                              });
                            } else {
                              scaffoldMsg(_authData.error, this.refkey);
                            }
                          },
                        );
                      }
                    } else {
                      scaffoldMsg('Shop Profile Picture is needed', this.refkey);
                    }
                  },
                ),
              ],
            ),
          );
  }
}
