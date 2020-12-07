import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_to_laser_store/models/coupon_model.dart';
import 'package:go_to_laser_store/styles/app_colors.dart';
import 'package:go_to_laser_store/styles/dimensions.dart';
import 'package:go_to_laser_store/widgets/common/primary_button.dart';

class CouponCard extends StatelessWidget {
  const CouponCard({
    Key key,
    this.coupon,
  }) : super(key: key);

  final Coupon coupon;

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: coupon.discountType == 'percent'
              ? [AppColors.gradientStart1, AppColors.gradientEnd1]
              : coupon.discountType == 'fixed_cart'
                  ? [AppColors.gradientStart2, AppColors.gradientEnd2]
                  : [AppColors.gradientStart3, AppColors.gradientEnd3],
        ),
      ),
      child: Row(
        children: [
          _buildLeft(context, _screenSize),
          _buildDivider(),
          _buildRight(context, _screenSize),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white54,
      ),
    );
  }

  Widget _buildLeft(BuildContext context, Size _screenSize) {
    return Container(
      height: double.infinity,
      width: (_screenSize.width - 21) / 3,
      // decoration: BoxDecoration(
      //   borderRadius:
      //       BorderRadius.horizontal(left: Radius.circular(buttonBorderRadius)),
      //   gradient: LinearGradient(
      //     colors: gradientColors,
      //   ),
      // ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              coupon.discountType == "percent" ? "Descuento" : "Ahorra",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: AppColors.primary),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: coupon.discountType != "percent",
                  child: Text(
                    "\$ ",
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(color: AppColors.primary),
                  ),
                ),
                Text(
                  coupon.discountType == "percent"
                      ? coupon.amount.split('.')[0]
                      : coupon.amount,
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: AppColors.primary),
                ),
                Visibility(
                  visible: coupon.discountType == "percent",
                  child: Text(
                    " %",
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRight(BuildContext context, Size _screenSize) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 2 * (_screenSize.width - 21) / 3,
      height: double.infinity,
      // decoration: BoxDecoration(
      //   borderRadius:
      //       BorderRadius.horizontal(right: Radius.circular(buttonBorderRadius)),
      //   color: Colors.white,
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            coupon.code,
            style: Theme.of(context)
                .textTheme
                .headline2
                .copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    coupon.usageLimit != null
                        ? coupon.usageLimit.toString()
                        : '',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    coupon.usageLimit != null ? ' cupones disponibles' : '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: AppColors.primary),
                  )
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.info,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  Text(
                    coupon.discountType == "percent"
                        ? " Todo el pedido"
                        : coupon.discountType == "fixed_product"
                            ? " Un solo producto"
                            : " Todo el pedido",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: AppColors.primary),
                  )
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  Text(
                    " ${coupon.dateExpires?.split("T")[0] ?? ''}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: AppColors.primary),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

/*
@override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
      height: 125,
      width: double.infinity,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(buttonBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          _buildLeft(context, _screenSize),
          _buildRight(context, _screenSize),
        ],
      ),
    );
  }

  Widget _buildLeft(BuildContext context, Size _screenSize) {
    return Container(
      height: double.infinity,
      width: (_screenSize.width - 20) / 3,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.horizontal(left: Radius.circular(buttonBorderRadius)),
        gradient: LinearGradient(
          colors: gradientColors,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              coupon.discountType == "percent" ? "Descuento" : "Ahorra",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: AppColors.primary),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: coupon.discountType != "percent",
                  child: Text(
                    "\$ ",
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(color: AppColors.primary),
                  ),
                ),
                Text(
                  coupon.discountType == "percent"
                      ? coupon.amount.split('.')[0]
                      : coupon.amount,
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: AppColors.primary),
                ),
                Visibility(
                  visible: coupon.discountType == "percent",
                  child: Text(
                    " %",
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRight(BuildContext context, Size _screenSize) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 2 * (_screenSize.width - 20) / 3,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.horizontal(right: Radius.circular(buttonBorderRadius)),
        color: Colors.white,
      ),
      child: Text(coupon.description),
    );
  }
 */
