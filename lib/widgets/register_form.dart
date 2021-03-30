import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:foodie_vendor_app/widgets/textformfield.dart';

class RegisterForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  var _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color _primaryColor = Theme.of(context).primaryColor;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextFormField(
            labelText: "Business Name",
            prefixIcon: Icon(Icons.add_business_outlined),
            validator: (value) {
              if (value.isEmpty) {
                return "Enter Business Name";
              }
              return null;
            },
          ),
          CustomTextFormField(
            labelText: "Mobile Number",
            keyboardType: TextInputType.phone,
            prefixIcon: Icon(Icons.phone_android),
            validator: (value) {
              if (value.isEmpty) {
                return "Enter Your Mobile Number";
              }
              return null;
            },
          ),
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
                    if (_formKey.currentState.validate()) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));
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
