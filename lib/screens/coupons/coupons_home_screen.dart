import 'package:flutter/material.dart';
import 'package:go_to_laser_store/screens/test_product_screen.dart';
import 'package:go_to_laser_store/screens/test_products_screen.dart';
import 'package:go_to_laser_store/screens/test_radio_button.dart';

class CouponsHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FlatButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TestRadioButton(),
              ),
            ),
            child: Text('Test radio'),
          ),
          // FlatButton(
          //   onPressed: () => Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => TestProductScreen.create(
          //         context,
          //       ),
          //     ),
          //   ),
          //   child: Text('Test New Product Screen'),
          // ),
        ],
      ),
    );
  }
}
