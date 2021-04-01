import 'dart:html';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:foodie_vendor_app/providers/app_provider.dart';
import 'package:foodie_vendor_app/providers/auth_provider.dart';
import 'package:foodie_vendor_app/widgets/textformfield.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color _primaryColor = Theme.of(context).primaryColor;
    final _authData = Provider.of<AuthProvider>(context);
    final _appProvider = Provider.of<AppProvider>(context);
    return Form(
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
              if (_passwordController.text != _confirmPasswordController.text) {
                return "Password doesn\'t match";
              }
              if (value.length < 6) {
                return "Minimum of 6 characters";
              }
              return null;
            },
          ),
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
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Couldn\'t find location...Try again')));
              }

              return null;
            },
          ),

          CustomTextFormField(
            labelText: "Shop Dialog",
            prefixIcon: Icon(Icons.comment_bank_outlined),
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: FlatButton(
                  color: _primaryColor,
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (_authData.isPicAvailable) {
                      if (_formKey.currentState.validate()) {
                        _authData
                            .registerVendor(
                                _emailController.text, _passwordController.text)
                            .then((credential) {
                          if (credential.user.uid != null) {
                            _authData
                                .uploadFile(
                                  _authData.image,
                                  _nameController.text,
                                )
                                .then((value) {
                                  
                                });
                          }
                        });
                      }
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Shop Profile Picture is needed')));
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
