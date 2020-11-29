/// This widget is a card to show a product with few details such as
/// price and short description

import 'package:flutter/material.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/screens/store/product_screen.dart';
import 'package:go_to_laser_store/widgets/common/load_image_widget.dart';
import 'package:go_to_laser_store/widgets/store/product_rating_widget.dart';

class ProductCard extends StatelessWidget {
  ProductCard({@required this.product});

  final Product product;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProductScreen(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            _buildImage(product),
            _buildDescription(context, product),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(Product product) {
    return Stack(
      children: [
        Container(
          child: LoadImage(
            imageUrl: product.images[0]?.url ?? null,
          ),
        ),
        product.calculateDiscount() > 0
            ? Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.green[900], width: 1.0),
                  ),
                  child: Text(
                    'Oferta',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[900],
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _buildDescription(BuildContext context, Product product) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              product.name,
              style: Theme.of(context).textTheme.bodyText1,
              maxLines: 2,
            ),
          ),
          SizedBox(height: 5),
          ProductRating(product: product),
          SizedBox(height: 5),
          _buildDiscountBadge(product),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${product.price}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.more_horiz,
                    color: greySwatch.shade600,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDiscountBadge(Product product) {
    return product.calculateDiscount() > 0
        ? Container(
            height: 24,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green[900], width: 1.0),
              borderRadius: BorderRadius.circular(15),
              color: Colors.green[100],
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '\$${product.regularPrice}  ',
                    style: TextStyle(
                        color: Colors.green[900],
                        decoration: TextDecoration.lineThrough),
                  ),
                  TextSpan(
                    text: '(${product.calculateDiscount()}% desc.)',
                    style: TextStyle(
                      color: Colors.green[900],
                    ),
                  )
                ],
              ),
            ),
          )
        : SizedBox(height: 24);
  }
}
