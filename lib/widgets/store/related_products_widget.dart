import 'package:flutter/material.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/widgets/common/skeleton_loader_widget.dart';
import 'package:go_to_laser_store/widgets/store/product_thumbnail_widget.dart';
import 'package:go_to_laser_store/widgets/store/related_thumbnail_widget.dart';
import 'package:provider/provider.dart';

class RelatedProducts extends StatefulWidget {
  const RelatedProducts({
    Key key,
    @required this.product,
    @required this.woocommerce,
  }) : super(key: key);

  final Product product;
  final WoocommerceService woocommerce;

  // TODO: add ProductsProvider()
  // TODO: change futures to fetch data from Provider instead of Woocommerce service
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
  _RelatedProductsState createState() => _RelatedProductsState();
}

class _RelatedProductsState extends State<RelatedProducts> {
  Future<List<Product>> relatedProducts;
  @override
  void initState() {
    relatedProducts = widget.woocommerce
        .getProducts(productsIds: widget.product.crossSellIDs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context),
        SizedBox(height: 10),
        _buildGrid(),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        'Productos que te pueden interesar',
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  Widget _buildGrid() {
    return FutureBuilder(
      future: relatedProducts,
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
          return Row(
            children: [
              for (var i = 0; i < 2; i++) ...{
                if (i == 1) SizedBox(width: 2),
                SkeletonLoader.square(
                  width: (MediaQuery.of(context).size.width - 2) / 2,
                  height: (MediaQuery.of(context).size.width - 2) / 2.3,
                ),
              }
            ],
          );
        }
      },
    );
  }
}
