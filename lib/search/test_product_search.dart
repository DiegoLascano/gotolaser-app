import 'package:flutter/material.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/widgets/common/load_image_widget.dart';
import 'package:go_to_laser_store/widgets/store/search_card_widget.dart';

class TestProductsSearch extends SearchDelegate<Product> {
  TestProductsSearch(this.products);
  final Stream<List<Product>> products;

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

    return StreamBuilder<List<Product>>(
      stream: products,
      builder: (context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data
              .where((element) => element.name.toLowerCase().contains(query))
              .toList();
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return SearchCard(product: products[index]);
            },
          );
        } else if (snapshot.hasError) {
          return Container();
        }
        return Container();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return StreamBuilder<List<Product>>(
      stream: products,
      builder: (context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data
              .where((element) => element.name.toLowerCase().contains(query))
              .toList();
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return SearchCard(product: products[index]);
            },
          );
        } else if (snapshot.hasError) {
          return Container();
        }
        return Container();
      },
    );
  }
}
