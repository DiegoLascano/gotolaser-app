// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';
import 'package:go_to_laser_store/models/category_model.dart';
import 'package:go_to_laser_store/models/image_model.dart';
import 'package:go_to_laser_store/models/tag_model.dart';

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
    this.onSale,
    this.stockStatus,
    this.averageRating,
    this.ratingCount,
    this.images,
    this.categories,
    this.tags,
    this.upsellIDs,
    this.crossSellIDs,
  });

  int id;
  String name;
  String description;
  String shortDescription;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  bool onSale;
  String stockStatus;
  String averageRating;
  int ratingCount;
  List<Image> images;
  List<Category> categories;
  List<Tag> tags;
  List<int> upsellIDs;
  List<int> crossSellIDs;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        shortDescription: json["short_description"],
        sku: json["sku"],
        price: json["price"],
        regularPrice: json["regular_price"],
        salePrice: json["sale_price"] != ""
            ? json["sale_price"]
            : json["regular_price"], // line modified by developer
        onSale: json["on_sale"],
        stockStatus: json["stock_status"],
        averageRating: json["average_rating"],
        ratingCount: json["rating_count"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
        upsellIDs: List<int>.from(json["upsell_ids"].map((x) => x)),
        crossSellIDs: List<int>.from(json["cross_sell_ids"].map((x) => x)),
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
        "on_sale": onSale,
        "stock_status": stockStatus,
        "average_rating": averageRating,
        "rating_count": ratingCount,
        "images": List<Image>.from(images.map((x) => x.toJson())),
        "categories": List<Category>.from(categories.map((x) => x.toJson())),
        "tags": List<Tag>.from(tags.map((x) => x.toJson())),
        "upsell_ids": List<dynamic>.from(upsellIDs.map((x) => x)),
        "cross_sell_ids": List<dynamic>.from(crossSellIDs.map((x) => x)),
      };

  calculateDiscount() {
    double regularPrice = double.parse(this.regularPrice);
    double salePrice =
        this.salePrice != "" ? double.parse(this.salePrice) : regularPrice;
    double discount = regularPrice - salePrice;
    double percentDiscount = (discount / regularPrice) * 100;

    return percentDiscount.round();
  }
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
