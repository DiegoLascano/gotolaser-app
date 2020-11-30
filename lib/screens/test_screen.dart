import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_to_laser_store/blocs/products_bloc.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/search/search_delegate.dart';
// import 'package:go_to_laser_store/providers/products_provider.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/widgets/store/grid_items_builder.dart';
import 'package:go_to_laser_store/widgets/store/list_items_builder.dart';
import 'package:go_to_laser_store/widgets/store/product_card_widget.dart';
import 'package:provider/provider.dart';

// TODO: add dynamic title to this screen

class TestScreen extends StatefulWidget {
  const TestScreen({
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
            builder: (context, bloc, _) => TestScreen(
              productsBloc: bloc,
              categoryId: categoryId,
            ),
          ),
        ),
      ),
    );
  }

  // static Widget create(BuildContext context, String categoryId) {
  //   return Provider<WoocommerceServiceBase>(
  //     create: (_) => WoocommerceService(),
  //     child: Consumer<WoocommerceServiceBase>(
  //       builder: (context, woocommerce, _) =>
  //           ChangeNotifierProvider<ValueNotifier<bool>>(
  //         create: (_) => ValueNotifier<bool>(false),
  //         child: Consumer<ValueNotifier<bool>>(
  //           builder: (_, isLoading, __) => Provider<ProductsBloc>(
  //             create: (_) =>
  //                 ProductsBloc(woocommerce: woocommerce, isLoading: isLoading),
  //             dispose: (context, productsBloc) => productsBloc.dispose(),
  //             child: Consumer<ProductsBloc>(
  //               builder: (context, bloc, _) => TestScreen(
  //                 productsBloc: bloc,
  //                 categoryId: categoryId,
  //                 isLoading: isLoading.value,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // static Widget create(BuildContext context, String categoryId) {
  //   return Provider<WoocommerceServiceBase>(
  //     create: (_) => WoocommerceService(),
  //     child: Consumer<WoocommerceServiceBase>(
  //       builder: (context, woocommerce, _) =>
  //           ChangeNotifierProvider<ValueNotifier<bool>>(
  //         create: (_) => ValueNotifier<bool>(false),
  //         child: Consumer<ValueNotifier<bool>>(
  //           builder: (_, isLoading, __) => Provider<ProductsBloc>(
  //             create: (_) =>
  //                 ProductsBloc(woocommerce: woocommerce, isLoading: isLoading),
  //             dispose: (context, productsBloc) => productsBloc.dispose(),
  //             child: Consumer<ProductsBloc>(
  //               builder: (context, bloc, _) => TestScreen(
  //                 productsBloc: bloc,
  //                 categoryId: categoryId,
  //                 isLoading: isLoading.value,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _page = 1;
  ScrollController _scrollController = ScrollController();
  // final _searchQueryController = TextEditingController();
  Timer _debounce;

  final _sortByOptions = [
    SortBy("popularity", "El más popular", "asc"),
    SortBy("modified", "El más nuevo", "desc"),
    SortBy("price", "Mayor precio", "desc"),
    SortBy("price", "Menor precio", "asc"),
  ];

  // void _onSearchQuery() {
  //   if (_debounce?.isActive ?? false) _debounce.cancel();
  //
  //   _debounce = Timer(const Duration(milliseconds: 500), () {
  //     widget.productsBloc.changeProductsList(null);
  //     widget.productsBloc.getProducts(
  //         pageNumber: _page,
  //         categoryId: widget.categoryId,
  //         strSearch: _searchQueryController.text);
  //     print(widget.productsBloc.productsList.length);
  //   });
  // }

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
    // _searchQueryController.addListener(_onSearchQuery);
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
                delegate: ProductsSearch(widget.productsBloc.productsStream),
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

  // Widget _buildFilters() {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 10),
  //     height: 50,
  //     child: Row(
  //       children: [
  //         Flexible(
  //           child: TextField(
  //             controller: _searchQueryController,
  //             decoration: InputDecoration(
  //               prefixIcon: Icon(
  //                 Icons.search,
  //                 color: greySwatch.shade900,
  //               ),
  //               hintText: 'Busca el artículo que necesitas',
  //               hintStyle: Theme.of(context).textTheme.bodyText1,
  //               enabledBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(30.0),
  //                 borderSide: BorderSide(color: greySwatch.shade200),
  //               ),
  //               fillColor: Colors.white,
  //               filled: true,
  //             ),
  //           ),
  //         ),
  //         SizedBox(width: 15),
  //         PopupMenuButton(
  //           onSelected: (sortBy) {
  //             widget.productsBloc.changeSortBy(sortBy);
  //             widget.productsBloc.changeProductsList(null);
  //             widget.productsBloc.getProducts(
  //                 pageNumber: _page, categoryId: widget.categoryId);
  //           },
  //           itemBuilder: (BuildContext context) {
  //             return _sortByOptions.map((option) {
  //               return PopupMenuItem(
  //                 value: option,
  //                 child: Container(
  //                   child: Text(option.text),
  //                 ),
  //               );
  //             }).toList();
  //           },
  //           icon: Icon(
  //             Icons.filter_list,
  //             color: greySwatch.shade900,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildContent() {
    return Container(
      child: StreamBuilder<List<Product>>(
        stream: widget.productsBloc.productsStream,
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          return GridItemsBuilder(
            snapshot: snapshot,
            scrollController: _scrollController,
            itemBuilder: (context, product) => ProductCard(product: product),
          );
          // return ListItemsBuilder(
          //   snapshot: snapshot,
          //   itemsBuilder: (context, products) => GridView.count(
          //     mainAxisSpacing: 10,
          //     crossAxisSpacing: 10,
          //     controller: _scrollController,
          //     scrollDirection: Axis.vertical,
          //     crossAxisCount: 2,
          //     childAspectRatio: 0.54,
          //     children: products.map((e) => ProductCard(product: e)).toList(),
          //   ),
          // );

          // if (snapshot.hasData) {
          //   final products = snapshot.data;
          //   if (products.isNotEmpty) {
          //     return GridView.count(
          //       mainAxisSpacing: 10,
          //       crossAxisSpacing: 10,
          //       controller: _scrollController,
          //       scrollDirection: Axis.vertical,
          //       crossAxisCount: 2,
          //       childAspectRatio: 0.54,
          //       children: products
          //           .map((Product product) => ProductCard(product: product))
          //           .toList(),
          //     );
          //   }
          // } else if (snapshot.hasError) {
          //   return Text('Has error');
          // }
          // return Center(
          //   child: CircularProgressIndicator(),
          // );
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
