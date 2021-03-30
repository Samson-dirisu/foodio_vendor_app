import 'package:flutter/material.dart';
import 'package:foodie_vendor_app/providers/app_provider.dart';
import 'package:foodie_vendor_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ShopPicCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthProvider>(context);
    final _appProvider = Provider.of<AppProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        child: SizedBox(
          height: 150,
          width: 150,
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _appProvider.image == null
                  ? Center(
                      child: Text(
                      "Add Shop Image",
                      style: TextStyle(color: Colors.grey),
                    ))
                  : Image.file(_appProvider.image, fit: BoxFit.fill),
            ),
          ),
        ),
        onTap: () {
          _authProvider.getImage().then((image) {
            _appProvider.updateImage(image);
            if (_appProvider.image != null) {
              _authProvider.isPicAvailable = true;
            }
            print(_appProvider.image.path);
          });
        },
      ),
    );
  }
}
// image_picker: ^0.6.7+22
