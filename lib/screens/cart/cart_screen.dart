import 'package:flutter/material.dart';
import 'package:go_to_laser_store/blocs/products_bloc.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/screens/test_screen.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/widgets/store/product_card_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FlatButton(
          child: Text('test screen'),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TestScreen.create(context, 17.toString()),
            ),
          ),
        ),
      ),
    );
  }
}
