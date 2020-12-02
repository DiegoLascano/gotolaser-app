import 'package:flutter/material.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/providers/products_provider.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/widgets/store/search_card_widget.dart';

class ProductsSearchDelegate extends SearchDelegate<Product> {
  ProductsSearchDelegate({
    this.catergoryId,
    this.tagId,
  });

  final String catergoryId;
  final String tagId;

  final woocommerce = WoocommerceService();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return FutureBuilder(
      future: woocommerce.getProducts(
          categoryId: catergoryId, tagId: tagId, strSearch: query),
      builder:
          (BuildContext context, AsyncSnapshot<List<Product>> productsList) {
        if (productsList.hasData) {
          final products = productsList.data
              .where((element) => element.name.toLowerCase().contains(query))
              .toList();
          // print(products.length);
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return SearchCard(product: products[index]);
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
  /*
  ProductsSearch(this.productsList);

  final List<Product> productsList;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    final products = productsList
        .where((element) => element.name.toLowerCase().contains(query))
        .toList();

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return SearchCard(product: products[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    final products = productsList
        .where((element) => element.name.toLowerCase().contains(query))
        .toList();

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return SearchCard(product: products[index]);
      },
    );
  }
  */
}
