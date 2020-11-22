import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_to_laser_store/models/category_model.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/widgets/store/category_card_widget.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key key, @required this.woocommerce}) : super(key: key);

  final WoocommerceService woocommerce;

  static Widget create(BuildContext context) {
    return Provider<WoocommerceServiceBase>(
      create: (_) => WoocommerceService(),
      child: Consumer<WoocommerceServiceBase>(
        builder: (context, woocommerce, _) =>
            ProductsScreen(woocommerce: woocommerce),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          _buildHeader(),
          _buildContent(),
        ],
      )),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 75,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.deepPurple),
      child: Center(
        child: Text('GoTo Láser'),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTitle('Categorías', 'Descr', 'Ver Mas'),
              _buildCategories(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title, [String description, String linkText]) {
    return Container(
      decoration: BoxDecoration(color: Colors.amberAccent),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              linkText != null
                  ? InkWell(
                      child: Text(linkText),
                      onTap: () {},
                    )
                  : SizedBox(width: 0),
            ],
          ),
          description != null ? Text(description) : SizedBox(height: 0),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return FutureBuilder(
      future: woocommerce.getCategories(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Category>> categoriesList) {
        if (categoriesList.hasData) {
          final categories = categoriesList.data;
          return Container(
            height: 125,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    CategoryCard(category: categories[index]),
                    SizedBox(width: 10)
                  ],
                );
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
