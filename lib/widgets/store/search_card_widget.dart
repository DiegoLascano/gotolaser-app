import 'package:flutter/material.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/screens/store/product_screen.dart';
import 'package:go_to_laser_store/widgets/common/load_image_widget.dart';
import 'package:go_to_laser_store/widgets/store/product_rating_widget.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({Key key, this.product}) : super(key: key);
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
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
        child: Row(
          children: [
            _buildImage(),
            Expanded(child: _buildDescription(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: 120.0,
        width: 120.0,
        child: LoadImage(
          imageUrl: product.images[0]?.url ?? null,
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Container(
      // width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 16,
                ),
          ),
          SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                '\$${product.price}',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
              ),
              SizedBox(width: 10),
              Visibility(
                visible: product.onSale,
                child: Text(
                  '\$${product.regularPrice}  ',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 14,
                      ),
                ),
              ),
            ],
          ),
          ProductRating(product: product),
        ],
      ),
    );
  }
}
