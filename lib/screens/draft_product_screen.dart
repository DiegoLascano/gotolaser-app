import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
// import 'package:expandable/expandable.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/models/product_variation_model.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/widgets/common/load_image_widget.dart';
import 'package:go_to_laser_store/widgets/store/product_rating_widget.dart';
import 'package:go_to_laser_store/widgets/store/related_products_widget.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({
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
        builder: (context, woocommerce, _) => ProductScreen(
          product: product,
          woocommerce: woocommerce,
        ),
      ),
    );
  }

  @override
  _ProductScreenState createState() => _ProductScreenState();

  static Widget selectDropdown(
    BuildContext context,
    Object initialValue,
    dynamic data, {
    Function onChanged,
    Function onValidate,
  }) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 50,
        width: 170,
        child: DropdownButtonFormField<ProductVariation>(
            hint: Text('Opciones'),
            value: null,
            isDense: true,
            onChanged: (ProductVariation productVariation) {
              FocusScope.of(context).requestFocus(FocusNode());
              onChanged(productVariation);
            },
            items: data?.map<DropdownMenuItem<ProductVariation>>(
              (ProductVariation productVariation) {
                return DropdownMenuItem<ProductVariation>(
                  value: productVariation,
                  child: Text(
                    productVariation.attributes.first.name +
                        " " +
                        productVariation.attributes.first.option,
                  ),
                );
              },
            )?.toList()),
      ),
    );
  }
}

class _ProductScreenState extends State<ProductScreen> {
  String get _getSavings => (double.parse(widget.product.regularPrice) -
          double.parse(widget.product.salePrice))
      .toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            _buildHeader(context),
            _buildContent(context),
            RelatedProducts.create(context, widget.product)
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
            itemCount: widget.product.images?.length,
            itemBuilder: (context, index) {
              return LoadImage(
                imageUrl: widget.product.images[index]?.url ?? null,
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
          widget.product.onSale
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.name,
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPrice(
                context,
                // discount: product.calculateDiscount().toString(),
                // onSale: product.onSale,
                // price: product.price,
                // regularPrice: product.regularPrice,
                // savings: _getSavings,
              ),
              if (widget.product.type == 'variable') _buildDropdown(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Código: ${widget.product.sku}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              ProductRating(product: widget.product)
            ],
          ),
          SizedBox(height: 5),
          Divider(thickness: 1),
          SizedBox(height: 5),
          // ExpandablePanel(
          //   header: Text(
          //     'Descripción del producto',
          //     style: Theme.of(context).textTheme.subtitle2.copyWith(
          //           fontWeight: FontWeight.bold,
          //           fontStyle: FontStyle.italic,
          //         ),
          //   ),
          //   expanded: Text(
          //     widget.product.description,
          //     style: Theme.of(context).textTheme.bodyText1,
          //   ),
          // ),
          Divider(thickness: 1),
          SizedBox(height: 5),
          // ExpandablePanel(
          //   header: Text(
          //     'Detalles de envío',
          //     style: Theme.of(context).textTheme.subtitle2.copyWith(
          //           fontWeight: FontWeight.bold,
          //           fontStyle: FontStyle.italic,
          //         ),
          //   ),
          //   expanded: Text(
          //     'Se realizan envíos de los productos a todo el país. Los métodos '
          //     'disponibles son Servientrega, Tramaco o por Cooperativas de'
          //     'Transporte.\nEl envío se coordinará una vez se realice la compra.',
          //     style: Theme.of(context).textTheme.bodyText1,
          //   ),
          // ),
          Divider(thickness: 1),
          SizedBox(height: 5),
          // ExpandablePanel(
          //   header: Row(
          //     children: [
          //       Text(
          //         'Comentarios',
          //         style: Theme.of(context).textTheme.subtitle2.copyWith(
          //               fontWeight: FontWeight.bold,
          //               fontStyle: FontStyle.italic,
          //             ),
          //       ),
          //       SizedBox(width: 10),
          //       ProductRating(product: widget.product),
          //     ],
          //   ),
          // ),
          Divider(thickness: 1),
        ],
      ),
    );
  }

  Widget _buildPrice(BuildContext context) {
    final discount = widget.product.calculateDiscount();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Text(
              '\$${widget.product.price}',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
            ),
            SizedBox(
              width: 10,
            ),
            Visibility(
              visible: widget.product.onSale,
              child: Text(
                widget.product.regularPrice != '' ||
                        widget.product.salePrice != ''
                    ? '\$${widget.product.regularPrice}  '
                    : '',
                // product.type != 'variable' ? '\$${product.regularPrice}  ' : '',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: greySwatch.shade500,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough,
                    ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: widget.product.onSale,
          child: Text(
            widget.product.regularPrice != '' || widget.product.salePrice != ''
                ? 'Ahorras \$$_getSavings ($discount%)'
                : '',
            // product.type != 'variable'
            //     ? 'Ahorras \$$_getSavings() ($discount%)'
            //     : '',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Colors.green[900]),
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _buildDropdown() {
    return FutureBuilder<List<ProductVariation>>(
      future: widget.woocommerce.getVariableProduct(widget.product.id),
      builder: (BuildContext context,
          AsyncSnapshot<List<ProductVariation>> productVariationsList) {
        if (productVariationsList.hasData) {
          final productVariations = productVariationsList.data;
          return ProductScreen.selectDropdown(
            context,
            '',
            productVariations,
            onChanged: (ProductVariation productVariation) {
              print(productVariation.price);
              widget.product.price = productVariation.price;
              widget.product.regularPrice = productVariation.regularPrice;
              widget.product.salePrice = productVariation.salePrice;
              setState(() {});
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
