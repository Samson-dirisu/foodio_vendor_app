import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final Function onPressed;
  final Widget child;
  SubmitButton({this.onPressed, this.child});
  @override
  Widget build(BuildContext context) {
    Color _primaryColor = Theme.of(context).primaryColor;

    return Row(
      children: [
        Expanded(
          child: FlatButton(
              color: _primaryColor,
              child: this.child,
              onPressed: this.onPressed),
        ),
      ],
    );
  }
}
