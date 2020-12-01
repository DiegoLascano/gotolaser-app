import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/providers/products_provider.dart';
import 'package:go_to_laser_store/search/products_search.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/widgets/store/product_card_widget.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  ProductsScreen({
    Key key,
    @required this.woocommerce,
    @required this.categoryId,
    @required this.productsProvider,
  }) : super(key: key);

  final WoocommerceService woocommerce;
  final String categoryId;
  final ProductsProvider productsProvider;

  static Widget create(BuildContext context, String categoryId) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    return Provider<WoocommerceServiceBase>(
      create: (_) => WoocommerceService(),
      child: Consumer<WoocommerceServiceBase>(
        builder: (context, woocommerce, _) => ProductsScreen(
          woocommerce: woocommerce,
          categoryId: categoryId,
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
    widget.productsProvider.resetStreams();
    widget.productsProvider.setLoadingState(LoadMoreStatus.INITIAL);
    widget.productsProvider.fetchProducts(_page, categoryId: widget.categoryId);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.productsProvider.setLoadingState(LoadMoreStatus.LOADING);
        widget.productsProvider
            .fetchProducts(++_page, categoryId: widget.categoryId);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('GoTo Láser'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductsSearch(widget.productsProvider.allProducts),
              );
            },
          ),
          _buildFilterAction(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            Column(
              children: [
                // _buildFilters(),
                Flexible(child: _buildContent()),
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

  Widget _buildFilterAction() {
    return PopupMenuButton(
      onSelected: (sortBy) {
        widget.productsProvider.resetStreams();
        widget.productsProvider.setSortOrder(sortBy);
        widget.productsProvider
            .fetchProducts(_page, categoryId: widget.categoryId);
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

  Widget _buildContent() {
    return Consumer<ProductsProvider>(
      builder: (context, productsProvider, child) {
        if (productsProvider.allProducts != null &&
            productsProvider.allProducts.length > 0 &&
            productsProvider.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
          final products = productsProvider.allProducts;
          return GridView.count(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            crossAxisCount: 2,
            childAspectRatio: 0.54,
            children: products
                .map((Product product) => ProductCard(product: product))
                .toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
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
