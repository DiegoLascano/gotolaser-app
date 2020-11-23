import 'package:flutter/material.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/providers/products_provider.dart';
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
    widget.productsProvider.fetchProducts(_page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.productsProvider.setLoadingState(LoadMoreStatus.LOADING);
        widget.productsProvider.fetchProducts(++_page);
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
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            _buildFilters(),
            Flexible(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 50,
      child: Row(
        children: [
          Flexible(
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Buscar',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey,
                  filled: true),
            ),
          ),
          SizedBox(width: 15),
          Container(
            child: PopupMenuButton(
              onSelected: (sortBy) {},
              itemBuilder: (BuildContext context) {
                return _sortByOptions.map((option) {
                  return PopupMenuItem(
                    value: option,
                    child: Container(
                      child: Text(option.text),
                    ),
                  );
                }).toList();
              },
              icon: Icon(Icons.filter_list),
            ),
          ),
        ],
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
