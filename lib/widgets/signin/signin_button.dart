import 'package:flutter/material.dart';

import 'package:go_to_laser_store/widgets/common/custom_flat_button.dart';

class SignInButton extends CustomFlatButton {
  SignInButton({
    @required String text,
    Color color,
    Color disabledColor,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
            child: Text(
              text,
              style: TextStyle(color: textColor),
            ),
            color: color,
            disabledColor: disabledColor,
            onPressed: onPressed);
}
