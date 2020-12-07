import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/providers/products_provider.dart';
import 'package:go_to_laser_store/search/products_search_delegate.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/widgets/common/custom_appbar_widget.dart';
import 'package:go_to_laser_store/widgets/store/empty_content.dart';
import 'package:go_to_laser_store/widgets/store/grid_items_builder.dart';
import 'package:go_to_laser_store/widgets/store/product_card_widget.dart';
import 'package:provider/provider.dart';

// TODO: add skeleton loading to this screen
class ProductsScreen extends StatefulWidget {
  ProductsScreen({
    Key key,
    @required this.woocommerce,
    this.categoryId,
    this.tagId,
    @required this.productsProvider,
  }) : super(key: key);

  final WoocommerceService woocommerce;
  final String categoryId;
  final String tagId;
  final ProductsProvider productsProvider;

  static Widget create(
    BuildContext context, {
    String categoryId,
    String tagId,
  }) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    return Provider<WoocommerceServiceBase>(
      create: (_) => WoocommerceService(),
      child: Consumer<WoocommerceServiceBase>(
        builder: (context, woocommerce, _) => ProductsScreen(
          woocommerce: woocommerce,
          categoryId: categoryId,
          tagId: tagId,
          productsProvider: productsProvider,
        ),
      ),
    );
  }

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // TODO: check 'setState' error after ProductsProvider was added.
  int _page = 1;
  ScrollController _scrollController = ScrollController();

  final _sortByOptions = [
    SortBy("popularity", "El más popular", "asc"),
    SortBy("modified", "El más nuevo", "asc"),
    SortBy("price", "Mayor precio", "desc"),
    SortBy("price", "Menor precio", "asc"),
  ];

  @override
  void initState() {
    print(widget.categoryId);
    print(widget.tagId);
    widget.productsProvider.resetStreams();
    widget.productsProvider.setLoadingMoreState(LoadMoreStatus.INITIAL);
    widget.productsProvider.setLoadingProductsState(LoadProductsStatus.LOADING);
    widget.productsProvider.fetchProducts(_page,
        categoryId: widget.categoryId, tagId: widget.tagId);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.productsProvider.setLoadingMoreState(LoadMoreStatus.LOADING);
        widget.productsProvider.fetchProducts(++_page,
            categoryId: widget.categoryId, tagId: widget.tagId);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text('GoTo Láser'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.search),
      //       onPressed: () {
      //         showSearch(
      //           context: context,
      //           delegate:
      //               ProductsSearchDelegate(catergoryId: widget.categoryId),
      //         );
      //       },
      //     ),
      //     _buildFilterAction(),
      //   ],
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // _buildCustomAppbar(context),
                CustomAppbar(actions: [
                  IconButton(
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: ProductsSearchDelegate(
                          catergoryId: widget.categoryId,
                          tagId: widget.tagId,
                        ),
                      );
                    },
                  ),
                  _buildFilterAction(),
                ]),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 50),
                height: 50,
                child: _buildLoadingIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TODO: sortBy should not use new data, should order fetched products
  Widget _buildFilterAction() {
    return PopupMenuButton(
      padding: EdgeInsets.all(0.0),
      onSelected: (sortBy) {
        widget.productsProvider.resetStreams();
        widget.productsProvider.setSortOrder(sortBy);
        widget.productsProvider
            .setLoadingProductsState(LoadProductsStatus.LOADING);
        widget.productsProvider.fetchProducts(1,
            categoryId: widget.categoryId, tagId: widget.tagId);
      },
      itemBuilder: (BuildContext context) {
        return _sortByOptions.map((option) {
          return PopupMenuItem(
            value: option,
            child: Container(
              child: Text(
                option.text,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          );
        }).toList();
      },
      icon: Icon(
        Icons.filter_list,
        // color: greySwatch.shade900,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Consumer<ProductsProvider>(
      builder: (context, productsProvider, child) {
        return Visibility(
          visible:
              productsProvider.getLoadMoreStatus() == LoadMoreStatus.LOADING,
          child: Container(
            height: 35.0,
            width: 35.0,
            padding: EdgeInsets.fromLTRB(5, 5, 5, 20),
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return Consumer<ProductsProvider>(
      builder: (context, productsProvider, child) {
        print(productsProvider.allProducts);
        return GridItemsBuilder(
          itemsList: productsProvider.allProducts,
          isLoading: productsProvider.getLoadProductsStatus() ==
              LoadProductsStatus.LOADING,
          scrollController: _scrollController,
          itemBuilder: (context, product) => ProductCard(product: product),
        );
        // if (productsProvider.allProducts != null &&
        //     productsProvider.allProducts.length > 0 &&
        //     productsProvider.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
        //   final products = productsProvider.allProducts;
        //   return GridView.count(
        //     mainAxisSpacing: 10,
        //     crossAxisSpacing: 10,
        //     controller: _scrollController,
        //     scrollDirection: Axis.vertical,
        //     crossAxisCount: 2,
        //     childAspectRatio: 0.54,
        //     children: products
        //         .map((Product product) => ProductCard(product: product))
        //         .toList(),
        //   );
        // } else {
        //   return Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }
      },
    );
    // return FutureBuilder(
    //   future: widget.woocommerce.getProducts(categoryId: widget.categoryId),
    //   builder:
    //       (BuildContext context, AsyncSnapshot<List<Product>> productsList) {
    //     if (productsList.hasData) {
    //       final products = productsList.data;
    //       if (products != null) {
    //         return GridView.count(
    //           mainAxisSpacing: 10,
    //           crossAxisSpacing: 10,
    //           scrollDirection: Axis.vertical,
    //           crossAxisCount: 2,
    //           children: products
    //               .map((Product product) => ProductCard(product: product))
    //               .toList(),
    //         );
    //       } else {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //     } else {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //   },
    // );
  }
}
