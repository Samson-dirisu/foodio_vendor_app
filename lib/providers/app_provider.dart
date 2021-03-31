import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodie_vendor_app/providers/auth_provider.dart';

class AppProvider with ChangeNotifier {
  AuthProvider _authProvider = AuthProvider();
  //private variables
  File _image;
  TextEditingController _addressController = TextEditingController() ;

  // getters
  File get image => _image;
  TextEditingController get addressController => _addressController;

  void updateImage(File image) {
    _image = image;
    notifyListeners();
  }

  void updateCurrentAddress(String shopAddress, String placeName) {
    this._addressController.text = "\n $placeName \n$shopAddress ";
    notifyListeners();
  }

  void setInitialMessage() {
    this.addressController.text = "\n Locating.....\n Please wait...";
    notifyListeners();
  }
}
