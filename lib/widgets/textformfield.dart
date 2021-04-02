import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final Widget prefixIcon;
  final String prefixText;
  final Widget suffixIcon;
  final EdgeInsetsGeometry contentPadding;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool obscureText;
  final int maxLines;
  final int maxLength;
  final Function(String) validator;
  CustomTextFormField({
    this.labelText,
    this.prefixIcon,
    this.prefixText,
    this.contentPadding,
    this.suffixIcon,
    this.keyboardType,
    this.controller,
    this.obscureText,
    this.maxLines,
    this.maxLength,
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
        maxLines: this.maxLines ?? 1,
        maxLength: this.maxLength,
        obscureText: this.obscureText ?? false,
        keyboardType: this.keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: this.prefixIcon,
          prefixText: this.prefixText ?? null,
          suffixIcon: this.suffixIcon,
          labelText: this.labelText,
          contentPadding: this.contentPadding ?? EdgeInsets.zero,
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: _primaryColor),
          ),
        ),
      ),
    );
  }
}
