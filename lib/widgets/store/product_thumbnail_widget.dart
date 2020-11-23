/// This widget is used in the home page of the store
/// It is intended to show only a small image in the listview

import 'package:flutter/material.dart';
import 'package:go_to_laser_store/models/category_model.dart';
import 'package:go_to_laser_store/models/product_model.dart';

class ProductThumbnail extends StatelessWidget {
  ProductThumbnail({@required this.product});

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