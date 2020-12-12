import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:go_to_laser_store/admob/ad_manager.dart';
import 'package:go_to_laser_store/models/coupon_model.dart';
import 'package:go_to_laser_store/screens/test_product_screen.dart';
import 'package:go_to_laser_store/screens/test_products_screen.dart';
import 'package:go_to_laser_store/screens/test_radio_button.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/styles/app_colors.dart';
import 'package:go_to_laser_store/styles/dimensions.dart';
import 'package:go_to_laser_store/widgets/common/skeleton_loader_widget.dart';
import 'package:go_to_laser_store/widgets/store/coupon_card_widget.dart';
import 'package:go_to_laser_store/widgets/store/list_items_builder.dart';
import 'package:provider/provider.dart';

class CouponsHomeScreen extends StatefulWidget {
  const CouponsHomeScreen({
    Key key,
    @required this.woocommerce,
  }) : super(key: key);

  final WoocommerceServiceBase woocommerce;

  static Widget create(BuildContext context) {
    return Provider<WoocommerceServiceBase>(
      create: (_) => WoocommerceService(),
      child: Consumer<WoocommerceServiceBase>(
        builder: (_, woocommerce, __) => CouponsHomeScreen(
          woocommerce: woocommerce,
        ),
      ),
    );
  }

  @override
  _CouponsHomeScreenState createState() => _CouponsHomeScreenState();
}

// TODO: dont show coupon code
// TODO: after tapping on coupon, show interstitial ad and then load new page
// all related information

class _CouponsHomeScreenState extends State<CouponsHomeScreen> {
  Future<List<Coupon>> coupons;
  final _nativeAdController = NativeAdmobController();
  bool _adIsLoading = false;

  StreamSubscription _subscription;

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _adIsLoading = true;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _adIsLoading = false;
        });
        break;

      default:
        break;
    }
  }

  @override
  void initState() {
    coupons = widget.woocommerce.getCoupons();
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _nativeAdController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cupones',
          style: Theme.of(context).textTheme.headline4.copyWith(),
        ),
        // actions: [
        //   IconButton(
        //     color: AppColors.primaryText,
        //     icon: Icon(Icons.search),
        //     onPressed: () {},
        //   )
        // ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // _buildNativeAd(),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNativeAd() {
    return _adIsLoading
        ? Container(
            margin: EdgeInsets.all(10.0),
            child: SkeletonLoader.rounded(
              height: 160.0,
              borderRadius: BorderRadius.circular(5.0),
            ),
          )
        : Container(
            height: 160,
            padding: EdgeInsets.all(10.0),
            // margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppColors.buttonGradientStart,
                AppColors.buttonGradientEnd,
              ]),
              borderRadius: BorderRadius.circular(buttonBorderRadius),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: NativeAdmob(
//          error: Text('Error al cargar el anuncio'),
                adUnitID: AdManager.nativeAdUnitId,
                controller: _nativeAdController,
                options: NativeAdmobOptions(
                  showMediaContent: true,
                  ratingColor: Theme.of(context).accentColor,
                  bodyTextStyle: NativeTextStyle(
                    color: AppColors.primary,
                  ),
                  adLabelTextStyle: NativeTextStyle(
                    // backgroundColor: Theme.of(context).primaryColor,
                    color: AppColors.primary,
                  ),
                  headlineTextStyle: NativeTextStyle(
                    color: AppColors.primary,
                  ),
                  callToActionStyle: NativeTextStyle(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildContent() {
    return FutureBuilder(
      future: coupons,
      builder: (context, AsyncSnapshot<List<Coupon>> snapshot) {
        return ListItemsBuilder(
          snapshot: snapshot,
          itemBuilder: (context, Coupon coupon) => Container(
            // padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: CouponCard(coupon: coupon),
          ),
          loadingAnimation: Column(
            children: [
              for (var i = 0; i < 5; i++)
                Container(
                  height: (MediaQuery.of(context).size.height - 180) / 5,
                  padding: EdgeInsets.all(10),
                  child: SkeletonLoader.rounded(
                    borderRadius: BorderRadius.circular(buttonBorderRadius),
                  ),
                ),
            ],
          ),
          nativeAd: _buildNativeAd(),
        );
      },
    );
  }
}
