import 'dart:io';

import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  File _image;

  // getters
  File get image => _image;

  void updateImage(File image) {
    _image = image;
    notifyListeners();
  }
}
