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
// import 'package:go_to_laser_store/widgets/store/product_rating_widget.dart';
import 'package:go_to_laser_store/widgets/store/related_products_widget.dart';
import 'package:provider/provider.dart';

class TestProductScreen extends StatefulWidget {
  const TestProductScreen({
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
        builder: (context, woocommerce, _) => TestProductScreen(
          product: product,
          woocommerce: woocommerce,
        ),
      ),
    );
  }

  @override
  _TestProductScreenState createState() => _TestProductScreenState();
}

class _TestProductScreenState extends State<TestProductScreen> {
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
          Divider(height: 20, thickness: 1),
          _buildRatingRow(),
          Divider(height: 20, thickness: 1),
          if (widget.product.type == 'variable') _buildVariations(),
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
            child: ListView(
              shrinkWrap: true,
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
            width: 80.0,
            child: PrimaryButton(
              padding: 6,
              onPressed: null,
              child: Text(
                widget.product.averageRating,
                style: Theme.of(context).textTheme.button,
              ),
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
              _buildMaterialRow(materialOptions[0].options),
              Divider(height: 20, thickness: 1),
              _buildSizeRow(sizeOptions[0].options),
              Divider(height: 20, thickness: 1),
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
