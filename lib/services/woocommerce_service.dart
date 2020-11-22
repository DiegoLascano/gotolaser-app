// import 'dart:io';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:go_to_laser_store/config.dart';
import 'package:go_to_laser_store/models/category_model.dart';
import 'package:go_to_laser_store/models/product_model.dart';

abstract class WoocommerceServiceBase {
  Future<List<Category>> getCategories();
  Future<List<Product>> getProducts(String tagId);
}

class WoocommerceService extends WoocommerceServiceBase {
  @override
  Future<List<Category>> getCategories() async {
    List<Category> categories = List<Category>();
    String url = Config.baseUrl +
        Config.categoriesUrl +
        "?consumer_key=${Config.consumerKey}&consumer_secret=${Config.consumerSecret}";

    try {
      var response = await Dio().get(url,
          options: Options(
              headers: {HttpHeaders.contentTypeHeader: "application/json"}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        categories = (response.data as List)
            .map(
              (category) => Category.fromJson(category),
            )
            .toList();
      }
      // print('categories: ${categories[0].name}');
    } on DioError catch (e) {
      print(e.response);
    }

    return categories;
  }

  @override
  Future<List<Product>> getProducts(String tagId) async {
    List<Product> products = List<Product>();
    String url = Config.baseUrl +
        Config.productsUrl +
        "?consumer_key=${Config.consumerKey}&consumer_secret=${Config.consumerSecret}&tag=$tagId";

    try {
      var response = await Dio().get(url,
          options: Options(
              headers: {HttpHeaders.contentTypeHeader: "application/json"}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        products = (response.data as List)
            .map(
              (product) => Product.fromJson(product),
            )
            .toList();
      }
      // print(products[0].name);
    } on DioError catch (e) {
      print(e.response);
    }
    return products;
  }
}
