// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';
import 'package:go_to_laser_store/models/category_model.dart';
import 'package:go_to_laser_store/models/image_model.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.id,
    this.name,
    this.description,
    this.shortDescription,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.stockStatus,
    this.images,
    this.categories,
  });

  int id;
  String name;
  String description;
  String shortDescription;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  String stockStatus;
  List<Image> images;
  List<Category> categories;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        shortDescription: json["short_description"],
        sku: json["sku"],
        price: json["price"],
        regularPrice: json["regular_price"],
        salePrice: json["sale_price"],
        stockStatus: json["stock_status"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "short_description": shortDescription,
        "sku": sku,
        "price": price,
        "regular_price": regularPrice,
        "sale_price": salePrice,
        "stock_status": stockStatus,
        "images": List<Image>.from(images.map((x) => x.toJson())),
        "categories": List<Category>.from(categories.map((x) => x.toJson())),
      };
}
//
// class Category {
//   Category({
//     this.id,
//     this.name,
//   });
//
//   int id;
//   String name;
//
//   factory Category.fromJson(Map<String, dynamic> json) => Category(
//     id: json["id"],
//     name: json["name"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//   };
// }
//
// class Image {
//   Image({
//     this.url,
//   });
//
//   String url;
//
//   factory Image.fromJson(Map<String, dynamic> json) => Image(
//     url: json["src"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "url": url,
//   };
// }
