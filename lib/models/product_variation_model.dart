// To parse this JSON data, do
//
//     final productVariation = productVariationFromJson(jsonString);

import 'dart:convert';

import 'package:go_to_laser_store/models/product_variation_attribute_model.dart';

ProductVariation productVariationFromJson(String str) =>
    ProductVariation.fromJson(json.decode(str));

String productVariationToJson(ProductVariation data) =>
    json.encode(data.toJson());

class ProductVariation {
  ProductVariation({
    this.id,
    this.sku,
    this.description,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.onSale,
    this.attributes,
  });

  int id;
  String sku;
  String description;
  String price;
  String regularPrice;
  String salePrice;
  bool onSale;
  List<ProductVariationAttribute> attributes;

  factory ProductVariation.fromJson(Map<String, dynamic> json) =>
      ProductVariation(
        id: json["id"],
        sku: json["sku"],
        description: json["description"],
        price: json["price"],
        regularPrice: json["regular_price"],
        salePrice: json["sale_price"],
        onSale: json["on_sale"],
        attributes: List<ProductVariationAttribute>.from(json["attributes"]
                ?.map((x) => ProductVariationAttribute.fromJson(x))) ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sku": sku,
        "description": description,
        "price": price,
        "regular_price": regularPrice,
        "sale_price": salePrice,
        "on_sale": onSale,
        "attributes": List<dynamic>.from(attributes.map((x) => x.toJson())),
      };
}
