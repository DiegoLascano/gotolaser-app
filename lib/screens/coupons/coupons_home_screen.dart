import 'package:flutter/material.dart';
import 'package:go_to_laser_store/models/coupon_model.dart';
import 'package:go_to_laser_store/screens/test_product_screen.dart';
import 'package:go_to_laser_store/screens/test_products_screen.dart';
import 'package:go_to_laser_store/screens/test_radio_button.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/widgets/store/coupon_card_widget.dart';
import 'package:go_to_laser_store/widgets/store/list_items_builder.dart';
import 'package:provider/provider.dart';

class CouponsHomeScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return FutureBuilder(
      future: woocommerce.getCoupons(),
      builder: (context, AsyncSnapshot<List<Coupon>> snapshot) {
        return ListItemsBuilder(
          snapshot: snapshot,
          itemBuilder: (context, Coupon coupon) => Container(
            padding: EdgeInsets.all(10),
            child: CouponCard(coupon: coupon),
          ),
        );
      },
    );
  }
}
