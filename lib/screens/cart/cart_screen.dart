import 'package:flutter/material.dart';
import 'package:go_to_laser_store/blocs/products_bloc.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/screens/test_products_screen.dart';
import 'package:go_to_laser_store/screens/test_store_home_screen.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/widgets/store/product_card_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FlatButton(
              child: Text('test products listing screen'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      TestProductsScreen.create(context, 17.toString()),
                ),
              ),
            ),
            FlatButton(
              child: Text('test store homme screen'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TestStoreHomeScreen.create(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
