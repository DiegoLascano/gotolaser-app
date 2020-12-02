// To parse this JSON data, do
//
//     final attribute = attributeFromJson(jsonString);

import 'dart:convert';

ProductVariationAttribute productVariationAttributeFromJson(String str) => ProductVariationAttribute.fromJson(json.decode(str));

String productVariationAttributeToJson(ProductVariationAttribute data) => json.encode(data.toJson());

class ProductVariationAttribute {
  ProductVariationAttribute({
    this.id,
    this.name,
    this.option,
  });

  int id;
  String name;
  String option;

  factory ProductVariationAttribute.fromJson(Map<String, dynamic> json) => ProductVariationAttribute(
    id: json["id"],
    name: json["name"],
    option: json["option"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "option": option,
  };
}
