/// This widget is a card to show a product with few details such as
/// price and short description

import 'package:flutter/material.dart';
import 'package:go_to_laser_store/models/product_model.dart';

class ProductCard extends StatelessWidget {
  ProductCard({@required this.product});

  final Product product;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(color: Colors.grey),
      child: Text(product.name),
    );
  }
}
