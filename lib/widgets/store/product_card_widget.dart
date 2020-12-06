/// This widget is a card to show a product with few details such as
/// price and short description

import 'package:flutter/material.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/screens/store/product_screen.dart';
import 'package:go_to_laser_store/styles/app_colors.dart';
import 'package:go_to_laser_store/styles/dimensions.dart';
import 'package:go_to_laser_store/widgets/common/load_image_widget.dart';
import 'package:go_to_laser_store/widgets/common/primary_button.dart';
import 'package:go_to_laser_store/widgets/store/product_rating_widget.dart';

class ProductCard extends StatelessWidget {
  ProductCard({@required this.product});

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
            _buildImage(context, product),
            _buildDescription(context, product),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, Product product) {
    return Stack(
      children: [
        Container(
          child: LoadImage(
            imageUrl: product.images[0]?.url ?? null,
          ),
        ),
        product.onSale
            ? Positioned(
                top: 5.0,
                right: 5.0,
                child: SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: PrimaryButton(
                    // padding: 2,
                    onPressed: null,
                    child: Icon(
                      Icons.local_offer,
                      color: AppColors.primary,
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
          Row(
            children: [
              ProductRating(product: product),
              SizedBox(width: 10),
              Text(
                '(${product.ratingCount})',
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
          SizedBox(height: 5),
          _buildDiscountBadge(context, product),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${product.price}',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
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

  Widget _buildDiscountBadge(BuildContext context, Product product) {
    return product.onSale
        ? Container(
            height: 26,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.green[900], width: 1.0),
              borderRadius: BorderRadius.circular(15),
              color: Colors.green[200],
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: product.type == 'variable'
                        ? ''
                        : '\$${product.regularPrice}  ',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: AppColors.primaryText,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 15,
                        ),
                  ),
                  TextSpan(
                    text: product.type == 'variable'
                        ? 'Múltiples descuentos'
                        : '(${product.calculateDiscount()}% desc.)',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: AppColors.primaryText,
                          fontSize: 15,
                        ),
                  )
                ],
              ),
            ),
          )
        : SizedBox(height: 24);
  }
}
