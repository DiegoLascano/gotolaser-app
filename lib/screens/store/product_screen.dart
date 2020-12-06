import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
// import 'package:expandable/expandable.dart';
// import 'package:go_to_laser_store/color_swatches.dart';
// import 'package:go_to_laser_store/models/product_attribute_model.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/models/product_variation_attribute_model.dart';
import 'package:go_to_laser_store/models/product_variation_model.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/styles/app_colors.dart';
import 'package:go_to_laser_store/widgets/common/custom_appbar_widget.dart';
import 'package:go_to_laser_store/widgets/common/load_image_widget.dart';
import 'package:go_to_laser_store/widgets/common/primary_button.dart';
import 'package:go_to_laser_store/widgets/store/product_rating_widget.dart';
// import 'package:go_to_laser_store/widgets/store/product_rating_widget.dart';
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
      if (productVariation[0].sku != null)
        widget.product.sku = productVariation[0].sku;
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
        child: Column(
          children: [
            CustomAppbar(actions: []),
            Flexible(
              child: ListView(
                children: [
                  _buildHeader(context),
                  _buildContent(context),
                  Visibility(
                    visible: widget.product.crossSellIDs.isNotEmpty,
                    child: RelatedProducts.create(context, widget.product),
                  )
                ],
              ),
            ),
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
          // Container(
          //   margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
          //   width: 40,
          //   height: 40,
          //   decoration: BoxDecoration(
          //     color: greySwatch.shade100,
          //     borderRadius: BorderRadius.circular(100),
          //   ),
          //   child: Align(
          //     alignment: Alignment.center,
          //     child: IconButton(
          //       icon: Icon(Icons.keyboard_backspace),
          //       onPressed: () => Navigator.of(context).pop(),
          //     ),
          //   ),
          // ),
          widget.product.onSale
              ? Positioned(
                  top: 25,
                  right: 25,
                  child: SizedBox(
                    width: 80.0,
                    child: PrimaryButton(
                      padding: 6,
                      onPressed: null,
                      child: Text(
                        'Oferta',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: AppColors.primary,
                            ),
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
            style: Theme.of(context).textTheme.headline2,
          ),
          SizedBox(height: 10),
          _buildPrice(context),
          // Divider(height: 20, thickness: 1),
          if (widget.product.type == 'variable') _buildVariations(),
          Divider(height: 20, thickness: 1),
          _buildRatingRow(),
          Divider(height: 20, thickness: 1),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     // TODO: modify to show variation sku if any
          //     Text(
          //       'Código: ${widget.product.sku}',
          //       style: Theme.of(context).textTheme.bodyText1,
          //     ),
          //     ProductRating(product: widget.product)
          //   ],
          // ),
          Text(
            'Descripción del producto',
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(height: 10.0),
          Text(
            'Código: ${widget.product.sku}',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          SizedBox(height: 10.0),
          Text(
            widget.product.description,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Divider(height: 20, thickness: 1),
          Text(
            'Métodos de envío',
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(height: 10.0),
          Text(
            'El método de envío se coordinará con el comprador una vez'
            'realizado el pedido.',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_box,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Servientrega',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Icon(
                      Icons.check_box,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Cooperativa de transporte',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Icon(
                      Icons.check_box,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Tramaco Express',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 20, thickness: 1),

          // TODO: move this to a new page to display reviews
          // ExpandablePanel(
          //   header: Row(
          //     children: [
          //       Text('Comentarios',
          //           style: Theme.of(context).textTheme.headline4),
          //       SizedBox(width: 10),
          //       ProductRating(product: widget.product),
          //     ],
          //   ),
          // ),
          // Divider(height: 20, thickness: 1),
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
              style: Theme.of(context).textTheme.headline3.copyWith(
                    color: AppColors.secondary,
                  ),
            ),
            SizedBox(width: 10),
            Visibility(
              visible: widget.product.onSale,
              child: Text(
                widget.product.regularPrice != '' ||
                        widget.product.salePrice != ''
                    ? '\$${widget.product.regularPrice}  '
                    : '',
                // product.type != 'variable' ? '\$${product.regularPrice}  ' : '',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: widget.product.onSale && widget.product.salePrice != '',
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

  Widget _buildRatingRow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            // width: 80.0,
            child: PrimaryButton(
              padding: 6,
              onPressed: null,
              child: ProductRating(
                product: widget.product,
                color: AppColors.primary,
                size: 20,
              ),
              // Row(
              //   children: [
              //     Icon(
              //       Icons.star,
              //       color: AppColors.primary,
              //       size: 18,
              //     ),
              //     Text(
              //       widget.product.averageRating,
              //       style: Theme.of(context).textTheme.button,
              //     ),
              //   ],
              // ),
            ),
          ),
          RichText(
            text: TextSpan(
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: AppColors.secondary),
              children: [
                TextSpan(
                  text: widget.product.ratingCount.toString(),
                ),
                widget.product.ratingCount == 1
                    ? TextSpan(
                        text: " calificación",
                      )
                    : TextSpan(
                        text: " calificaciones",
                      )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVariations() {
    final materialOptions = widget.product.attributes
        .where((attribute) => attribute.name == 'Material')
        .toList();

    final sizeOptions = widget.product.attributes
        .where((attribute) => attribute.name == 'Tamaño')
        .toList();

    return _loadingVariations == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Divider(height: 30, thickness: 1),
              _buildMaterialRow(materialOptions[0].options),
              Divider(height: 30, thickness: 1),
              _buildSizeRow(sizeOptions[0].options),
            ],
          );
  }

  Widget _buildMaterialRow(List<String> materialOptions) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Material',
          style: Theme.of(context).textTheme.headline4,
        ),
        Row(
          children: materialOptions
              .map<Widget>(
                (productMaterial) => _buildProductMaterialBox(productMaterial),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildProductMaterialBox(String productMaterial) {
    final isSelected = productMaterial == _currentMaterial;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentMaterial = productMaterial;
            _updatePrice();
          });
        },
        child: Container(
          height: 40,
          width: 110,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      )
                    ]
                  : [],
              color: isSelected
                  ? AppColors.secondary
                  : Colors.grey.withOpacity(0.4)),
          child: Center(
            child: Text(
              productMaterial.split('.').last,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: isSelected
                        ? AppColors.secondaryText
                        : AppColors.primaryText,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSizeRow(List<String> sizeOptions) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tamaño',
          style: Theme.of(context).textTheme.headline4,
        ),
        Row(
          children: sizeOptions
              .map<Widget>(
                (productSize) => _buildProductSizeBox(productSize),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildProductSizeBox(String productSize) {
    final isSelected = productSize == _currentSize;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentSize = productSize;
            _updatePrice();
          });
        },
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      )
                    ]
                  : [],
              color: isSelected
                  ? AppColors.secondary
                  : Colors.grey.withOpacity(0.4)),
          child: Center(
            child: Text(
              productSize[0],
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: isSelected
                        ? AppColors.secondaryText
                        : AppColors.primaryText,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';
// import 'package:expandable/expandable.dart';
// import 'package:go_to_laser_store/color_swatches.dart';
// import 'package:go_to_laser_store/models/product_attribute_model.dart';
// import 'package:go_to_laser_store/models/product_model.dart';
// import 'package:go_to_laser_store/models/product_variation_attribute_model.dart';
// import 'package:go_to_laser_store/models/product_variation_model.dart';
// import 'package:go_to_laser_store/services/woocommerce_service.dart';
// import 'package:go_to_laser_store/widgets/common/custom_appbar_widget.dart';
// import 'package:go_to_laser_store/widgets/common/load_image_widget.dart';
// import 'package:go_to_laser_store/widgets/store/product_rating_widget.dart';
// import 'package:go_to_laser_store/widgets/store/related_products_widget.dart';
// import 'package:provider/provider.dart';
//
// class ProductScreen extends StatefulWidget {
//   const ProductScreen({
//     Key key,
//     @required this.product,
//     @required this.woocommerce,
//   }) : super(key: key);
//
//   final Product product;
//   final WoocommerceService woocommerce;
//
//   static Widget create(BuildContext context, Product product) {
//     return Provider<WoocommerceServiceBase>(
//       create: (_) => WoocommerceService(),
//       child: Consumer<WoocommerceServiceBase>(
//         builder: (context, woocommerce, _) => ProductScreen(
//           product: product,
//           woocommerce: woocommerce,
//         ),
//       ),
//     );
//   }
//
//   @override
//   _ProductScreenState createState() => _ProductScreenState();
//
//   // static Widget selectDropdown(
//   //   BuildContext context,
//   //   Object initialValue,
//   //   dynamic data, {
//   //   Function onChanged,
//   //   Function onValidate,
//   // }) {
//   //   return Align(
//   //     alignment: Alignment.topLeft,
//   //     child: Container(
//   //       height: 50,
//   //       width: 170,
//   //       child: DropdownButtonFormField<ProductVariation>(
//   //           hint: Text('Opciones'),
//   //           value: null,
//   //           isDense: true,
//   //           onChanged: (ProductVariation productVariation) {
//   //             FocusScope.of(context).requestFocus(FocusNode());
//   //             onChanged(productVariation);
//   //           },
//   //           items: data?.map<DropdownMenuItem<ProductVariation>>(
//   //             (ProductVariation productVariation) {
//   //               return DropdownMenuItem<ProductVariation>(
//   //                 value: productVariation,
//   //                 child: Text(
//   //                   productVariation.attributes.first.name +
//   //                       " " +
//   //                       productVariation.attributes.first.options[0],
//   //                 ),
//   //               );
//   //             },
//   //           )?.toList()),
//   //     ),
//   //   );
//   // }
// }
//
// class _ProductScreenState extends State<ProductScreen> {
//   String get _getSavings => (double.parse(widget.product.regularPrice) -
//           double.parse(widget.product.salePrice))
//       .toStringAsFixed(2);
//
//   String _currentMaterial;
//   String _currentSize;
//   bool _loadingVariations = false;
//   List<ProductVariation> productVariations;
//
//   void _setDefaultAttributes() {
//     List<ProductVariation> productVariation = productVariations
//         .where((ProductVariation productVariation) =>
//             productVariation.price == widget.product.price)
//         .toList();
//
//     List<ProductVariationAttribute> materialAttribute = productVariation[0]
//         .attributes
//         .where((attribute) => attribute.name == "Material")
//         .toList();
//
//     List<ProductVariationAttribute> sizeAttribute = productVariation[0]
//         .attributes
//         .where((attribute) => attribute.name == "Tamaño")
//         .toList();
//
//     _currentMaterial = materialAttribute[0].option;
//     _currentSize = sizeAttribute[0].option;
//   }
//
//   void _fetchProductVariations() async {
//     _loadingVariations = true;
//     productVariations =
//         await widget.woocommerce.getVariableProduct(widget.product.id);
//     print(productVariations);
//     _loadingVariations = false;
//     _setDefaultAttributes();
//     setState(() {});
//     return;
//   }
//
//   void _updatePrice() {
//     // if (_currentSize == null) _currentSize = "Mediano";
//     // if (_currentMaterial == null) _currentMaterial = "MDF sencillo";

//     List<ProductVariation> productVariation = productVariations
//         ?.where((ProductVariation productVariation) =>
//             productVariation.attributes
//                     ?.where((productVariationAttributes) =>
//                         productVariationAttributes.name == "Tamaño")
//                     ?.toList()[0]
//                     .option ==
//                 _currentSize &&
//             productVariation.attributes
//                     ?.where((productVariationAttributes) =>
//                         productVariationAttributes.name == "Material")
//                     ?.toList()[0]
//                     .option ==
//                 _currentMaterial)
//         ?.toList();
//
//     if (productVariation != null) {
//       widget.product.price = productVariation[0].price;
//       if (productVariation[0].onSale) {
//         widget.product.regularPrice = productVariation[0].regularPrice;
//         widget.product.salePrice = productVariation[0].salePrice;
//       } else {
//         widget.product.regularPrice = '';
//         widget.product.salePrice = '';
//       }
//     }
//   }
//
//   @override
//   void initState() {
//     _fetchProductVariations();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             CustomAppbar(actions: []),
//             Flexible(
//               child: ListView(
//                 children: [
//                   _buildHeader(context),
//                   _buildContent(context),
//                   Visibility(
//                     visible: widget.product.crossSellIDs.isNotEmpty,
//                     child: RelatedProducts.create(context, widget.product),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader(BuildContext context) {
//     final _screenSize = MediaQuery.of(context).size;
//     return Container(
//       height: _screenSize.width,
//       child: Stack(
//         children: [
//           Swiper(
//             pagination: SwiperPagination(),
//             // control: SwiperControl(
//             //   padding: EdgeInsets.symmetric(horizontal: 10),
//             //   color: greySwatch.shade700,
//             // ),
//             viewportFraction: 1,
//             scale: 1,
//             itemCount: widget.product.images?.length,
//             itemBuilder: (context, index) {
//               return LoadImage(
//                 imageUrl: widget.product.images[index]?.url ?? null,
//               );
//             },
//           ),
//           // Container(
//           //   margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
//           //   width: 40,
//           //   height: 40,
//           //   decoration: BoxDecoration(
//           //     color: greySwatch.shade100,
//           //     borderRadius: BorderRadius.circular(100),
//           //   ),
//           //   child: Align(
//           //     alignment: Alignment.center,
//           //     child: IconButton(
//           //       icon: Icon(Icons.keyboard_backspace),
//           //       onPressed: () => Navigator.of(context).pop(),
//           //     ),
//           //   ),
//           // ),
//           widget.product.onSale
//               ? Positioned(
//                   top: 25,
//                   right: 25,
//                   child: Container(
//                     padding: EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       color: Colors.green[100],
//                       borderRadius: BorderRadius.circular(30),
//                       border: Border.all(color: Colors.green[900], width: 1.0),
//                     ),
//                     child: Text(
//                       'Oferta',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.green[900],
//                       ),
//                     ),
//                   ),
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildContent(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.product.name,
//             style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
//           ),
//           SizedBox(height: 10),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildPrice(context),
//               SizedBox(height: 10),
//               if (widget.product.type == 'variable')
//                 _loadingVariations == true
//                     ? Center(
//                         child: CircularProgressIndicator(),
//                       )
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _buildMaterialDropdown(),
//                           _buildSizeDropdown()
//                         ],
//                       ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Código: ${widget.product.sku}',
//                 style: Theme.of(context).textTheme.bodyText1,
//               ),
//               ProductRating(product: widget.product)
//             ],
//           ),
//           SizedBox(height: 5),
//           Divider(thickness: 1),
//           SizedBox(height: 5),
//           ExpandablePanel(
//             header: Text(
//               'Descripción del producto',
//               style: Theme.of(context).textTheme.subtitle2.copyWith(
//                     fontWeight: FontWeight.bold,
//                     fontStyle: FontStyle.italic,
//                   ),
//             ),
//             expanded: Text(
//               widget.product.description,
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//           ),
//           Divider(thickness: 1),
//           SizedBox(height: 5),
//           ExpandablePanel(
//             header: Text(
//               'Detalles de envío',
//               style: Theme.of(context).textTheme.subtitle2.copyWith(
//                     fontWeight: FontWeight.bold,
//                     fontStyle: FontStyle.italic,
//                   ),
//             ),
//             expanded: Text(
//               'Se realizan envíos de los productos a todo el país. Los métodos '
//               'disponibles son Servientrega, Tramaco o por Cooperativas de'
//               'Transporte.\nEl envío se coordinará una vez se realice la compra.',
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//           ),
//           Divider(thickness: 1),
//           SizedBox(height: 5),
//           ExpandablePanel(
//             header: Row(
//               children: [
//                 Text(
//                   'Comentarios',
//                   style: Theme.of(context).textTheme.subtitle2.copyWith(
//                         fontWeight: FontWeight.bold,
//                         fontStyle: FontStyle.italic,
//                       ),
//                 ),
//                 SizedBox(width: 10),
//                 ProductRating(product: widget.product),
//               ],
//             ),
//           ),
//           Divider(thickness: 1),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPrice(BuildContext context) {
//     final discount = widget.product.calculateDiscount();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.baseline,
//           children: [
//             Text(
//               '\$${widget.product.price}',
//               style: Theme.of(context).textTheme.bodyText1.copyWith(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Visibility(
//               visible: widget.product.onSale,
//               child: Text(
//                 widget.product.regularPrice != '' ||
//                         widget.product.salePrice != ''
//                     ? '\$${widget.product.regularPrice}  '
//                     : '',
//                 // product.type != 'variable' ? '\$${product.regularPrice}  ' : '',
//                 style: Theme.of(context).textTheme.bodyText1.copyWith(
//                       color: greySwatch.shade500,
//                       fontWeight: FontWeight.bold,
//                       decoration: TextDecoration.lineThrough,
//                     ),
//               ),
//             ),
//           ],
//         ),
//         Visibility(
//           visible: widget.product.onSale,
//           child: Text(
//             widget.product.regularPrice != '' || widget.product.salePrice != ''
//                 ? 'Ahorras \$$_getSavings ($discount%)'
//                 : '',
//             // product.type != 'variable'
//             //     ? 'Ahorras \$$_getSavings() ($discount%)'
//             //     : '',
//             style: Theme.of(context)
//                 .textTheme
//                 .bodyText1
//                 .copyWith(color: Colors.green[900]),
//           ),
//         ),
//         SizedBox(height: 5),
//       ],
//     );
//   }
//
//   Widget _buildMaterialDropdown() {
//     final options = widget.product.attributes
//         .where((attribute) => attribute.name == 'Material')
//         .toList();
//     return Container(
//       height: 70,
//       width: (MediaQuery.of(context).size.width - 50) / 2,
//       child: DropdownButtonFormField(
//         hint: Text('Material'),
//         decoration: fieldDecoration(context, '', ''),
//         isDense: true,
//         value: _currentMaterial,
//         items: options[0].options.map((option) {
//           return DropdownMenuItem(
//             value: option,
//             child: Text(
//               option,
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//           );
//         }).toList(),
//         onChanged: (productVariation) {
//           setState(
//             () {
//               _currentMaterial = productVariation;
//               _updatePrice();
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildSizeDropdown() {
//     final options = widget.product.attributes
//         .where((attribute) => attribute.name == 'Tamaño')
//         .toList();
//     return Container(
//       height: 70,
//       width: (MediaQuery.of(context).size.width - 50) / 2,
//       child: DropdownButtonFormField(
//         hint: Text('Size'),
//         decoration: fieldDecoration(context, '', ''),
//         isDense: true,
//         value: _currentSize,
//         items: options[0].options.map((option) {
//           return DropdownMenuItem(
//             value: option,
//             child: Text(
//               option,
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//           );
//         }).toList(),
//         onChanged: (productVariation) {
//           setState(
//             () {
//               _currentSize = productVariation;
//               _updatePrice();
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   static InputDecoration fieldDecoration(
//     BuildContext context,
//     String hintText,
//     String helperText, {
//     Widget prefixIcon,
//     Widget sufixIcon,
//   }) {
//     return InputDecoration(
//       contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//       hintText: hintText,
//       helperText: helperText,
//       prefixIcon: prefixIcon,
//       suffixIcon: sufixIcon,
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: greySwatch.shade500,
//           width: 1.0,
//         ),
//       ),
//       border: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.red,
//           width: 1.0,
//         ),
//       ),
//     );
//   }
// }
