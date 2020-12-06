import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_to_laser_store/blocs/products_bloc.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/search/test_product_search.dart';
// import 'package:go_to_laser_store/providers/products_provider.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/widgets/store/grid_items_builder_stream.dart';
import 'package:go_to_laser_store/widgets/store/list_items_builder.dart';
import 'package:go_to_laser_store/widgets/store/product_card_widget.dart';
import 'package:provider/provider.dart';

// TODO: add dynamic title to this screen
// TODO: Change loading state animations to skeleton if possible

class TestProductsScreen extends StatefulWidget {
  const TestProductsScreen({
    Key key,
    @required this.categoryId,
    @required this.productsBloc,
  }) : super(key: key);

  final ProductsBloc productsBloc;
  final String categoryId;

  static Widget create(BuildContext context, String categoryId) {
    return Provider<WoocommerceServiceBase>(
      create: (_) => WoocommerceService(),
      child: Consumer<WoocommerceServiceBase>(
        builder: (context, woocommerce, _) => Provider<ProductsBloc>(
          create: (_) => ProductsBloc(woocommerce: woocommerce),
          dispose: (context, productsBloc) => productsBloc.dispose(),
          child: Consumer<ProductsBloc>(
            builder: (context, bloc, _) => TestProductsScreen(
              productsBloc: bloc,
              categoryId: categoryId,
            ),
          ),
        ),
      ),
    );
  }

  @override
  _TestProductsScreenState createState() => _TestProductsScreenState();
}

class _TestProductsScreenState extends State<TestProductsScreen> {
  int _page = 1;
  ScrollController _scrollController = ScrollController();

  final _sortByOptions = [
    SortBy("popularity", "El más popular", "asc"),
    SortBy("modified", "El más nuevo", "desc"),
    SortBy("price", "Mayor precio", "desc"),
    SortBy("price", "Menor precio", "asc"),
  ];

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.productsBloc.changeIsLoading(LoadingState.LOADING);
        widget.productsBloc
            .getProducts(pageNumber: ++_page, categoryId: widget.categoryId);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.productsBloc
        .getProducts(pageNumber: _page, categoryId: widget.categoryId);
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
                delegate:
                    TestProductsSearch(widget.productsBloc.productsStream),
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

  Widget _buildFilterAction() {
    return PopupMenuButton(
      onSelected: (sortBy) {
        widget.productsBloc.changeSortBy(sortBy);
        widget.productsBloc.changeProductsList(null);
        widget.productsBloc
            .getProducts(pageNumber: _page, categoryId: widget.categoryId);
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
    return Container(
      child: StreamBuilder<List<Product>>(
        stream: widget.productsBloc.productsStream,
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          return GridItemsBuilderStream(
            snapshot: snapshot,
            scrollController: _scrollController,
            itemBuilder: (context, product) => ProductCard(product: product),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return StreamBuilder<LoadingState>(
      stream: widget.productsBloc.isLoadingStream,
      initialData: LoadingState.INITIAL,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final isLoading = snapshot.data;
        return Visibility(
          visible: isLoading == LoadingState.LOADING,
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
}
