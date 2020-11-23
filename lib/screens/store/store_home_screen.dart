import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_to_laser_store/config.dart';
import 'package:go_to_laser_store/models/category_model.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/widgets/store/category_card_widget.dart';
import 'package:go_to_laser_store/widgets/store/product_thumbnail_widget.dart';
import 'package:go_to_laser_store/widgets/store/section_title_widget.dart';
import 'package:provider/provider.dart';

class StoreHomeScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('GoTo Láser'),
      ),
      body: SafeArea(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SectionTitle(title: 'Categorías'),
            _buildCategories(),
            SizedBox(height: 10),
            SectionTitle(
              title: 'Los más vendidos',
              description: 'Mira lo que más le gusta a las personas',
              linkText: 'Ver más',
            ),
            _buildProducts(Config.topSellingTagId),
            SizedBox(height: 10),
            SectionTitle(
              title: 'Oferta',
              description: 'Mira nuestras últimas ofertas',
              linkText: 'Ver más',
            ),
            _buildProducts(Config.offerTagId)
          ],
        ),
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
          if (categories != null) {
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
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildProducts(String tagId) {
    return FutureBuilder(
      future: woocommerce.getProducts(tagId: tagId),
      builder:
          (BuildContext context, AsyncSnapshot<List<Product>> productsList) {
        if (productsList.hasData) {
          final products = productsList.data;
          if (products != null) {
            return Container(
              height: 125,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      ProductThumbnail(product: products[index]),
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
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
