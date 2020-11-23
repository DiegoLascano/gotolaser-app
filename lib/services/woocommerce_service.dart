// import 'dart:io';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:go_to_laser_store/config.dart';
import 'package:go_to_laser_store/models/category_model.dart';
import 'package:go_to_laser_store/models/product_model.dart';

abstract class WoocommerceServiceBase {
  Future<List<Category>> getCategories();
  Future<List<Product>> getProducts({
    int pageNumber,
    int pageSize,
    String strSearch,
    String tagId,
    String categoryId,
    String sortBy,
    String sortOrder = "asc",
  });
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
  Future<List<Product>> getProducts({
    int pageNumber,
    int pageSize,
    String strSearch,
    String tagId,
    String categoryId,
    String sortBy,
    String sortOrder = "asc",
  }) async {
    List<Product> products = List<Product>();
    String params = '';
    if (strSearch != null) params += "&search=$strSearch";
    if (pageSize != null) params += "&per_page=$pageSize";
    if (pageNumber != null) params += "&page=$pageNumber";
    if (tagId != null) params += "&tag=$tagId";
    if (categoryId != null) params += "&category=$categoryId";
    if (sortBy != null) params += "&orderby=$sortBy";
    if (sortOrder != null) params += "&order=$sortOrder";

    String url = Config.baseUrl +
        Config.productsUrl +
        "?consumer_key=${Config.consumerKey}&consumer_secret=${Config.consumerSecret}${params.toString()}";

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
      print("products fetched: ${products.length}");
    } on DioError catch (e) {
      print(e.response);
    }
    return products;
  }
}
