import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:expandable/expandable.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/models/product_attribute_model.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/models/product_variation_attribute_model.dart';
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

  // static Widget selectDropdown(
  //   BuildContext context,
  //   Object initialValue,
  //   dynamic data, {
  //   Function onChanged,
  //   Function onValidate,
  // }) {
  //   return Align(
  //     alignment: Alignment.topLeft,
  //     child: Container(
  //       height: 50,
  //       width: 170,
  //       child: DropdownButtonFormField<ProductVariation>(
  //           hint: Text('Opciones'),
  //           value: null,
  //           isDense: true,
  //           onChanged: (ProductVariation productVariation) {
  //             FocusScope.of(context).requestFocus(FocusNode());
  //             onChanged(productVariation);
  //           },
  //           items: data?.map<DropdownMenuItem<ProductVariation>>(
  //             (ProductVariation productVariation) {
  //               return DropdownMenuItem<ProductVariation>(
  //                 value: productVariation,
  //                 child: Text(
  //                   productVariation.attributes.first.name +
  //                       " " +
  //                       productVariation.attributes.first.options[0],
  //                 ),
  //               );
  //             },
  //           )?.toList()),
  //     ),
  //   );
  // }
}

class _ProductScreenState extends State<ProductScreen> {
  String get _getSavings => (double.parse(widget.product.regularPrice) -
          double.parse(widget.product.salePrice))
      .toStringAsFixed(2);

  String _currentMaterial;
  String _currentSize;
  bool _loadingVariations = false;
  List<ProductVariation> productVariations;

  void _setDefaultAttributes() {
    List<ProductVariation> productVariation = productVariations
        .where((ProductVariation productVariation) =>
            productVariation.price == widget.product.price)
        .toList();

    List<ProductVariationAttribute> materialAttribute = productVariation[0]
        .attributes
        .where((attribute) => attribute.name == "Material")
        .toList();

    List<ProductVariationAttribute> sizeAttribute = productVariation[0]
        .attributes
        .where((attribute) => attribute.name == "Tamaño")
        .toList();

    _currentMaterial = materialAttribute[0].option;
    _currentSize = sizeAttribute[0].option;
  }

  void _fetchProductVariations() async {
    _loadingVariations = true;
    productVariations =
        await widget.woocommerce.getVariableProduct(widget.product.id);
    print(productVariations);
    _loadingVariations = false;
    _setDefaultAttributes();
    setState(() {});
    return;
  }

  void _updatePrice() {
    // if (_currentSize == null) _currentSize = "Mediano";
    // if (_currentMaterial == null) _currentMaterial = "MDF sencillo";

    // TODO: set loadingState
    List<ProductVariation> productVariation = productVariations
        ?.where((ProductVariation productVariation) =>
            productVariation.attributes
                    ?.where((productVariationAttributes) =>
                        productVariationAttributes.name == "Tamaño")
                    ?.toList()[0]
                    .option ==
                _currentSize &&
            productVariation.attributes
                    ?.where((productVariationAttributes) =>
                        productVariationAttributes.name == "Material")
                    ?.toList()[0]
                    .option ==
                _currentMaterial)
        ?.toList();

    if (productVariation != null) {
      widget.product.price = productVariation[0].price;
      if (productVariation[0].onSale) {
        widget.product.regularPrice = productVariation[0].regularPrice;
        widget.product.salePrice = productVariation[0].salePrice;
      } else {
        widget.product.regularPrice = '';
        widget.product.salePrice = '';
      }
    }
  }

  @override
  void initState() {
    _fetchProductVariations();
    super.initState();
  }

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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPrice(context),
              SizedBox(height: 10),
              if (widget.product.type == 'variable')
                _loadingVariations == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMaterialDropdown(),
                          _buildSizeDropdown()
                        ],
                      ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TODO: modify to show variation sku if any
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
          ExpandablePanel(
            header: Text(
              'Descripción del producto',
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
            ),
            expanded: Text(
              widget.product.description,
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
                ProductRating(product: widget.product),
              ],
            ),
          ),
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

  Widget _buildMaterialDropdown() {
    final options = widget.product.attributes
        .where((attribute) => attribute.name == 'Material')
        .toList();
    return Container(
      height: 70,
      width: (MediaQuery.of(context).size.width - 50) / 2,
      child: DropdownButtonFormField(
        hint: Text('Material'),
        decoration: fieldDecoration(context, '', ''),
        isDense: true,
        value: _currentMaterial,
        items: options[0].options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(
              option,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        }).toList(),
        onChanged: (productVariation) {
          setState(
            () {
              _currentMaterial = productVariation;
              _updatePrice();
            },
          );
        },
      ),
    );
  }

  Widget _buildSizeDropdown() {
    final options = widget.product.attributes
        .where((attribute) => attribute.name == 'Tamaño')
        .toList();
    return Container(
      height: 70,
      width: (MediaQuery.of(context).size.width - 50) / 2,
      child: DropdownButtonFormField(
        hint: Text('Size'),
        decoration: fieldDecoration(context, '', ''),
        isDense: true,
        value: _currentSize,
        items: options[0].options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(
              option,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        }).toList(),
        onChanged: (productVariation) {
          setState(
            () {
              _currentSize = productVariation;
              _updatePrice();
            },
          );
        },
      ),
    );
  }

  static InputDecoration fieldDecoration(
    BuildContext context,
    String hintText,
    String helperText, {
    Widget prefixIcon,
    Widget sufixIcon,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: sufixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: greySwatch.shade500,
          width: 1.0,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1.0,
        ),
      ),
    );
  }
}
