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
    return ListView(
      children: [
        _buildBanner(),
        SectionTitle(title: 'Categorías'),
        _buildCategories(),
        SizedBox(height: 20),
        SectionTitle(
          title: 'Los más vendidos',
          description: 'Mira lo que más le gusta a las personas',
          linkText: 'Ver más',
        ),
        _buildProducts(Config.topSellingTagId),
        SizedBox(height: 20),
        SectionTitle(
          title: 'Oferta',
          description: 'Mira nuestras últimas ofertas',
          linkText: 'Ver más',
        ),
        _buildProducts(Config.offerTagId)
      ],
    );
  }

  // TODO: add promotion banner using carousel
  Widget _buildBanner() {
    return Container(
      height: 200,
      child: Center(
        child: Text('Banner de promociones'),
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
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(width: 10),
                      CategoryCard(category: categories[index]),
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
      future: woocommerce.getProducts(tagId: tagId, pageSize: 6),
      builder:
          (BuildContext context, AsyncSnapshot<List<Product>> productsList) {
        if (productsList.hasData) {
          final products = productsList.data;
          if (products != null) {
            return Container(
              padding: EdgeInsets.all(10),
              child: GridView.count(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                scrollDirection: Axis.vertical,
                crossAxisCount: 2,
                childAspectRatio: 1.15,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: products
                    .map(
                        (Product product) => ProductThumbnail(product: product))
                    .toList(),
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
