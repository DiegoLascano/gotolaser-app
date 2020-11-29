import 'package:flutter/material.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/widgets/store/product_thumbnail_widget.dart';
import 'package:go_to_laser_store/widgets/store/related_thumbnail_widget.dart';
import 'package:provider/provider.dart';

class RelatedProducts extends StatelessWidget {
  const RelatedProducts({
    Key key,
    @required this.product,
    @required this.woocommerce,
  }) : super(key: key);

  final Product product;
  final WoocommerceService woocommerce;

  static Widget create(BuildContext context, Product product) {
    return Provider<WoocommerceServiceBase>(
      create: (_) => WoocommerceService(),
      child: Consumer<WoocommerceServiceBase>(
        builder: (context, woocommerce, _) => RelatedProducts(
          woocommerce: woocommerce,
          product: product,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: woocommerce.getProducts(productsIds: product.crossSellIDs),
      builder:
          (BuildContext context, AsyncSnapshot<List<Product>> productsList) {
        if (productsList.hasData) {
          final products = productsList.data;
          if (products != null) {
            return Container(
              child: GridView.count(
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                scrollDirection: Axis.vertical,
                crossAxisCount: 2,
                childAspectRatio: 1.15,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: products
                    .map((Product product) =>
                        RelatedProductThumbnail(product: product))
                    .toList(),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
