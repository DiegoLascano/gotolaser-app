import 'package:flutter/material.dart';
import 'package:go_to_laser_store/color_swatches.dart';

class CustomRadioWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final double width;
  final double height;

  CustomRadioWidget({
    this.value,
    this.groupValue,
    this.onChanged,
    this.width = 40.0,
    this.height = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          onChanged(this.value);
        },
        child: Container(
          height: this.height,
          width: this.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: value == groupValue
                ? purpleSwatch.shade700
                : greySwatch.shade400,
          ),
          // decoration: ShapeDecoration(
          //   shape: CircleBorder(),
          //   gradient: LinearGradient(
          //     colors: [
          //       Color(0xFF49EF3E),
          //       Color(0xFF06D89A),
          //     ],
          //   ),
          // ),
          child: Center(
            child: Text(
              value.toString(),
              style: TextStyle(
                color: value == groupValue ? Colors.white : greySwatch.shade900,
              ),
            ),
            // child: Container(
            //   height: this.height - 8,
            //   width: this.width - 8,
            //   decoration: ShapeDecoration(
            //     shape: CircleBorder(),
            //     gradient: LinearGradient(
            //       colors: value == groupValue
            //           ? [
            //               Color(0xFFE13684),
            //               Color(0xFFFF6EEC),
            //             ]
            //           : [
            //               Theme.of(context).scaffoldBackgroundColor,
            //               Theme.of(context).scaffoldBackgroundColor,
            //             ],
            //     ),
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}
