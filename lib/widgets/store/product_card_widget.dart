import 'package:flutter/material.dart';
import 'package:go_to_laser_store/models/category_model.dart';
import 'package:go_to_laser_store/models/product_model.dart';

class ProductCard extends StatelessWidget {
  ProductCard({@required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      width: 150,
      // margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          Text(product.name),
          // Text(category.description),
        ],
      ),
    );
  }
}
