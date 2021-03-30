import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider with ChangeNotifier {
  File image;
  final picker = ImagePicker();
  String pickerError = "";
  bool isPicAvailable = false;

  // getters
  // File get image => _image;

  // function for selecting images from the gallery
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = "No image selected.";
      print('No image selected.');
      notifyListeners();
    }

    return this.image;
  }
}
