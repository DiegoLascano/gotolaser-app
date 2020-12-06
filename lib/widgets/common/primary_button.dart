import 'package:flutter/material.dart';
import 'package:go_to_laser_store/styles/app_colors.dart';
import 'package:go_to_laser_store/styles/dimensions.dart' as Dimensions;

/// Gradient button that is used as the primary button in the app.
///
/// If {loading} is true, displays a circular progress indicator instead of child.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key key,
    @required this.onPressed,
    this.child,
    this.isLoading = false,
    this.borderRadius = Dimensions.buttonBorderRadius,
    this.gradientColors = const [
      AppColors.buttonGradientStart,
      AppColors.buttonGradientEnd
    ],
    this.padding = Dimensions.buttonPadding,
  }) : super(key: key);

  final void Function() onPressed;
  final Widget child;
  final bool isLoading;
  final double borderRadius;
  final List<Color> gradientColors;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            colors: gradientColors,
          ),
        ),
        padding: EdgeInsets.all(padding),
        child: Container(
          constraints: BoxConstraints(minHeight: 30),
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                )
              : child,
        ),
      ),
    );
  }
}
