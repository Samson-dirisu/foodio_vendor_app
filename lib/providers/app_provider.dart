import 'dart:io';

import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  //private variables
  File _image;
  TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = true;

  // getters
  File get image => this._image;
  TextEditingController get addressController => _addressController;
  bool get isLoading => this._isLoading;
  bool get showPassword => this._showPassword;

  // saving image to provider
  void updateImage(File image) {
    this._image = image;
    notifyListeners();
  }

  // saving current address to provider
  void updateCurrentAddress(String shopAddress, String placeName) {
    this._addressController.text = "\n $placeName \n$shopAddress ";
    notifyListeners();
  }

  // setting initial text to addressController and assigning it to provider
  void setInitialMessage() {
    this.addressController.text = "\n Locating.....\n Please wait...";
    notifyListeners();
  }

  // saving loading status to provider
  void changeIsLoading(bool isLoading) {
    this._isLoading = isLoading;
    notifyListeners();
  }

  // function to make password field visible or not
  void togglePassword() {
    this._showPassword = !this._showPassword;
    notifyListeners();
  }
}
