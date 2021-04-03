import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:location/location.dart';

// My exports
import 'package:image_picker/image_picker.dart';

class AuthProvider with ChangeNotifier {
  // Public Variables
  final picker = ImagePicker();
  String pickerError = '';
  bool isPicAvailable = false;
  String error = '';
  String _collection = "vendors";
  String email = '';

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Private Variables
  File _image;
  double _shopLatitude;
  double _shopLongitude;
  String _shopAddress;
  String _placeName;

  // Getters
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

  // function for getting current address of users
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

  // Register vendor using email
  Future<UserCredential> registerVendor(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = "The Password provided is too weak";
        notifyListeners();
      } else if (e.code == 'email-already-in-use') {
        this.error = "The account already exists for that email";
        notifyListeners();
      }
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
    }
    return userCredential;
  }

  // Function to upload file to firebase storage
  Future<String> uploadFile(String filePath, String name) async {
    File file = File(filePath);

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage.ref('uploads/shopProfilePic/$name').putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    String downloadURL =
        await _storage.ref('uploads/shopProfilePic/$name').getDownloadURL();
    return downloadURL;
  }

  // save vendor data to firestore
  Future<void> saveVendorDataToDb({
    String url,
    String shopName,
    String mobile,
    String dialog,
  }) {
    User user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendors =
        _firestore.collection(_collection).doc(user.uid);
    _vendors.set({
      "uid": user.uid,
      "shopName": shopName,
      "mobile": mobile,
      "dialog": dialog,
      "email": this.email,
      "address": "${this._placeName} : ${this.shopAddress}",
      "location": GeoPoint(this._shopLatitude, this._shopLongitude),
      "shopOpen": true,
      "rating": 0.00,
      "totalRating": 0,
      "isTopPicked": true,
      "accVerified": true
    });
    return null;
  }

  // Logging in with email and password
  Future<UserCredential> loggingVendor(String email, String password) async {
    UserCredential userCredential;
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      this.error = e.code; 
      notifyListeners();
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
    }
    return userCredential;
  }
}
