import 'package:flutter/material.dart';
import 'package:foodie_vendor_app/providers/app_provider.dart';
import 'package:foodie_vendor_app/providers/auth_provider.dart';
import 'package:foodie_vendor_app/screens/landing_screens/home_screen.dart';
import 'package:foodie_vendor_app/util/constants.dart';
import 'package:foodie_vendor_app/util/navigators.dart';
import 'package:provider/provider.dart';

class SubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController shopDialogController;
  SubmitButton({
    this.emailController,
    this.formKey,
    this.passwordController,
    this.nameController,
    this.mobileController,
    this.shopDialogController,
  });

  final Nav _nav = Nav();
  @override
  Widget build(BuildContext context) {
    Color _primaryColor = Theme.of(context).primaryColor;

    // method for displaying scaffold messages
    ScaffoldFeatureController scaffoldMsg( String msg) {
      return Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }

    

    // providers
    final _authData = Provider.of<AuthProvider>(context);
    final _appProvider = Provider.of<AppProvider>(context);
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            color: _primaryColor,
            child: Text(
              "Register",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              // do this only if profile picture is available
              if (_authData.isPicAvailable) {
                // check if form requirement are meant
                if (this.formKey.currentState.validate()) {
                  _appProvider.changeIsLoading(false);
                  _authData
                      .registerVendor(
                          emailController.text, passwordController.text)
                      .then((credential) {
                    if (credential.user.uid != null) {
                      _authData
                          .uploadFile(
                        _authData.image.path,
                        nameController.text,
                      )
                          .then((url) {
                        // if url is available, save vendor data to firestore
                        if (url != null) {
                          _authData.saveVendorDataToDb(
                            url: url,
                            mobile: this.mobileController.text,
                            shopName: this.nameController.text,
                            dialog: this.shopDialogController.text,
                          );
                          this.formKey.currentState.reset();
                          _appProvider.addressController.clear();
                          _appProvider.changeIsLoading(false);
                          // if all is well and good, move to homescreen
                          _nav.pushReplacement(
                            context: context,
                            destination: HomeScreen(),
                          );
                        } else {
                          scaffoldMsg("Failed to upload shop profile picture");
                        }
                      });
                    } else {
                      scaffoldMsg(_authData.error);
                    }
                  });
                }
              } else {
                scaffoldMsg('Shop Profile Picture is needed');
              }
            },
          ),
        ),
      ],
    );
  }
}
