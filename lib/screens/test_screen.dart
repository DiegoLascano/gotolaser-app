import 'package:flutter/material.dart';
import 'package:go_to_laser_store/blocs/products_bloc.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/providers/products_provider.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/widgets/store/product_card_widget.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({
    Key key,
    @required this.categoryId,
    @required this.productsBloc,
    // @required this.isLoading,
  }) : super(key: key);

  final ProductsBloc productsBloc;
  final String categoryId;
  // final bool isLoading;

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

  final _sortByOptions = [
    SortBy("popularity", "El más popular", "asc"),
    SortBy("modified", "El más nuevo", "asc"),
    SortBy("price", "Mayor precio", "desc"),
    SortBy("price", "Menor precio", "asc"),
  ];

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.productsBloc
            .getProducts(pageNumber: ++_page, categoryId: widget.categoryId);
      }
    });
    // _searchQueryController.addListener(_onSearchQuery);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.isLoading);
    widget.productsBloc
        .getProducts(pageNumber: _page, categoryId: widget.categoryId);
    // print(widget.isLoading);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('GoTo Láser'),
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

  Widget _buildContent() {
    return Container(
      child: StreamBuilder<List<Product>>(
        stream: widget.productsBloc.productsStream,
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data;
            if (products.isNotEmpty) {
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
            }
          } else if (snapshot.hasError) {
            return Text('Has error');
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return StreamBuilder<bool>(
      stream: widget.productsBloc.isLoadingStream,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final isLoading = snapshot.data;
        return Visibility(
          visible: isLoading,
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
