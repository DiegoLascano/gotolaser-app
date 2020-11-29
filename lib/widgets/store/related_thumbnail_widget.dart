import 'package:flutter/material.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/widgets/common/load_image_widget.dart';

class RelatedProductThumbnail extends StatelessWidget {
  RelatedProductThumbnail({@required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: LoadImage(
            imageUrl: product.images[0]?.url ?? null,
          ),
        ),
        Positioned(
          left: 5,
          bottom: 5,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: greySwatch.shade100, width: 1.0),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.local_offer,
                  color: Colors.green[900],
                  size: 15,
                ),
                SizedBox(width: 3),
                Text(
                  '\$${product.regularPrice}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
