import 'dart:io';

import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  //private variables
  File _image;
  TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  // getters
  File get image => this._image;
  TextEditingController get addressController => _addressController;
  bool get isLoading => this._isLoading;

  void updateImage(File image) {
    this._image = image;
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

  void changeIsLoading(bool isLoading) {
    this._isLoading = isLoading;
    notifyListeners();
  }
}
