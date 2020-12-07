import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:go_to_laser_store/admob/ad_manager.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/config.dart';
import 'package:go_to_laser_store/models/category_model.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/search/products_search_delegate.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/styles/app_colors.dart';
import 'package:go_to_laser_store/styles/dimensions.dart';
import 'package:go_to_laser_store/widgets/common/custom_appbar_widget.dart';
import 'package:go_to_laser_store/widgets/common/skeleton_loader_widget.dart';
import 'package:go_to_laser_store/widgets/store/category_card_widget.dart';
import 'package:go_to_laser_store/widgets/store/empty_content.dart';
import 'package:go_to_laser_store/widgets/store/product_thumbnail_widget.dart';
import 'package:go_to_laser_store/widgets/store/section_title_widget.dart';
import 'package:provider/provider.dart';

// TODO: add PullToRefresh feature to this screen
// TODO: activate AdMob service and place one or more nativeAds
// TODO: handle error and empty content screen????
class StoreHomeScreen extends StatefulWidget {
  const StoreHomeScreen({Key key, @required this.woocommerce})
      : super(key: key);

  final WoocommerceService woocommerce;

  static Widget create(BuildContext context) {
    return Provider<WoocommerceServiceBase>(
      create: (_) => WoocommerceService(),
      child: Consumer<WoocommerceServiceBase>(
        builder: (context, woocommerce, _) =>
            StoreHomeScreen(woocommerce: woocommerce),
      ),
    );
  }

  @override
  _StoreHomeScreenState createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> {
  final _nativeAdController = NativeAdmobController();
  double _nativeAdHeight = 0.0;
  bool _adIsLoading = false;

  StreamSubscription _subscription;

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _nativeAdHeight = 0.0;
          _adIsLoading = true;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _nativeAdHeight = 200.0;
          _adIsLoading = false;
        });
        break;

      default:
        break;
    }
  }

  @override
  void initState() {
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _nativeAdController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Text(
          'Catálogo Interactivo',
          style: Theme.of(context).textTheme.headline4.copyWith(),
        ),
        actions: [
          IconButton(
            color: AppColors.primaryText,
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductsSearchDelegate(),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // _buildCustomAppbar(),
            Flexible(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(10.0),
        //   child: Align(
        //     alignment: Alignment.centerLeft,
        //     child: Text(
        //       'Catálogo Digital',
        //       style: Theme.of(context).textTheme.headline3,
        //     ),
        //   ),
        // ),
        _buildNavtiveAd(),
        SectionTitle(title: 'Categorías'),
        _buildCategories(),
        SizedBox(height: 20),
        SectionTitle(
          title: 'Los más vendidos',
          description: 'Mira lo que más le gusta a las personas',
          linkText: 'Ver más',
          tagId: Config.topSellingTagId,
        ),
        _buildProducts(Config.topSellingTagId),
        SizedBox(height: 20),
        SectionTitle(
          title: 'Oferta',
          description: 'Mira nuestras últimas ofertas',
          linkText: 'Ver más',
          tagId: Config.offerTagId,
        ),
        _buildProducts(Config.offerTagId),
        _buildNavtiveAd()
      ],
    );
  }

  Widget _buildCustomAppbar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      height: 60,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('GoTo Láser', style: Theme.of(context).textTheme.bodyText2),
            Text('Catálogo Digital',
                style: Theme.of(context).textTheme.subtitle1),
          ],
        ),
      ),
    );
  }

  Widget _buildNavtiveAd() {
    return _adIsLoading
        ? Container(
            margin: EdgeInsets.all(10.0),
            child: SkeletonLoader.rounded(
              height: 200.0,
              borderRadius: BorderRadius.circular(buttonBorderRadius),
            ),
          )
        : Container(
            height: 200,
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppColors.buttonGradientStart,
                AppColors.buttonGradientEnd,
              ]),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: NativeAdmob(
//          error: Text('Error al cargar el anuncio'),
                adUnitID: AdManager.nativeAdUnitId,
                controller: _nativeAdController,
                options: NativeAdmobOptions(
                  showMediaContent: true,
                  ratingColor: Theme.of(context).accentColor,
                  bodyTextStyle: NativeTextStyle(
                    color: AppColors.primary,
                  ),
                  adLabelTextStyle: NativeTextStyle(
                    // backgroundColor: Theme.of(context).primaryColor,
                    color: AppColors.primary,
                  ),
                  headlineTextStyle: NativeTextStyle(
                    color: AppColors.primary,
                  ),
                  callToActionStyle: NativeTextStyle(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildCategories() {
    return FutureBuilder(
      future: widget.woocommerce.getCategories(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Category>> categoriesList) {
        if (categoriesList.hasData) {
          final categories = categoriesList.data;
          if (categories != null) {
            return Container(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(width: 10),
                      CategoryCard(category: categories[index]),
                    ],
                  );
                },
              ),
            );
          } else {
            // this is an empty content case, not likely to happen
            return EmptyContent();
          }
        } else {
          return Container(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < 4; i++) ...{
                  SizedBox(width: 10),
                  Column(
                    children: [
                      SkeletonLoader.square(
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(height: 10),
                      SkeletonLoader.rounded(
                        height: 18,
                        width: 100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ),
                }
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildProducts(String tagId) {
    return FutureBuilder(
      future: widget.woocommerce.getProducts(tagId: tagId, pageSize: 6),
      builder:
          (BuildContext context, AsyncSnapshot<List<Product>> productsList) {
        if (productsList.hasData) {
          final products = productsList.data;
          if (products.isNotEmpty) {
            return Container(
              padding: EdgeInsets.all(10),
              child: GridView.count(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                scrollDirection: Axis.vertical,
                crossAxisCount: 2,
                childAspectRatio: 1.15,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: products
                    .map(
                        (Product product) => ProductThumbnail(product: product))
                    .toList(),
              ),
            );
          } else {
            return EmptyContent();
          }
        } else {
          return _productThumbSkeleton(context);
        }
      },
    );
  }

  Widget _productThumbSkeleton(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        for (var i = 0; i < 2; i++) ...{
          Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  SkeletonLoader.square(
                    height: (_screenSize.width - 30.0) / 2.3,
                    width: (_screenSize.width - 30.0) / 2,
                  ),
                  SizedBox(width: 10),
                  SkeletonLoader.square(
                    height: (_screenSize.width - 30.0) / 2.3,
                    width: (_screenSize.width - 30.0) / 2,
                  ),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        },
      ],
    );
  }
}
