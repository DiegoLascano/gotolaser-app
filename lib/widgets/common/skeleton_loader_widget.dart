import 'package:flutter/material.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const SkeletonLoader._({
    Key key,
    this.width: double.infinity,
    this.height: double.infinity,
    this.borderRadius: const BorderRadius.all(Radius.circular(0)),
  }) : super(key: key);

  const SkeletonLoader.square({
    double width,
    double height,
  }) : this._(width: width, height: height);

  const SkeletonLoader.rounded({
    double width,
    double height,
    BorderRadius borderRadius: const BorderRadius.all(
      Radius.circular(4),
    ),
  }) : this._(
          width: width,
          height: height,
          borderRadius: borderRadius,
        );

  @override
  Widget build(BuildContext context) => SkeletonAnimation(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: greySwatch.shade300,
            borderRadius: borderRadius,
          ),
        ),
      );
}
