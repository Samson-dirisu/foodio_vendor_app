import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider with ChangeNotifier {
  final picker = ImagePicker();
  String pickerError = "";
  bool isPicAvailable = false;

  //private variables
  File _image;
  double _shopLatitude;
  double _shopLongitude;
  String _shopAddress;
  String _placeName;

  // getters
  File get image => this._image;
  double get shopLongitude => this._shopLongitude;
  double get shopLatitude => this._shopLatitude;
  String get shopAddress => this._shopAddress;
  String get placeName => this._placeName;

  // function for selecting images from the gallery
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      this._image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = "No image selected.";
      print('No image selected.');
      notifyListeners();
    }

    return this.image;
  }

  Future getCurrentAddress() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    this._shopLatitude = _locationData.latitude;
    this._shopLongitude = _locationData.longitude;
    notifyListeners();

    final coordinates = new Coordinates(
      _locationData.latitude,
      _locationData.longitude,
    );
    var _addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var address = _addresses.first;
    this._shopAddress = address.addressLine;
    this._placeName = address.featureName;
    notifyListeners();
    return address;
  }
}
