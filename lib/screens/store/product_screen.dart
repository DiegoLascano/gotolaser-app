import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:expandable/expandable.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/widgets/common/load_image_widget.dart';
import 'package:go_to_laser_store/widgets/store/product_rating_widget.dart';
import 'package:go_to_laser_store/widgets/store/related_products_widget.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  // static Widget create(BuildContext context, Product product) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            _buildHeader(context),
            _buildContent(context),
            RelatedProducts.create(context, product)
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
      height: _screenSize.width,
      child: Stack(
        children: [
          Swiper(
            pagination: SwiperPagination(),
            // control: SwiperControl(
            //   padding: EdgeInsets.symmetric(horizontal: 10),
            //   color: greySwatch.shade700,
            // ),
            viewportFraction: 1,
            scale: 1,
            itemCount: product.images?.length,
            itemBuilder: (context, index) {
              return LoadImage(
                imageUrl: product.images[index]?.url ?? null,
              );
            },
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: greySwatch.shade100,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          product.onSale
              ? Positioned(
                  top: 25,
                  right: 25,
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
                        fontSize: 18,
                        color: Colors.green[900],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final savings =
        (double.parse(product.regularPrice) - double.parse(product.salePrice))
            .toStringAsFixed(2);
    final discount = product.calculateDiscount();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Text(
                    '\$${product.price}',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Visibility(
                    visible: product.onSale,
                    child: Text(
                      '\$${product.regularPrice}  ',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: greySwatch.shade500,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,
                          ),
                    ),
                  ),
                ],
              ),
              ProductRating(product: product)
            ],
          ),
          Visibility(
            visible: product.onSale,
            child: Text(
              'Ahorras \$$savings ($discount%)',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.green[900]),
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Código: ${product.sku}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 5),
          Divider(thickness: 1),
          SizedBox(height: 5),
          ExpandablePanel(
            header: Text(
              'Descripción del producto',
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
            ),
            expanded: Text(
              product.description,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Divider(thickness: 1),
          SizedBox(height: 5),
          ExpandablePanel(
            header: Text(
              'Detalles de envío',
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
            ),
            expanded: Text(
              'Se realizan envíos de los productos a todo el país. Los métodos '
              'disponibles son Servientrega, Tramaco o por Cooperativas de'
              'Transporte.\nEl envío se coordinará una vez se realice la compra.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Divider(thickness: 1),
          SizedBox(height: 5),
          ExpandablePanel(
            header: Row(
              children: [
                Text(
                  'Comentarios',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                ),
                SizedBox(width: 10),
                ProductRating(product: product),
              ],
            ),
          ),
          Divider(thickness: 1),
        ],
      ),
    );
  }
}
