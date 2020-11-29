import 'package:flutter/material.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/models/product_model.dart';

class ProductRating extends StatelessWidget {
  const ProductRating({Key key, @required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(
            double.parse(product.averageRating) > 1
                ? Icons.star
                : Icons.star_border_outlined,
            color: greySwatch.shade900,
            size: 20,
          ),
          Icon(
            double.parse(product.averageRating) > 2
                ? Icons.star
                : Icons.star_border_outlined,
            color: greySwatch.shade900,
            size: 20,
          ),
          Icon(
            double.parse(product.averageRating) > 3
                ? Icons.star
                : Icons.star_border_outlined,
            color: greySwatch.shade900,
            size: 20,
          ),
          Icon(
            double.parse(product.averageRating) > 4
                ? Icons.star
                : Icons.star_border_outlined,
            color: greySwatch.shade900,
            size: 20,
          ),
          Icon(
            double.parse(product.averageRating) == 5
                ? Icons.star
                : Icons.star_border_outlined,
            color: greySwatch.shade900,
            size: 20,
          ),
          SizedBox(width: 10),
          Text(
            '(${product.ratingCount})',
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    );
  }
}
