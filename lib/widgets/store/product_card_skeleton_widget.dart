import 'package:flutter/material.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/widgets/common/skeleton_loader_widget.dart';

class ProductCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          _buildImage(context, _screenSize),
          _buildDescription(context, _screenSize),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context, Size _screenSize) {
    final _imageWidth = (_screenSize.width - 30.0) / 2;
    print(_imageWidth);
    return SkeletonLoader.square(
      // width: 100,
      height: _imageWidth,
      width: _imageWidth,
      // height: _screenSize.width - 30.0,
    );
  }

  Widget _buildDescription(BuildContext context, Size _screenSize) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: SkeletonLoader.rounded(
                height: 18,
                borderRadius: BorderRadius.circular(5),
              )),
          SizedBox(height: 10),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: SkeletonLoader.rounded(
                width: 50,
                height: 18,
                borderRadius: BorderRadius.circular(5),
              )),
          SizedBox(height: 10),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: SkeletonLoader.rounded(
                width: 200,
                height: 18,
                borderRadius: BorderRadius.circular(5),
              )),
          SizedBox(height: 10),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: SkeletonLoader.rounded(
                width: 100,
                height: 16,
                borderRadius: BorderRadius.circular(5),
              )),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: SkeletonLoader.rounded(
                    width: 30,
                    height: 18,
                    borderRadius: BorderRadius.circular(5),
                  )),
              Icon(
                Icons.more_horiz,
                color: greySwatch.shade300,
              )
            ],
          )
        ],
      ),
    );
  }
}
