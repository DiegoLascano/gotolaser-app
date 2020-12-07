/// This widget is used in the home page of the store
/// It is intended to show only a small image in the listview

import 'package:flutter/material.dart';
import 'package:go_to_laser_store/models/category_model.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/screens/store/product_screen.dart';
import 'package:go_to_laser_store/screens/test_product_screen.dart';
import 'package:go_to_laser_store/widgets/common/load_image_widget.dart';

class ProductThumbnail extends StatelessWidget {
  ProductThumbnail({@required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProductScreen.create(context, product),
        ),
      ),
      child: Container(
        // height: 100,
        // width: 150,
        // margin: EdgeInsets.symmetric(horizontal: 5),
        // padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: LoadImage(
          imageUrl: product.images[0]?.url ?? null,
        ),
      ),
    );
  }
}
