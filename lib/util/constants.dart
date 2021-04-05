import 'package:flutter/material.dart';

// method for displaying scaffold messages
ScaffoldFeatureController scaffoldMsg(
    String msg, GlobalKey<ScaffoldState> refkey2) {
  return refkey2.currentState.showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}
