import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final Widget prefixIcon;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Function (String) validator;
  CustomTextFormField({
    this.labelText,
    this.prefixIcon,
    this.keyboardType,
    this.controller,
    this.validator,
  });
  @override
  Widget build(BuildContext context) {
    Color _primaryColor = Theme.of(context).primaryColor;
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: TextFormField(
        validator: this.validator,
        controller: this.controller,
        keyboardType: this.keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: this.prefixIcon,
          labelText: this.labelText,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.grey),
          ),
          // enabledBorder: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: _primaryColor),
          ),
        ),
      ),
    );
  }
}
