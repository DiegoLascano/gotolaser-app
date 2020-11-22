import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  CustomFlatButton({
    this.child,
    this.color,
    this.disabledColor: Colors.grey,
    this.borderRadius: 30.0,
    this.height: 50.0,
    this.onPressed,
  }) : assert(borderRadius != null);

  final Widget child;
  final Color color;
  final Color disabledColor;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: FlatButton(
        disabledColor: disabledColor,
        // disabledTextColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: child,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        color: color,
        onPressed: onPressed,
      ),
    );
  }
}
